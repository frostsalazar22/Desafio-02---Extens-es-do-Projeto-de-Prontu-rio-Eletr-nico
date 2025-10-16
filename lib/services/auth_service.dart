import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/usuario.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _usuariosRef = FirebaseFirestore.instance.collection('usuarios');

  /// Login com Firebase Auth usando CPF + senha (data de nascimento)
  Future<Usuario?> loginComCpf(String cpf, String senha) async {
    final email = '$cpf@gmail.com';

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final uid = credential.user?.uid;
      if (uid == null) throw Exception('Usuário sem UID');

      final doc = await _usuariosRef.doc(uid).get();
      if (!doc.exists || doc.data() == null) return null;

      return Usuario.fromMap(doc.id, doc.data()!);
    } on FirebaseAuthException catch (e) {
      throw Exception('Erro de autenticação: ${e.message}');
    }
  }

  /// Login como médico (admin fixo)
  bool loginMedico(String email, String senha) {
    return email.trim() == 'adm' && senha.trim() == 'senha';
  }

  /// Cria novo paciente no Auth e salva no Firestore
  Future<void> cadastrarPaciente(Usuario usuario, String senha) async {
    final email = '${usuario.cpf}@gmail.com';

    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );

    final uid = cred.user!.uid;

    await _usuariosRef.doc(uid).set(usuario.toMap());
  }

  /// Retorna o usuário logado (do Firestore)
  Future<Usuario?> getUsuarioAtual() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _usuariosRef.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;

    return Usuario.fromMap(doc.id, doc.data()!);
  }

  /// Verifica se alguém está logado
  bool estaLogado() => _auth.currentUser != null;

  /// Retorna o UID do usuário atual
  String? get uid => _auth.currentUser?.uid;

  /// Logout geral
  Future<void> logout() async {
    await _auth.signOut();
  }
}
