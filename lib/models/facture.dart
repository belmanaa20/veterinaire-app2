import 'package:hive/hive.dart';
import 'ligne_facture.dart';

part 'facture.g.dart';

enum StatutFacture {
  ouverte,
  fermee,
  payee,
  enRetard,
}

@HiveType(typeId: 3)
class Facture {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String numero;

  @HiveField(2)
  final int? clientId;

  @HiveField(3)
  final DateTime dateFacture;

  @HiveField(4)
  final DateTime dateEcheance;

  @HiveField(5)
  final DateTime? datePaiement;

  @HiveField(6)
  final double montantTotal;

  @HiveField(7)
  final String statut;

  @HiveField(8)
  final bool estModifiable;

  @HiveField(9)
  final String? notes;

  @HiveField(10)
  final DateTime? createdAt;

  @HiveField(11)
  final DateTime? updatedAt;

  // Données liées (pas stockées en Hive)
  final String? clientNom;
  final String? clientTelephone;
  final String? clientCulture;
  final List<LigneFacture>? lignes;

  Facture({
    this.id,
    required this.numero,
    this.clientId,
    required this.dateFacture,
    required this.dateEcheance,
    this.datePaiement,
    this.montantTotal = 0,
    this.statut = 'OUVERTE',
    this.estModifiable = true,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.clientNom,
    this.clientTelephone,
    this.clientCulture,
    this.lignes,
  });

  // Conversion depuis JSON (Supabase)
  factory Facture.fromJson(Map<String, dynamic> json) {
    return Facture(
      id: json['id'] as int?,
      numero: json['numero'] as String,
      clientId: json['client_id'] as int?,
      dateFacture: DateTime.parse(json['date_facture'] as String),
      dateEcheance: DateTime.parse(json['date_echeance'] as String),
      datePaiement: json['date_paiement'] != null
          ? DateTime.parse(json['date_paiement'] as String)
          : null,
      montantTotal: (json['montant_total'] as num?)?.toDouble() ?? 0,
      statut: json['statut'] as String? ?? 'OUVERTE',
      estModifiable: json['est_modifiable'] as bool? ?? true,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      clientNom: json['client_nom'] as String?,
      clientTelephone: json['client_tel'] as String?,
      clientCulture: json['client_culture'] as String?,
    );
  }

  // Conversion vers JSON (Supabase)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'numero': numero,
      'client_id': clientId,
      'date_facture': dateFacture.toIso8601String().split('T')[0],
      'date_echeance': dateEcheance.toIso8601String().split('T')[0],
      if (datePaiement != null)
        'date_paiement': datePaiement!.toIso8601String().split('T')[0],
      'montant_total': montantTotal,
      'statut': statut,
      'est_modifiable': estModifiable,
      'notes': notes,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // Copie avec modifications
  Facture copyWith({
    int? id,
    String? numero,
    int? clientId,
    DateTime? dateFacture,
    DateTime? dateEcheance,
    DateTime? datePaiement,
    double? montantTotal,
    String? statut,
    bool? estModifiable,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? clientNom,
    String? clientTelephone,
    String? clientCulture,
    List<LigneFacture>? lignes,
  }) {
    return Facture(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      clientId: clientId ?? this.clientId,
      dateFacture: dateFacture ?? this.dateFacture,
      dateEcheance: dateEcheance ?? this.dateEcheance,
      datePaiement: datePaiement ?? this.datePaiement,
      montantTotal: montantTotal ?? this.montantTotal,
      statut: statut ?? this.statut,
      estModifiable: estModifiable ?? this.estModifiable,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      clientNom: clientNom ?? this.clientNom,
      clientTelephone: clientTelephone ?? this.clientTelephone,
      clientCulture: clientCulture ?? this.clientCulture,
      lignes: lignes ?? this.lignes,
    );
  }

  // Calculer les jours restants
  int get joursRestants => dateEcheance.difference(DateTime.now()).inDays;

  // Vérifier si urgent (≤7 jours)
  bool get isUrgent => joursRestants <= 7 && joursRestants >= 0 && datePaiement == null;

  // Vérifier si en retard
  bool get isEnRetard => dateEcheance.isBefore(DateTime.now()) && datePaiement == null;
}
