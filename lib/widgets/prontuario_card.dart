import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/prontuario.dart';

class ProntuarioCard extends StatelessWidget {
  final Prontuario prontuario;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const ProntuarioCard({
    super.key,
    required this.prontuario,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final idade = DateTime.now().year - prontuario.dataNascimento.year;
    final dataFormatada = DateFormat('dd/MM/yyyy HH:mm').format(prontuario.data);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: const Icon(Icons.person, color: Colors.green),
        ),
        title: Text(
          prontuario.nomeCompleto,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Idade: $idade anos'),
              Text('Convênio: ${prontuario.convenio}'),
              if (prontuario.alergias.isNotEmpty)
                Text('Alergias: ${prontuario.alergias}'),
              Text('📅 Criado em: $dataFormatada'),
            ],
          ),
        ),
        isThreeLine: true,
        trailing: onDelete != null
            ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: onDelete,
              )
            : null,
      ),
    );
  }
}
