import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/usuario.dart';
import 'login_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Usuario? usuario;
  bool _isLoading = true;

  // Dados dos prontuários do paciente
  List<Map<String, dynamic>> consultas = [];

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      _sair();
      return;
    }

    try {
      // Busca os dados do usuário
      final userDoc =
          await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();

      if (!userDoc.exists || userDoc.data() == null) {
        throw Exception('Usuário não encontrado');
      }

      usuario = Usuario.fromMap(userDoc.id, userDoc.data()!);

      // Busca os prontuários vinculados ao paciente (pelo CPF)
      final querySnapshot = await FirebaseFirestore.instance
          .collection('prontuarios')
          .where('cpf', isEqualTo: usuario!.cpf)
          .get();

      consultas = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'nomeCompleto': data['nomeCompleto'] ?? '',
          'consultaAgendada': data['consultaAgendada'] ?? false,
          'examePendente': data['examePendente'] ?? false,
          'exameRealizado': data['exameRealizado'] ?? false,
          'descricao': data['descricao'] ?? '',
          'data': data['data'] ?? '',
        };
      }).toList();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar perfil: $e')),
      );
      _sair();
    }
  }

  Future<void> _sair() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Widget _buildConsultaItem(Map<String, dynamic> consulta) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(consulta['descricao'] ?? 'Sem descrição'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Consulta agendada: ${consulta['consultaAgendada'] ? "Sim" : "Não"}'),
            Text('Exame pendente: ${consulta['examePendente'] ? "Sim" : "Não"}'),
            Text('Exame realizado: ${consulta['exameRealizado'] ? "Sim" : "Não"}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: _sair,
          ),
        ],
      ),
      body: usuario == null
          ? const Center(child: Text('Perfil não encontrado.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            usuario!.nomeCompleto,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text('CPF: ${usuario!.cpf}'),
                          Text('Email: ${usuario!.email}'),
                          Text(
                              'Nascimento: ${usuario!.dataNascimento.day}/${usuario!.dataNascimento.month}/${usuario!.dataNascimento.year}'),
                          Text('Telefone: ${usuario!.telefone}'),
                          Text('Endereço: ${usuario!.endereco}'),
                          const SizedBox(height: 16),
                          Chip(
                            label: Text(usuario!.tipo.toUpperCase()),
                            backgroundColor: usuario!.tipo == 'medico'
                                ? Colors.blue
                                : Colors.green,
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Consultas e Exames',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  if (consultas.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Nenhuma consulta ou exame registrado.'),
                    )
                  else
                    ...consultas.map(_buildConsultaItem).toList(),
                ],
              ),
            ),
    );
  }
}
