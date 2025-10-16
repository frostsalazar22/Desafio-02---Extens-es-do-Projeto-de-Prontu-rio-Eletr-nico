import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  bool _isLoading = false;

  Future<void> _selecionarDataNascimento() async {
    final selecionada = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    if (selecionada != null) {
      _dataNascimentoController.text = _dateFormat.format(selecionada);
    }
  }

  Future<void> _cadastrarPaciente() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final cpf = _cpfController.text.replaceAll(RegExp(r'\D'), '');
      final nascimento = _dateFormat.parse(_dataNascimentoController.text);
      final email = '$cpf@gmail.com'; // padrão de email
      final senha = DateFormat('ddMMyyyy').format(nascimento); // senha: data nascimento
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      // Cria no Firebase Auth
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Salva no Firestore
      final novoUsuario = Usuario(
        cpf: cpf,
        nomeCompleto: _nomeController.text,
        dataNascimento: nascimento,
        email: email,
        tipo: 'paciente',
        telefone: _telefoneController.text,
        endereco: _enderecoController.text,
      );

      await firestore
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .set(novoUsuario.toMap());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Paciente cadastrado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao cadastrar: ${e.message}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _dataNascimentoController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Paciente'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome completo'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.length < 11 ? 'CPF inválido' : null,
              ),
              TextFormField(
                controller: _dataNascimentoController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Data de nascimento',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selecionarDataNascimento,
                  ),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe a data' : null,
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(labelText: 'Endereço completo'),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _cadastrarPaciente,
                      icon: const Icon(Icons.person_add),
                      label: const Text('Cadastrar Paciente'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
