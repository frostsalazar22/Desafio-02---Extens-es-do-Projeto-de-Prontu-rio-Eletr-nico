import 'package:flutter/material.dart';
import '../models/prontuario.dart';
import '../services/firestore_service.dart';

class FormularioProntuarioScreen extends StatefulWidget {
  const FormularioProntuarioScreen({super.key});

  @override
  State<FormularioProntuarioScreen> createState() => _FormularioProntuarioScreenState();
}

class _FormularioProntuarioScreenState extends State<FormularioProntuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pacienteController = TextEditingController();
  final _descricaoController = TextEditingController();

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      final novoProntuario = Prontuario(
        paciente: _pacienteController.text,
        descricao: _descricaoController.text,
        data: DateTime.now(),
      );

      await FirestoreService().adicionarProntuario(novoProntuario); // ✅ await importante

      if (!mounted) return;
      Navigator.pop(context); // Fecha a tela após salvar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Prontuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _pacienteController,
                decoration: const InputDecoration(labelText: 'Nome do Paciente'),
                validator: (value) => value!.isEmpty ? 'Informe o paciente' : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) => value!.isEmpty ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvar,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
