// Constantes de l'application

class AppConstants {
  // Durée par défaut du délai de paiement
  static const int delaiPaiementDefaut = 45;

  // Seuil pour les alertes (jours)
  static const int seuilAlerte = 7;

  // Stock minimum par défaut
  static const int stockMinDefaut = 10;

  // Statuts de facture
  static const String statutOuverte = 'OUVERTE';
  static const String statutFermee = 'FERMEE';
  static const String statutPayee = 'PAYEE';
  static const String statutEnRetard = 'EN_RETARD';

  // Messages
  static const String msgSuccessCreate = 'Créé avec succès';
  static const String msgSuccessUpdate = 'Mis à jour avec succès';
  static const String msgSuccessDelete = 'Supprimé avec succès';
  static const String msgErrorGeneric = 'Une erreur est survenue';
  static const String msgConfirmDelete = 'Êtes-vous sûr de vouloir supprimer?';
  
  // Devises
  static const String devise = 'DA';
  static const String deviseSymbole = 'DA';
}

class BoxNames {
  static const String clients = 'clients';
  static const String produits = 'produits';
  static const String factures = 'factures';
  static const String lignesFacture = 'lignes_facture';
  static const String parametres = 'parametres';
}
