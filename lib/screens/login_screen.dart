import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'cadastro_screen.dart';
import 'prontuario_list_screen.dart';
import 'perfil_screen.dart'; // opcional, para redirecionar pacientes

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final cpfInput = _cpfController.text.trim();
    final senha = _senhaController.text.trim();

    try {
      // 👨‍⚕️ Login fixo do administrador
      if (cpfInput == 'adm' && senha == 'senha') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login do administrador bem-sucedido!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ProntuarioListScreen()),
        );
        return;
      }

      final email = '$cpfInput@gmail.com';
      final auth = FirebaseAuth.instance;

      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) throw Exception('Usuário inválido');

      // 🔎 Recupera o perfil do Firestore
      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .get();

      final dados = doc.data();
      if (dados == null) {
        throw Exception('Usuário não encontrado no Firestore');
      }

      final tipo = dados['tipo'] ?? 'paciente';
      final nome = dados['nomeCompleto'] ?? '';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bem-vindo, $nome!')),
      );

      // 🧭 Direcionamento por tipo de usuário
      if (tipo == 'medico') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ProntuarioListScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PerfilScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no login: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro inesperado: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Acesso ao Prontuário',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cpfController,
                      decoration: const InputDecoration(
                        labelText: 'CPF (ou "adm")',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Informe seu CPF ou "adm"' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Senha (data nascimento ou "senha")',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Informe sua senha' : null,
                    ),
                    const SizedBox(height: 24),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton.icon(
                            onPressed: _login,
                            icon: const Icon(Icons.login),
                            label: const Text('Entrar'),
                          ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CadastroScreen()),
                        );
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text('Não tem conta? Cadastre-se'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
