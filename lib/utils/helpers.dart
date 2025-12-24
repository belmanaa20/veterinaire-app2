import 'package:intl/intl.dart';

class Helpers {
  // Formatter de devises
  static final NumberFormat currencyFormatter = NumberFormat('#,##0.00', 'fr_FR');
  
  // Formatter de dates
  static final DateFormat dateFormatter = DateFormat('dd/MM/yyyy', 'fr');
  static final DateFormat dateTimeFormatter = DateFormat('dd/MM/yyyy HH:mm', 'fr');
  
  // Formater un montant en devise
  static String formatCurrency(double amount) {
    return '${currencyFormatter.format(amount)} DA';
  }
  
  // Formater une date
  static String formatDate(DateTime date) {
    return dateFormatter.format(date);
  }
  
  // Formater une date et heure
  static String formatDateTime(DateTime dateTime) {
    return dateTimeFormatter.format(dateTime);
  }
  
  // Convertir un montant en lettres (version simplifiée)
  static String montantEnLettres(double montant) {
    // Conversion de base (à améliorer)
    final partieEntiere = montant.floor();
    final partieDecimale = ((montant - partieEntiere) * 100).round();
    
    String resultat = _nombreEnLettres(partieEntiere);
    
    if (partieDecimale > 0) {
      resultat += ' virgule ${_nombreEnLettres(partieDecimale)}';
    }
    
    resultat += ' dinars';
    return resultat;
  }
  
  // Convertir un nombre en lettres (version basique)
  static String _nombreEnLettres(int nombre) {
    if (nombre == 0) return 'zéro';
    
    const unites = [
      '', 'un', 'deux', 'trois', 'quatre', 'cinq',
      'six', 'sept', 'huit', 'neuf', 'dix',
      'onze', 'douze', 'treize', 'quatorze', 'quinze',
      'seize', 'dix-sept', 'dix-huit', 'dix-neuf'
    ];
    
    const dizaines = [
      '', '', 'vingt', 'trente', 'quarante', 'cinquante',
      'soixante', 'soixante-dix', 'quatre-vingt', 'quatre-vingt-dix'
    ];
    
    if (nombre < 20) return unites[nombre];
    if (nombre < 100) {
      final d = nombre ~/ 10;
      final u = nombre % 10;
      if (u == 0) return dizaines[d];
      if (d == 7) return 'soixante-${unites[10 + u]}';
      if (d == 9) return 'quatre-vingt-${unites[10 + u]}';
      return '${dizaines[d]}-${unites[u]}';
    }
    
    // Pour les nombres plus grands, retourner simplement le nombre
    return nombre.toString();
  }
  
  // Valider un email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  // Valider un numéro de téléphone algérien
  static bool isValidPhoneNumber(String phone) {
    return RegExp(r'^0[5-7][0-9]{8}$').hasMatch(phone.replaceAll(RegExp(r'[\s\-]'), ''));
  }
  
  // Générer un numéro de facture
  static String genererNumeroFacture(int annee, int numero) {
    return 'FAC-$annee-${numero.toString().padLeft(5, '0')}';
  }
  
  // Calculer le pourcentage
  static double calculerPourcentage(double valeur, double total) {
    if (total == 0) return 0;
    return (valeur / total) * 100;
  }
}
