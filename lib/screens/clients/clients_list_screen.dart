import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/client_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import 'client_form_screen.dart';
import 'client_details_screen.dart';

class ClientsListScreen extends StatefulWidget {
  const ClientsListScreen({super.key});

  @override
  State<ClientsListScreen> createState() => _ClientsListScreenState();
}

class _ClientsListScreenState extends State<ClientsListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClientProvider>(context, listen: false).loadClients();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      Provider.of<ClientProvider>(context, listen: false).loadClients();
    } else {
      Provider.of<ClientProvider>(context, listen: false).searchClients(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Clients',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<ClientProvider>(context, listen: false).loadClients();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Rechercher un client...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearch,
            ),
          ),
          Expanded(
            child: Consumer<ClientProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(provider.error!),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: 'Réessayer',
                          icon: Icons.refresh,
                          onPressed: () => provider.loadClients(),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.clients.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Aucun client trouvé',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: provider.clients.length,
                  itemBuilder: (context, index) {
                    final client = provider.clients[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Text(
                            client.nom.substring(0, 1).toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(client.nom),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (client.telephone != null)
                              Text('Tél: ${client.telephone}'),
                            if (client.culture != null)
                              Text('Culture: ${client.culture}'),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClientDetailsScreen(client: client),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ClientFormScreen(),
            ),
          );
          if (result == true) {
            if (context.mounted) {
              Provider.of<ClientProvider>(context, listen: false).loadClients();
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
