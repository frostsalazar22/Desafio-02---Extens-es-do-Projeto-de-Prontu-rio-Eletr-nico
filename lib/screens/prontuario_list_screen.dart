import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/prontuario.dart';
import '../services/firestore_service.dart';
import 'formulario_prontuario_screen.dart';
import 'editar_prontuario_screen.dart'; // Importar a tela de edição

class ProntuarioListScreen extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  ProntuarioListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prontuários'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<List<Prontuario>>(
        stream: firestoreService.listarProntuarios(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar os prontuários:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final prontuarios = snapshot.data ?? [];

          if (prontuarios.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum prontuário cadastrado ainda.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: prontuarios.length,
            itemBuilder: (context, index) {
              final p = prontuarios[index];
              final dataCriacao = dateFormat.format(p.data);
              final idade = DateTime.now().year - p.dataNascimento.year;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  onTap: () {
                    // Navegar para a tela de edição passando o prontuário
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditarProntuarioScreen(prontuario: p),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    child: const Icon(Icons.person, color: Colors.green),
                  ),
                  title: Text(
                    p.nomeCompleto,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Idade: $idade anos',
                          style: const TextStyle(color: Colors.black87),
                        ),
                        if (p.convenio.isNotEmpty)
                          Text('Convênio: ${p.convenio}',
                              style: const TextStyle(color: Colors.black87)),
                        if (p.alergias.isNotEmpty)
                          Text('Alergias: ${p.alergias}',
                              style: const TextStyle(color: Colors.black54)),
                        Text(
                          '📅 Criado em: $dataCriacao',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      final confirmar = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Excluir prontuário'),
                          content: Text(
                            'Deseja realmente excluir o prontuário de "${p.nomeCompleto}"?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text(
                                'Excluir',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirmar == true) {
                        await firestoreService.deletarProntuario(p.id!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Prontuário de ${p.nomeCompleto} excluído com sucesso!'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const FormularioProntuarioScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
