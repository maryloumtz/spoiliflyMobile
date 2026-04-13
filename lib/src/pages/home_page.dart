import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/formatters.dart';
import 'package:flutter_application_1/src/core/models.dart';
import 'package:flutter_application_1/src/core/session_controller.dart';
import 'package:flutter_application_1/src/pages/spoiler_detail_page.dart';
import 'package:flutter_application_1/src/pages/work_detail_page.dart';
import 'package:flutter_application_1/src/services/catalog_service.dart';
import 'package:flutter_application_1/src/widgets/app_scaffold.dart';
import 'package:flutter_application_1/src/widgets/status_views.dart';
import 'package:flutter_application_1/src/widgets/work_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.sessionController, super.key});

  final SessionController sessionController;

  @override
  Widget build(BuildContext context) {
    final service = CatalogService(sessionController.apiClient);

    return AppScaffold(
      title: 'Accueil',
      subtitle: 'Featured, dernières sorties et spoilers récents.',
      child: FutureBuilder<HomePayload>(
        future: service.fetchHome(accessToken: sessionController.accessToken),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          if (snapshot.hasError) {
            return ErrorView(error: '${snapshot.error}');
          }

          final data = snapshot.data!;
          return ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spoilers premium',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.8,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Bonjour ${sessionController.user?.displayName ?? ''}',
                      style: const TextStyle(
                        fontSize: 30,
                        height: 1.05,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Teasers gratuits, révélations premium et bibliothèque sécurisée dans une version mobile inspirée de Spoilifly.',
                      style: TextStyle(
                        height: 1.45,
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: data.categories
                          .take(4)
                          .map((category) => Chip(label: Text(category.name)))
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _SectionTitle(
                title: 'À la une',
                action: '${data.featured.length} œuvres',
              ),
              const SizedBox(height: 12),
              ...data.featured.map(
                (work) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: WorkCard(
                    work: work,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => WorkDetailPage(
                          slug: work.slug,
                          sessionController: sessionController,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _SectionTitle(
                title: 'Dernières œuvres',
                action: '${data.latest.length} résultats',
              ),
              const SizedBox(height: 12),
              ...data.latest.map(
                (work) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: WorkCard(
                    work: work,
                    compact: true,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => WorkDetailPage(
                          slug: work.slug,
                          sessionController: sessionController,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _SectionTitle(
                title: 'Spoilers récents',
                action: '${data.latestSpoilers.length} nouveaux',
              ),
              const SizedBox(height: 12),
              ...data.latestSpoilers.map(
                (spoiler) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(28),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => SpoilerDetailPage(
                          spoilerId: spoiler.id,
                          sessionController: sessionController,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Chip(label: Text(capitalize(spoiler.level))),
                              Chip(
                                label: Text(
                                  spoiler.isOwned
                                      ? 'Débloqué'
                                      : formatPrice(spoiler.priceCents),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            spoiler.workTitle,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.primary,
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            spoiler.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            spoiler.teaser,
                            style: TextStyle(
                              height: 1.45,
                              color: Colors.white.withValues(alpha: 0.72),
                            ),
                          ),
                        ],
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.action});

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Text(
            action,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.68),
            ),
          ),
        ),
      ],
    );
  }
}
