// pasta para controle de requisições de registro
class RegisterRequest {
  // Dados Comuns
  final String userType; // 'PF' ou 'PJ'
  final String name;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String? document; // CPF ou CNPJ

  // Dados Pessoa Física (PF)
  final String? rg;
  final String? issuingAgency; // Órgão Emissor
  final String? birthDate;
  final String? motherName;
  final String? cep;
  final String? street; // Logradouro
  final String? state; // UF
  final String? socialNetworks;
  final bool? allowsCreditBureauCheck; // autorizaConsultaCredito

  // Dados Pessoa Jurídica (PJ)
  final String? companyName; // Razão Social
  final String? tradeName; // Nome Fantasia
  final String? cnae;
  final String? additionalDomains;
  final String? legalRepName;
  final String? legalRepCpf;
  final String? legalRepComplement;
  final bool? allowsPublicDbCheck; // autorizaConsultaPublica

  RegisterRequest({
    required this.userType,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    this.document,
    this.rg,
    this.issuingAgency,
    this.birthDate,
    this.motherName,
    this.cep,
    this.street,
    this.state,
    this.socialNetworks,
    this.allowsCreditBureauCheck,
    this.companyName,
    this.tradeName,
    this.cnae,
    this.additionalDomains,
    this.legalRepName,
    this.legalRepCpf,
    this.legalRepComplement,
    this.allowsPublicDbCheck,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_type': userType,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'document': document,
      if (userType == 'PF') ...{
        'rg': rg,
        'issuing_agency': issuingAgency,
        'birth_date': birthDate,
        'mother_name': motherName,
        'cep': cep,
        'street': street,
        'state': state,
        'social_networks': socialNetworks,
        'allows_credit_bureau_check': allowsCreditBureauCheck,
      },
      if (userType == 'PJ') ...{
        'company_name': companyName,
        'trade_name': tradeName,
        'cnae': cnae,
        'additional_domains': additionalDomains,
        'legal_rep_name': legalRepName,
        'legal_rep_cpf': legalRepCpf,
        'legal_rep_complement': legalRepComplement,
        'allows_public_db_check': allowsPublicDbCheck,
      },
    };
  }
}