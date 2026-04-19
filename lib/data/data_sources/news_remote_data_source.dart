import 'package:news_app/api/model/source_response.dart';
import 'package:news_app/api/model/news_response.dart';

abstract class NewsRemoteDataSource {
  Future<SourceResponse?> getSources(String categoryId, String language);
  Future<NewsResponse?> getNewsBySourceId({
    required String sourceId,
    required String language,
    int page = 1,
    int pageSize = 20,
    String? query,
  });
}
