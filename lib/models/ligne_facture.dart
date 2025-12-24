import 'package:hive/hive.dart';

part 'ligne_facture.g.dart';

@HiveType(typeId: 2)
class LigneFacture {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final int factureId;

  @HiveField(2)
  final int? produitId;

  @HiveField(3)
  final String designation;

  @HiveField(4)
  final double quantite;

  @HiveField(5)
  final double prixUnitaire;

  @HiveField(6)
  final double montant;

  @HiveField(7)
  final DateTime dateAjout;

  @HiveField(8)
  final DateTime? createdAt;

  LigneFacture({
    this.id,
    required this.factureId,
    this.produitId,
    required this.designation,
    required this.quantite,
    required this.prixUnitaire,
    required this.montant,
    required this.dateAjout,
    this.createdAt,
  });

  // Conversion depuis JSON (Supabase)
  factory LigneFacture.fromJson(Map<String, dynamic> json) {
    return LigneFacture(
      id: json['id'] as int?,
      factureId: json['facture_id'] as int,
      produitId: json['produit_id'] as int?,
      designation: json['designation'] as String,
      quantite: (json['quantite'] as num).toDouble(),
      prixUnitaire: (json['prix_unitaire'] as num).toDouble(),
      montant: (json['montant'] as num).toDouble(),
      dateAjout: json['date_ajout'] != null
          ? DateTime.parse(json['date_ajout'] as String)
          : DateTime.now(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  // Conversion vers JSON (Supabase)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'facture_id': factureId,
      'produit_id': produitId,
      'designation': designation,
      'quantite': quantite,
      'prix_unitaire': prixUnitaire,
      'montant': montant,
      'date_ajout': dateAjout.toIso8601String(),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  // Copie avec modifications
  LigneFacture copyWith({
    int? id,
    int? factureId,
    int? produitId,
    String? designation,
    double? quantite,
    double? prixUnitaire,
    double? montant,
    DateTime? dateAjout,
    DateTime? createdAt,
  }) {
    return LigneFacture(
      id: id ?? this.id,
      factureId: factureId ?? this.factureId,
      produitId: produitId ?? this.produitId,
      designation: designation ?? this.designation,
      quantite: quantite ?? this.quantite,
      prixUnitaire: prixUnitaire ?? this.prixUnitaire,
      montant: montant ?? this.montant,
      dateAjout: dateAjout ?? this.dateAjout,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
