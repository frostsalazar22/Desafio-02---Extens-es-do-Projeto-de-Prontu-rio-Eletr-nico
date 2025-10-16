class Usuario {
  String? id;
  final String cpf;             // usado como email para login (ex: 00011122233@gmail.com)
  final String nomeCompleto;
  final DateTime dataNascimento;
  final String email;
  final String tipo;           // 'medico' ou 'paciente'
  final String telefone;
  final String endereco;

  Usuario({
    this.id,
    required this.cpf,
    required this.nomeCompleto,
    required this.dataNascimento,
    required this.email,
    required this.tipo,
    required this.telefone,
    required this.endereco,
  });

  Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'nomeCompleto': nomeCompleto,
      'dataNascimento': dataNascimento.toIso8601String(),
      'email': email,
      'tipo': tipo,
      'telefone': telefone,
      'endereco': endereco,
    };
  }

  factory Usuario.fromMap(String id, Map<String, dynamic> map) {
    return Usuario(
      id: id,
      cpf: map['cpf'] ?? '',
      nomeCompleto: map['nomeCompleto'] ?? '',
      dataNascimento: DateTime.parse(map['dataNascimento']),
      email: map['email'] ?? '',
      tipo: map['tipo'] ?? 'paciente',
      telefone: map['telefone'] ?? '',
      endereco: map['endereco'] ?? '',
    );
  }
}
