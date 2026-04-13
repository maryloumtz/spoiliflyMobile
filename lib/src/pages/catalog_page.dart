import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/models.dart';
import 'package:flutter_application_1/src/core/session_controller.dart';
import 'package:flutter_application_1/src/pages/work_detail_page.dart';
import 'package:flutter_application_1/src/services/catalog_service.dart';
import 'package:flutter_application_1/src/widgets/app_scaffold.dart';
import 'package:flutter_application_1/src/widgets/status_views.dart';
import 'package:flutter_application_1/src/widgets/work_card.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({required this.sessionController, super.key});

  final SessionController sessionController;

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final _searchController = TextEditingController();
  String _selectedType = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = CatalogService(widget.sessionController.apiClient);

    return AppScaffold(
      title: 'Catalogue',
      subtitle: 'Recherche et filtre rapide sur les œuvres de Spoilifly.',
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              labelText: 'Rechercher une œuvre',
              suffixIcon: IconButton(
                onPressed: () => setState(() {}),
                icon: const Icon(Icons.search),
              ),
            ),
            onSubmitted: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['all', 'movie', 'series', 'book', 'anime', 'game']
                  .map(
                    (type) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(type),
                        selected: _selectedType == type,
                        onSelected: (_) {
                          setState(() {
                            _selectedType = type;
                          });
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child:
                FutureBuilder<(List<WorkCardView>, List<Category>, List<Tag>)>(
                  future: service.fetchCatalog(
                    accessToken: widget.sessionController.accessToken,
                    search: _searchController.text.trim(),
                    type: _selectedType,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const LoadingView();
                    }
                    if (snapshot.hasError) {
                      return ErrorView(error: '${snapshot.error}');
                    }

                    final works = snapshot.data!.$1;
                    if (works.isEmpty) {
                      return const EmptyView(
                        message: 'Aucune œuvre trouvée pour ce filtre.',
                      );
                    }

                    return ListView.builder(
                      itemCount: works.length,
                      itemBuilder: (context, index) {
                        final work = works[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: WorkCard(
                            work: work,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => WorkDetailPage(
                                  slug: work.slug,
                                  sessionController: widget.sessionController,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
