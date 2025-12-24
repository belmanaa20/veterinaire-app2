import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../models/facture.dart';
import '../models/ligne_facture.dart';
import '../models/parametres.dart';
import '../utils/helpers.dart';

class PdfService {
  // Formatter pour les nombres
  static final NumberFormat currencyFormat = NumberFormat('#,##0.00', 'fr_FR');
  static final DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'fr');

  // Générer le PDF d'une facture
  Future<void> generateFacturePdf({
    required Facture facture,
    required List<LigneFacture> lignes,
    required Parametres parametres,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(parametres),
              pw.SizedBox(height: 20),
              _buildFactureInfo(facture),
              pw.SizedBox(height: 20),
              _buildClientInfo(facture),
              pw.SizedBox(height: 20),
              _buildLignesTable(lignes),
              pw.SizedBox(height: 20),
              _buildTotal(facture),
              pw.SizedBox(height: 20),
              _buildFooter(parametres),
            ],
          );
        },
      ),
    );

    // Afficher ou imprimer le PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // En-tête du document
  pw.Widget _buildHeader(Parametres parametres) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              parametres.nomMagasin,
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            if (parametres.adresse != null)
              pw.Text(parametres.adresse!),
            if (parametres.telephone != null)
              pw.Text('Tél: ${parametres.telephone}'),
            if (parametres.email != null)
              pw.Text('Email: ${parametres.email}'),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            if (parametres.nif != null)
              pw.Text('NIF: ${parametres.nif}'),
            if (parametres.numeroRegistre != null)
              pw.Text('RC: ${parametres.numeroRegistre}'),
          ],
        ),
      ],
    );
  }

  // Informations de la facture
  pw.Widget _buildFactureInfo(Facture facture) {
    return pw.Center(
      child: pw.Text(
        'FACTURE N°: ${facture.numero}',
        style: pw.TextStyle(
          fontSize: 18,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  // Informations du client
  pw.Widget _buildClientInfo(Facture facture) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'CLIENT',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            if (facture.clientNom != null)
              pw.Text('Nom: ${facture.clientNom}'),
            if (facture.clientTelephone != null)
              pw.Text('Tél: ${facture.clientTelephone}'),
            if (facture.clientCulture != null)
              pw.Text('Culture: ${facture.clientCulture}'),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'INFORMATIONS',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text('Date: ${dateFormat.format(facture.dateFacture)}'),
            pw.Text('Échéance: ${dateFormat.format(facture.dateEcheance)}'),
            pw.Text('Délai: ${facture.dateEcheance.difference(facture.dateFacture).inDays} jours'),
            pw.Text('Statut: ${facture.statut}'),
          ],
        ),
      ],
    );
  }

  // Tableau des lignes
  pw.Widget _buildLignesTable(List<LigneFacture> lignes) {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        // En-tête
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _buildTableCell('N°', isHeader: true),
            _buildTableCell('DÉSIGNATION', isHeader: true),
            _buildTableCell('DATE AJOUT', isHeader: true),
            _buildTableCell('QTÉ', isHeader: true),
            _buildTableCell('P.U', isHeader: true),
            _buildTableCell('MONTANT', isHeader: true),
          ],
        ),
        // Lignes
        ...lignes.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final ligne = entry.value;
          return pw.TableRow(
            children: [
              _buildTableCell(index.toString()),
              _buildTableCell(ligne.designation),
              _buildTableCell(dateFormat.format(ligne.dateAjout)),
              _buildTableCell(ligne.quantite.toString()),
              _buildTableCell(currencyFormat.format(ligne.prixUnitaire)),
              _buildTableCell(currencyFormat.format(ligne.montant)),
            ],
          );
        }).toList(),
      ],
    );
  }

  // Cellule de tableau
  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          fontSize: isHeader ? 10 : 9,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  // Total
  pw.Widget _buildTotal(Facture facture) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Text(
          'TOTAL: ${currencyFormat.format(facture.montantTotal)} DA',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Pied de page
  pw.Widget _buildFooter(Parametres parametres) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Signature:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 40),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Cachet:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 40),
          ],
        ),
      ],
    );
  }

  // Convertir un montant en lettres
  String montantEnLettres(double montant) {
    // Utiliser la fonction helper
    return Helpers.montantEnLettres(montant);
  }
}
