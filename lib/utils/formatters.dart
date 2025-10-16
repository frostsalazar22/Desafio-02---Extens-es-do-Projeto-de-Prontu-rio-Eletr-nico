import 'package:intl/intl.dart';

class Formatters {
  static final _cpfReg = RegExp(r'^(\d{3})(\d{3})(\d{3})(\d{2})$');

  /// Formata CPF: 12345678900 -> 123.456.789-00
  static String formatarCPF(String cpf) {
    final numeric = cpf.replaceAll(RegExp(r'\D'), '');
    final match = _cpfReg.firstMatch(numeric);
    if (match == null) return cpf;
    return '${match[1]}.${match[2]}.${match[3]}-${match[4]}';
  }

  /// Formata data dd/MM/yyyy
  static String formatarData(DateTime data) {
    return DateFormat('dd/MM/yyyy').format(data);
  }

  /// Formata telefone (básico)
  static String formatarTelefone(String telefone) {
    final t = telefone.replaceAll(RegExp(r'\D'), '');
    if (t.length == 11) {
      return '(${t.substring(0, 2)}) ${t.substring(2, 7)}-${t.substring(7)}';
    } else if (t.length == 10) {
      return '(${t.substring(0, 2)}) ${t.substring(2, 6)}-${t.substring(6)}';
    }
    return telefone;
  }

  /// Remove todos os caracteres não numéricos
  static String somenteNumeros(String valor) {
    return valor.replaceAll(RegExp(r'\D'), '');
  }
}
