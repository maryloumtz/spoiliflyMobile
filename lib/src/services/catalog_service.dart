import 'package:flutter_application_1/src/core/api_client.dart';
import 'package:flutter_application_1/src/core/models.dart';

class CatalogService {
  CatalogService(this._apiClient);

  final ApiClient _apiClient;

  Future<HomePayload> fetchHome({String? accessToken}) async {
    final payload =
        await _apiClient.get('/api/home', accessToken: accessToken)
            as Map<String, dynamic>;
    return HomePayload.fromJson(payload);
  }

  Future<(List<WorkCardView>, List<Category>, List<Tag>)> fetchCatalog({
    String? accessToken,
    String search = '',
    String type = 'all',
    String sort = 'popular',
  }) async {
    final payload =
        await _apiClient.get(
              '/api/works',
              accessToken: accessToken,
              query: {'search': search, 'type': type, 'sort': sort},
            )
            as Map<String, dynamic>;

    final works = ((payload['works'] as List?) ?? const [])
        .map((item) => WorkCardView.fromJson(item as Map<String, dynamic>))
        .toList();
    final categories = ((payload['categories'] as List?) ?? const [])
        .map((item) => Category.fromJson(item as Map<String, dynamic>))
        .toList();
    final tags = ((payload['tags'] as List?) ?? const [])
        .map((item) => Tag.fromJson(item as Map<String, dynamic>))
        .toList();

    return (works, categories, tags);
  }

  Future<WorkDetailView> fetchWork(String slug, {String? accessToken}) async {
    final payload =
        await _apiClient.get('/api/works/$slug', accessToken: accessToken)
            as Map<String, dynamic>;

    return WorkDetailView.fromJson(payload['work'] as Map<String, dynamic>);
  }

  Future<SpoilerDetailView> fetchSpoiler(
    String id, {
    String? accessToken,
  }) async {
    final payload =
        await _apiClient.get('/api/spoilers/$id', accessToken: accessToken)
            as Map<String, dynamic>;

    return SpoilerDetailView.fromJson(
      payload['spoiler'] as Map<String, dynamic>,
    );
  }

  Future<List<LibraryEntry>> fetchLibrary({required String accessToken}) async {
    final payload =
        await _apiClient.get('/api/library', accessToken: accessToken)
            as Map<String, dynamic>;

    return ((payload['entries'] as List?) ?? const [])
        .map((item) => LibraryEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
