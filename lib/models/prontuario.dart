class Prontuario {
  String? id;
  final String nomeCompleto;
  final DateTime dataNascimento;
  final String sexo;
  final String cpf;
  final String endereco;
  final String telefone;
  final String email;
  final String convenio;
  final String numeroCarteirinha;
  final String alergias;
  final String doencasPreExistentes;
  final String medicamentosEmUso;
  final String descricao;
  final DateTime data;

  Prontuario({
    this.id,
    required this.nomeCompleto,
    required this.dataNascimento,
    required this.sexo,
    required this.cpf,
    required this.endereco,
    required this.telefone,
    required this.email,
    required this.convenio,
    required this.numeroCarteirinha,
    required this.alergias,
    required this.doencasPreExistentes,
    required this.medicamentosEmUso,
    required this.descricao,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'nomeCompleto': nomeCompleto,
      'dataNascimento': dataNascimento.toIso8601String(),
      'sexo': sexo,
      'cpf': cpf,
      'endereco': endereco,
      'telefone': telefone,
      'email': email,
      'convenio': convenio,
      'numeroCarteirinha': numeroCarteirinha,
      'alergias': alergias,
      'doencasPreExistentes': doencasPreExistentes,
      'medicamentosEmUso': medicamentosEmUso,
      'descricao': descricao,
      'data': data.toIso8601String(),
    };
  }

  factory Prontuario.fromMap(String id, Map<String, dynamic> map) {
    return Prontuario(
      id: id,
      nomeCompleto: map['nomeCompleto'] ?? '',
      dataNascimento: DateTime.parse(map['dataNascimento']),
      sexo: map['sexo'] ?? '',
      cpf: map['cpf'] ?? '',
      endereco: map['endereco'] ?? '',
      telefone: map['telefone'] ?? '',
      email: map['email'] ?? '',
      convenio: map['convenio'] ?? '',
      numeroCarteirinha: map['numeroCarteirinha'] ?? '',
      alergias: map['alergias'] ?? '',
      doencasPreExistentes: map['doencasPreExistentes'] ?? '',
      medicamentosEmUso: map['medicamentosEmUso'] ?? '',
      descricao: map['descricao'] ?? '',
      data: DateTime.parse(map['data']),
    );
  }
}
