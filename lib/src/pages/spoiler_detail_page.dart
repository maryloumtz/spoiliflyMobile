import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/formatters.dart';
import 'package:flutter_application_1/src/core/models.dart';
import 'package:flutter_application_1/src/core/session_controller.dart';
import 'package:flutter_application_1/src/services/catalog_service.dart';
import 'package:flutter_application_1/src/widgets/status_views.dart';

class SpoilerDetailPage extends StatelessWidget {
  const SpoilerDetailPage({
    required this.spoilerId,
    required this.sessionController,
    super.key,
  });

  final String spoilerId;
  final SessionController sessionController;

  @override
  Widget build(BuildContext context) {
    final service = CatalogService(sessionController.apiClient);

    return Scaffold(
      appBar: AppBar(title: const Text('Détail spoiler')),
      body: FutureBuilder<SpoilerDetailView>(
        future: service.fetchSpoiler(
          spoilerId,
          accessToken: sessionController.accessToken,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          if (snapshot.hasError) {
            return ErrorView(error: '${snapshot.error}');
          }

          final spoiler = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                spoiler.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                spoiler.workTitle,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Niveau: ${spoiler.level}'),
                      const SizedBox(height: 8),
                      Text('Prix: ${formatPrice(spoiler.priceCents)}'),
                      const SizedBox(height: 8),
                      Text(
                        'Etat: ${spoiler.isOwned ? 'Débloqué' : 'Verrouillé'}',
                      ),
                      if (spoiler.pack != null) ...[
                        const SizedBox(height: 8),
                        Text('Pack associé: ${spoiler.pack!.title}'),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(spoiler.teaser),
              const SizedBox(height: 16),
              Text(
                spoiler.premiumContent ??
                    'Contenu premium non débloqué sur ce compte.',
                style: TextStyle(
                  height: 1.5,
                  color: spoiler.premiumContent == null
                      ? Colors.white54
                      : Colors.white,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
