class Validators {
  /// Verifica se o campo está vazio
  static String? obrigatorio(String? valor, {String campo = 'Campo'}) {
    if (valor == null || valor.trim().isEmpty) {
      return '$campo é obrigatório';
    }
    return null;
  }

  /// Valida CPF (básico, sem cálculo de dígito verificador)
  static String? validarCPF(String? valor) {
    if (valor == null || valor.length < 11) {
      return 'CPF inválido';
    }
    return null;
  }

  /// Valida email com regex simples
  static String? validarEmail(String? valor) {
    if (valor == null || valor.isEmpty) return 'E-mail obrigatório';
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,4}$');
    if (!emailRegex.hasMatch(valor)) return 'E-mail inválido';
    return null;
  }

  /// Valida data no formato dd/MM/yyyy
  static String? validarData(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Data obrigatória';
    }
    final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!regex.hasMatch(valor)) return 'Data inválida';
    return null;
  }

  /// Valida senha mínima de 6 caracteres
  static String? validarSenha(String? valor) {
    if (valor == null || valor.length < 6) {
      return 'Senha muito curta';
    }
    return null;
  }
}
