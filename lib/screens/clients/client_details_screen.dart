import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/client.dart';
import '../../providers/client_provider.dart';
import '../../providers/facture_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import 'client_form_screen.dart';

class ClientDetailsScreen extends StatefulWidget {
  final Client client;

  const ClientDetailsScreen({super.key, required this.client});

  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les factures du client
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FactureProvider>(context, listen: false).loadFactures();
    });
  }

  Future<void> _deleteClient() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce client ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final provider = Provider.of<ClientProvider>(context, listen: false);
    final success = await provider.deleteClient(widget.client.id!);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Client supprimé'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Erreur'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Détails Client',
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClientFormScreen(client: widget.client),
                ),
              );
              if (result == true && mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteClient,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(Icons.person, 'Nom', widget.client.nom),
                  if (widget.client.adresse != null) ...[
                    const Divider(),
                    _buildInfoRow(Icons.location_on, 'Adresse', widget.client.adresse!),
                  ],
                  if (widget.client.telephone != null) ...[
                    const Divider(),
                    _buildInfoRow(Icons.phone, 'Téléphone', widget.client.telephone!),
                  ],
                  if (widget.client.culture != null) ...[
                    const Divider(),
                    _buildInfoRow(Icons.agriculture, 'Culture', widget.client.culture!),
                  ],
                  if (widget.client.notes != null) ...[
                    const Divider(),
                    _buildInfoRow(Icons.notes, 'Notes', widget.client.notes!),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Factures du client',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Consumer<FactureProvider>(
            builder: (context, provider, child) {
              final factures = provider.getFacturesByClient(widget.client.id!);

              if (factures.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text('Aucune facture'),
                    ),
                  ),
                );
              }

              return Column(
                children: factures.map((facture) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getStatusColor(facture.statut),
                        child: const Icon(Icons.receipt, color: Colors.white),
                      ),
                      title: Text(facture.numero),
                      subtitle: Text('${facture.montantTotal.toStringAsFixed(2)} DA'),
                      trailing: Chip(
                        label: Text(
                          facture.statut,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: _getStatusColor(facture.statut).withOpacity(0.2),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String statut) {
    switch (statut) {
      case 'OUVERTE':
        return Colors.blue;
      case 'FERMEE':
        return Colors.orange;
      case 'PAYEE':
        return Colors.green;
      default:
        return Colors.red;
    }
  }
}
