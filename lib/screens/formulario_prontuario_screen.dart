import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/prontuario.dart';
import '../services/firestore_service.dart';

class FormularioProntuarioScreen extends StatefulWidget {
  const FormularioProntuarioScreen({super.key});

  @override
  State<FormularioProntuarioScreen> createState() =>
      _FormularioProntuarioScreenState();
}

class _FormularioProntuarioScreenState
    extends State<FormularioProntuarioScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores dos campos
  final _nomeController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  String _sexoSelecionado = 'Masculino';
  final _cpfController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _convenioController = TextEditingController();
  final _numeroCarteirinhaController = TextEditingController();
  final _alergiasController = TextEditingController();
  final _doencasController = TextEditingController();
  final _medicamentosController = TextEditingController();
  final _descricaoController = TextEditingController();

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      try {
        final dataNasc = _dateFormat.parse(_dataNascimentoController.text);

        final novoProntuario = Prontuario(
          nomeCompleto: _nomeController.text,
          dataNascimento: dataNasc,
          sexo: _sexoSelecionado,
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
          data: DateTime.now(),
        );

        await FirestoreService().adicionarProntuario(novoProntuario);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prontuário salvo com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // Seletor de data
  Future<void> _selecionarDataNascimento() async {
    final DateTime? selecionada = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    if (selecionada != null) {
      setState(() {
        _dataNascimentoController.text = _dateFormat.format(selecionada);
      });
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _dataNascimentoController.dispose();
    _cpfController.dispose();
    _enderecoController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _convenioController.dispose();
    _numeroCarteirinhaController.dispose();
    _alergiasController.dispose();
    _doencasController.dispose();
    _medicamentosController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Prontuário'),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration:
                      const InputDecoration(labelText: 'Nome completo'),
                  validator: (v) =>
                      v!.isEmpty ? 'Informe o nome completo' : null,
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
                      v!.isEmpty ? 'Informe a data de nascimento' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _sexoSelecionado,
                  decoration: const InputDecoration(labelText: 'Sexo'),
                  items: const [
                    DropdownMenuItem(
                        value: 'Masculino', child: Text('Masculino')),
                    DropdownMenuItem(
                        value: 'Feminino', child: Text('Feminino')),
                    DropdownMenuItem(value: 'Outro', child: Text('Outro')),
                  ],
                  onChanged: (v) => setState(() => _sexoSelecionado = v!),
                ),
                TextFormField(
                  controller: _cpfController,
                  decoration: const InputDecoration(labelText: 'CPF'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _enderecoController,
                  decoration:
                      const InputDecoration(labelText: 'Endereço completo'),
                ),
                TextFormField(
                  controller: _telefoneController,
                  decoration: const InputDecoration(labelText: 'Telefone'),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  controller: _convenioController,
                  decoration: const InputDecoration(
                      labelText: 'Convênio / Plano de Saúde'),
                ),
                TextFormField(
                  controller: _numeroCarteirinhaController,
                  decoration: const InputDecoration(
                      labelText: 'Número da carteirinha'),
                ),
                TextFormField(
                  controller: _alergiasController,
                  decoration:
                      const InputDecoration(labelText: 'Alergias conhecidas'),
                ),
                TextFormField(
                  controller: _doencasController,
                  decoration: const InputDecoration(
                      labelText: 'Doenças pré-existentes'),
                ),
                TextFormField(
                  controller: _medicamentosController,
                  decoration: const InputDecoration(
                      labelText: 'Medicamentos em uso'),
                ),
                TextFormField(
                  controller: _descricaoController,
                  decoration:
                      const InputDecoration(labelText: 'Descrição / Observações'),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _salvar,
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar Prontuário'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
