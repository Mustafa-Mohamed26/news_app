import 'package:news_app/api/model/news_response.dart';

abstract class ArticlesDataSource {
  Future<NewsResponse?> getNewsBySourceId({
    required String sourceId,
    required String language,
    int page = 1,
    int pageSize = 20,
    String? query,
  });

  Future<void> cacheNews({
    required String sourceId,
    required String language,
    required int page,
    required int pageSize,
    String? query,
    required NewsResponse response,
  });
}
