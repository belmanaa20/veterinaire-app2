import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/client.dart';
import '../../providers/client_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ClientFormScreen extends StatefulWidget {
  final Client? client;

  const ClientFormScreen({super.key, this.client});

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _adresseController;
  late TextEditingController _telephoneController;
  late TextEditingController _cultureController;
  late TextEditingController _notesController;
  bool _isLoading = false;

  bool get isEditing => widget.client != null;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.client?.nom ?? '');
    _adresseController = TextEditingController(text: widget.client?.adresse ?? '');
    _telephoneController = TextEditingController(text: widget.client?.telephone ?? '');
    _cultureController = TextEditingController(text: widget.client?.culture ?? '');
    _notesController = TextEditingController(text: widget.client?.notes ?? '');
  }

  @override
  void dispose() {
    _nomController.dispose();
    _adresseController.dispose();
    _telephoneController.dispose();
    _cultureController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveClient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final client = Client(
      id: widget.client?.id,
      nom: _nomController.text,
      adresse: _adresseController.text.isEmpty ? null : _adresseController.text,
      telephone: _telephoneController.text.isEmpty ? null : _telephoneController.text,
      culture: _cultureController.text.isEmpty ? null : _cultureController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    final provider = Provider.of<ClientProvider>(context, listen: false);
    final success = isEditing
        ? await provider.updateClient(client)
        : await provider.createClient(client);

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditing ? 'Client modifié' : 'Client créé'),
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
        title: isEditing ? 'Modifier Client' : 'Nouveau Client',
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CustomTextField(
              label: 'Nom *',
              controller: _nomController,
              prefixIcon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le nom est requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Adresse',
              controller: _adresseController,
              prefixIcon: Icons.location_on,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Téléphone',
              controller: _telephoneController,
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Culture/Élevage',
              controller: _cultureController,
              prefixIcon: Icons.agriculture,
              hint: 'Ex: Élevage Bovin',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Notes',
              controller: _notesController,
              prefixIcon: Icons.notes,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: isEditing ? 'Modifier' : 'Créer',
              icon: isEditing ? Icons.edit : Icons.add,
              onPressed: _saveClient,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
