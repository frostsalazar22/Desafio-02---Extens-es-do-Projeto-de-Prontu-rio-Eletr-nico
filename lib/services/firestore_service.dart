import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/prontuario.dart';

class FirestoreService {
  // Referência fortemente tipada à coleção "prontuarios"
  final CollectionReference<Map<String, dynamic>> _prontuarios =
      FirebaseFirestore.instance.collection('prontuarios');

  /// 🟢 Adiciona um novo prontuário no Firestore
  Future<void> adicionarProntuario(Prontuario prontuario) async {
    try {
      await _prontuarios.add(prontuario.toMap());
      // ignore: avoid_print
      print('✅ [Firestore] Prontuário adicionado com sucesso!');
    } on FirebaseException catch (e) {
      print('❌ [Firestore] Erro Firebase ao adicionar prontuário: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ [Firestore] Erro desconhecido ao adicionar prontuário: $e');
      rethrow;
    }
  }

  /// 🔵 Retorna um stream com todos os prontuários em tempo real (ordenados por data)
  Stream<List<Prontuario>> listarProntuarios() {
    return _prontuarios.orderBy('data', descending: true).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          try {
            return Prontuario.fromMap(doc.id, doc.data());
          } catch (e) {
            print('⚠️ [Firestore] Erro ao converter documento ${doc.id}: $e');
            return Prontuario(
              id: doc.id,
              paciente: 'Desconhecido',
              descricao: 'Erro ao ler dados',
              data: DateTime.now(),
            );
          }
        }).toList();
      },
    );
  }

  /// 🟡 Retorna um único prontuário pelo ID (útil para edição)
  Future<Prontuario?> getProntuarioPorId(String id) async {
    try {
      final doc = await _prontuarios.doc(id).get();
      if (!doc.exists || doc.data() == null) return null;
      return Prontuario.fromMap(doc.id, doc.data()!);
    } catch (e) {
      print('❌ [Firestore] Erro ao buscar prontuário $id: $e');
      return null;
    }
  }

  /// 🟠 Atualiza um prontuário existente (para uso futuro)
  Future<void> updateProntuario(String id, Prontuario prontuario) async {
    try {
      await _prontuarios.doc(id).update(prontuario.toMap());
      print('✏️ [Firestore] Prontuário $id atualizado com sucesso.');
    } on FirebaseException catch (e) {
      print('❌ [Firestore] Erro Firebase ao atualizar prontuário: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ [Firestore] Erro desconhecido ao atualizar prontuário: $e');
      rethrow;
    }
  }

  /// 🔴 Deleta um prontuário pelo ID do documento
  Future<void> deletarProntuario(String id) async {
    try {
      await _prontuarios.doc(id).delete();
      print('🗑️ [Firestore] Prontuário $id deletado com sucesso.');
    } on FirebaseException catch (e) {
      print('❌ [Firestore] Erro Firebase ao deletar prontuário: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ [Firestore] Erro desconhecido ao deletar prontuário: $e');
      rethrow;
    }
  }
}
