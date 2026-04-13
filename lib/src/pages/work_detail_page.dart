import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/formatters.dart';
import 'package:flutter_application_1/src/core/models.dart';
import 'package:flutter_application_1/src/core/session_controller.dart';
import 'package:flutter_application_1/src/pages/spoiler_detail_page.dart';
import 'package:flutter_application_1/src/services/catalog_service.dart';
import 'package:flutter_application_1/src/widgets/status_views.dart';

class WorkDetailPage extends StatelessWidget {
  const WorkDetailPage({
    required this.slug,
    required this.sessionController,
    super.key,
  });

  final String slug;
  final SessionController sessionController;

  @override
  Widget build(BuildContext context) {
    final service = CatalogService(sessionController.apiClient);

    return Scaffold(
      appBar: AppBar(title: const Text('Détail œuvre')),
      body: FutureBuilder<WorkDetailView>(
        future: service.fetchWork(
          slug,
          accessToken: sessionController.accessToken,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          if (snapshot.hasError) {
            return ErrorView(error: '${snapshot.error}');
          }

          final work = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  work.coverImage,
                  height: 240,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 240,
                    color: Colors.white10,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_outlined, size: 48),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                work.title,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(work.description),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: Text(work.type)),
                  Chip(label: Text('${work.releaseYear}')),
                  Chip(label: Text('Zone: ${work.spoilZoneLabel}')),
                  Chip(
                    label: Text('Dès ${formatPrice(work.lowestPriceCents)}'),
                  ),
                ],
              ),
              if (work.pack != null) ...[
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    title: Text('Pack ${work.pack!.title}'),
                    subtitle: Text(work.pack!.description),
                    trailing: Text(formatPrice(work.pack!.priceCents)),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              const Text(
                'Spoilers publiés',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ...work.spoilers.map(
                (spoiler) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(spoiler.title),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(spoiler.teaser),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(formatPrice(spoiler.priceCents)),
                        Text(spoiler.isOwned ? 'Débloqué' : spoiler.level),
                      ],
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => SpoilerDetailPage(
                          spoilerId: spoiler.id,
                          sessionController: sessionController,
                        ),
                      ),
                    ),
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
