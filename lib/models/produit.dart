import 'package:hive/hive.dart';

part 'produit.g.dart';

@HiveType(typeId: 1)
class Produit {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? code;

  @HiveField(2)
  final String? barcode;

  @HiveField(3)
  final String designation;

  @HiveField(4)
  final String? description;

  @HiveField(5)
  final double prixUnitaire;

  @HiveField(6)
  final int stock;

  @HiveField(7)
  final int stockMin;

  @HiveField(8)
  final String? categorie;

  @HiveField(9)
  final String unite;

  @HiveField(10)
  final bool actif;

  @HiveField(11)
  final DateTime? createdAt;

  @HiveField(12)
  final DateTime? updatedAt;

  Produit({
    this.id,
    this.code,
    this.barcode,
    required this.designation,
    this.description,
    required this.prixUnitaire,
    this.stock = 0,
    this.stockMin = 10,
    this.categorie,
    this.unite = 'Unité',
    this.actif = true,
    this.createdAt,
    this.updatedAt,
  });

  // Conversion depuis JSON (Supabase)
  factory Produit.fromJson(Map<String, dynamic> json) {
    return Produit(
      id: json['id'] as int?,
      code: json['code'] as String?,
      barcode: json['barcode'] as String?,
      designation: json['designation'] as String,
      description: json['description'] as String?,
      prixUnitaire: (json['prix_unitaire'] as num).toDouble(),
      stock: json['stock'] as int? ?? 0,
      stockMin: json['stock_min'] as int? ?? 10,
      categorie: json['categorie'] as String?,
      unite: json['unite'] as String? ?? 'Unité',
      actif: json['actif'] as bool? ?? true,
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
      'code': code,
      'barcode': barcode,
      'designation': designation,
      'description': description,
      'prix_unitaire': prixUnitaire,
      'stock': stock,
      'stock_min': stockMin,
      'categorie': categorie,
      'unite': unite,
      'actif': actif,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // Copie avec modifications
  Produit copyWith({
    int? id,
    String? code,
    String? barcode,
    String? designation,
    String? description,
    double? prixUnitaire,
    int? stock,
    int? stockMin,
    String? categorie,
    String? unite,
    bool? actif,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Produit(
      id: id ?? this.id,
      code: code ?? this.code,
      barcode: barcode ?? this.barcode,
      designation: designation ?? this.designation,
      description: description ?? this.description,
      prixUnitaire: prixUnitaire ?? this.prixUnitaire,
      stock: stock ?? this.stock,
      stockMin: stockMin ?? this.stockMin,
      categorie: categorie ?? this.categorie,
      unite: unite ?? this.unite,
      actif: actif ?? this.actif,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Vérifier si le stock est faible
  bool get isStockFaible => stock <= stockMin;
}
