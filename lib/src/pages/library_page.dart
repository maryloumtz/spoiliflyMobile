import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/formatters.dart';
import 'package:flutter_application_1/src/core/models.dart';
import 'package:flutter_application_1/src/core/session_controller.dart';
import 'package:flutter_application_1/src/pages/work_detail_page.dart';
import 'package:flutter_application_1/src/services/catalog_service.dart';
import 'package:flutter_application_1/src/widgets/app_scaffold.dart';
import 'package:flutter_application_1/src/widgets/status_views.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({required this.sessionController, super.key});

  final SessionController sessionController;

  @override
  Widget build(BuildContext context) {
    final service = CatalogService(sessionController.apiClient);

    return AppScaffold(
      title: 'Bibliothèque',
      subtitle: 'Contenu acheté ou débloqué pour la session courante.',
      child: FutureBuilder<List<LibraryEntry>>(
        future: service.fetchLibrary(
          accessToken: sessionController.accessToken ?? '',
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          if (snapshot.hasError) {
            return ErrorView(error: '${snapshot.error}');
          }

          final entries = snapshot.data!;
          if (entries.isEmpty) {
            return const EmptyView(message: 'La bibliothèque est encore vide.');
          }

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(entry.work.title),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${entry.spoilers.length} spoilers débloqués'
                      '${entry.pack == null ? '' : ' · pack ${formatPrice(entry.pack!.priceCents)}'}',
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => WorkDetailPage(
                        slug: entry.work.slug,
                        sessionController: sessionController,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
