import 'package:hive/hive.dart';

part 'parametres.g.dart';

@HiveType(typeId: 4)
class Parametres {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String nomMagasin;

  @HiveField(2)
  final String? adresse;

  @HiveField(3)
  final String? telephone;

  @HiveField(4)
  final String? email;

  @HiveField(5)
  final String? logoUrl;

  @HiveField(6)
  final String? signatureUrl;

  @HiveField(7)
  final String? cachetUrl;

  @HiveField(8)
  final String? numeroRegistre;

  @HiveField(9)
  final String? nif;

  @HiveField(10)
  final int delaiPaiementDefaut;

  @HiveField(11)
  final DateTime? createdAt;

  @HiveField(12)
  final DateTime? updatedAt;

  Parametres({
    this.id,
    required this.nomMagasin,
    this.adresse,
    this.telephone,
    this.email,
    this.logoUrl,
    this.signatureUrl,
    this.cachetUrl,
    this.numeroRegistre,
    this.nif,
    this.delaiPaiementDefaut = 45,
    this.createdAt,
    this.updatedAt,
  });

  // Conversion depuis JSON (Supabase)
  factory Parametres.fromJson(Map<String, dynamic> json) {
    return Parametres(
      id: json['id'] as int?,
      nomMagasin: json['nom_magasin'] as String,
      adresse: json['adresse'] as String?,
      telephone: json['telephone'] as String?,
      email: json['email'] as String?,
      logoUrl: json['logo_url'] as String?,
      signatureUrl: json['signature_url'] as String?,
      cachetUrl: json['cachet_url'] as String?,
      numeroRegistre: json['numero_registre'] as String?,
      nif: json['nif'] as String?,
      delaiPaiementDefaut: json['delai_paiement_defaut'] as int? ?? 45,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  // Conversion vers JSON (Supabase)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nom_magasin': nomMagasin,
      'adresse': adresse,
      'telephone': telephone,
      'email': email,
      'logo_url': logoUrl,
      'signature_url': signatureUrl,
      'cachet_url': cachetUrl,
      'numero_registre': numeroRegistre,
      'nif': nif,
      'delai_paiement_defaut': delaiPaiementDefaut,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // Copie avec modifications
  Parametres copyWith({
    int? id,
    String? nomMagasin,
    String? adresse,
    String? telephone,
    String? email,
    String? logoUrl,
    String? signatureUrl,
    String? cachetUrl,
    String? numeroRegistre,
    String? nif,
    int? delaiPaiementDefaut,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Parametres(
      id: id ?? this.id,
      nomMagasin: nomMagasin ?? this.nomMagasin,
      adresse: adresse ?? this.adresse,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      logoUrl: logoUrl ?? this.logoUrl,
      signatureUrl: signatureUrl ?? this.signatureUrl,
      cachetUrl: cachetUrl ?? this.cachetUrl,
      numeroRegistre: numeroRegistre ?? this.numeroRegistre,
      nif: nif ?? this.nif,
      delaiPaiementDefaut: delaiPaiementDefaut ?? this.delaiPaiementDefaut,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
