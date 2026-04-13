import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/formatters.dart';
import 'package:flutter_application_1/src/core/models.dart';
import 'package:flutter_application_1/src/core/session_controller.dart';
import 'package:flutter_application_1/src/services/profile_service.dart';
import 'package:flutter_application_1/src/widgets/app_scaffold.dart';
import 'package:flutter_application_1/src/widgets/status_views.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({required this.sessionController, super.key});

  final SessionController sessionController;

  @override
  Widget build(BuildContext context) {
    final service = ProfileService(sessionController.apiClient);

    return AppScaffold(
      title: 'Profil',
      subtitle: 'Résumé utilisateur et historique d’achats.',
      child: FutureBuilder<ProfilePayload>(
        future: service.fetchProfile(
          accessToken: sessionController.accessToken ?? '',
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          if (snapshot.hasError) {
            return ErrorView(error: '${snapshot.error}');
          }

          final profile = snapshot.data!;
          return ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        child: Text(
                          profile.user.displayName.isEmpty
                              ? '?'
                              : profile.user.displayName[0].toUpperCase(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profile.user.displayName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(profile.user.email),
                      const SizedBox(height: 12),
                      Text(
                        profile.bio.isEmpty
                            ? 'Aucune bio pour l’instant.'
                            : profile.bio,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: sessionController.logout,
                        icon: const Icon(Icons.logout),
                        label: const Text('Se déconnecter'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Historique des achats',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              if (profile.purchases.isEmpty)
                const EmptyView(message: 'Aucun achat enregistré.')
              else
                ...profile.purchases.map(
                  (purchase) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(purchase.productTitle),
                      subtitle: Text(
                        '${purchase.workTitle} · ${purchase.status}',
                      ),
                      trailing: Text(formatPrice(purchase.amountCents)),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
