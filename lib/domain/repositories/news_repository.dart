import 'package:news_app/domain/entities/source_entity.dart';
import 'package:news_app/domain/entities/article_entity.dart';

abstract class NewsRepository {
  Future<List<SourceEntity>> getSources(String categoryId, String language);

  /// Instantly retrieves cached sources without hitting the network.
  Future<List<SourceEntity>?> getSourcesFromCache(String categoryId, String language);

  Future<List<ArticleEntity>> getNewsBySourceId({
    required String sourceId,
    required String language,
    int page = 1,
    int pageSize = 20,
    String? query,
  });

  /// Instantly retrieves cached news without hitting the network.
  Future<List<ArticleEntity>?> getNewsFromCache({
    required String sourceId,
    required String language,
    int page = 1,
    int pageSize = 20,
    String? query,
  });
}
