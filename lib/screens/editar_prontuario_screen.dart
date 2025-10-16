import 'package:flutter/material.dart';
import '../models/prontuario.dart';
import '../services/firestore_service.dart';
import 'package:intl/intl.dart';

class EditarProntuarioScreen extends StatefulWidget {
  final Prontuario prontuario;

  const EditarProntuarioScreen({super.key, required this.prontuario});

  @override
  State<EditarProntuarioScreen> createState() => _EditarProntuarioScreenState();
}

class _EditarProntuarioScreenState extends State<EditarProntuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late DateTime _dataNascimento;
  late TextEditingController _sexoController;
  late TextEditingController _cpfController;
  late TextEditingController _enderecoController;
  late TextEditingController _telefoneController;
  late TextEditingController _emailController;
  late TextEditingController _convenioController;
  late TextEditingController _numeroCarteirinhaController;
  late TextEditingController _alergiasController;
  late TextEditingController _doencasController;
  late TextEditingController _medicamentosController;

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    final p = widget.prontuario;
    _nomeController = TextEditingController(text: p.nomeCompleto);
    _descricaoController = TextEditingController(text: p.descricao);
    _dataNascimento = p.dataNascimento;
    _sexoController = TextEditingController(text: p.sexo);
    _cpfController = TextEditingController(text: p.cpf);
    _enderecoController = TextEditingController(text: p.endereco);
    _telefoneController = TextEditingController(text: p.telefone);
    _emailController = TextEditingController(text: p.email);
    _convenioController = TextEditingController(text: p.convenio);
    _numeroCarteirinhaController = TextEditingController(text: p.numeroCarteirinha);
    _alergiasController = TextEditingController(text: p.alergias);
    _doencasController = TextEditingController(text: p.doencasPreExistentes);
    _medicamentosController = TextEditingController(text: p.medicamentosEmUso);
  }

  Future<void> _selecionarDataNascimento() async {
    final selecionada = await showDatePicker(
      context: context,
      initialDate: _dataNascimento,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    if (selecionada != null) {
      setState(() {
        _dataNascimento = selecionada;
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final atualizado = Prontuario(
      id: widget.prontuario.id,
      nomeCompleto: _nomeController.text,
      dataNascimento: _dataNascimento,
      sexo: _sexoController.text,
      cpf: _cpfController.text,
      endereco: _enderecoController.text,
      telefone: _telefoneController.text,
      email: _emailController.text,
      convenio: _convenioController.text,
      numeroCarteirinha: _numeroCarteirinhaController.text,
      alergias: _alergiasController.text,
      doencasPreExistentes: _doencasController.text,
      medicamentosEmUso: _medicamentosController.text,
      descricao: _descricaoController.text,
      data: DateTime.now(), // data da última atualização
    );

    await FirestoreService().updateProntuario(widget.prontuario.id!, atualizado);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Prontuário atualizado com sucesso!')),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _sexoController.dispose();
    _cpfController.dispose();
    _enderecoController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _convenioController.dispose();
    _numeroCarteirinhaController.dispose();
    _alergiasController.dispose();
    _doencasController.dispose();
    _medicamentosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Prontuário'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome Completo'),
                validator: (v) => v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
                validator: (v) => v == null || v.isEmpty ? 'Informe o CPF' : null,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _selecionarDataNascimento,
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Data de Nascimento',
                      hintText: _dateFormat.format(_dataNascimento),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _sexoController,
                decoration: const InputDecoration(labelText: 'Sexo'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(labelText: 'Endereço'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _convenioController,
                decoration: const InputDecoration(labelText: 'Convênio'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _numeroCarteirinhaController,
                decoration: const InputDecoration(labelText: 'Número da Carteirinha'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _alergiasController,
                decoration: const InputDecoration(labelText: 'Alergias'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _doencasController,
                decoration: const InputDecoration(labelText: 'Doenças Pré-existentes'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _medicamentosController,
                decoration: const InputDecoration(labelText: 'Medicamentos em Uso'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvar,
                child: const Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
