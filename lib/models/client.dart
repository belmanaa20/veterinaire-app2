import 'package:hive/hive.dart';

part 'client.g.dart';

@HiveType(typeId: 0)
class Client {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String nom;

  @HiveField(2)
  final String? adresse;

  @HiveField(3)
  final String? telephone;

  @HiveField(4)
  final String? culture;

  @HiveField(5)
  final String? notes;

  @HiveField(6)
  final DateTime? createdAt;

  @HiveField(7)
  final DateTime? updatedAt;

  Client({
    this.id,
    required this.nom,
    this.adresse,
    this.telephone,
    this.culture,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  // Conversion depuis JSON (Supabase)
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as int?,
      nom: json['nom'] as String,
      adresse: json['adresse'] as String?,
      telephone: json['telephone'] as String?,
      culture: json['culture'] as String?,
      notes: json['notes'] as String?,
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
      'nom': nom,
      'adresse': adresse,
      'telephone': telephone,
      'culture': culture,
      'notes': notes,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // Copie avec modifications
  Client copyWith({
    int? id,
    String? nom,
    String? adresse,
    String? telephone,
    String? culture,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Client(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      adresse: adresse ?? this.adresse,
      telephone: telephone ?? this.telephone,
      culture: culture ?? this.culture,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
