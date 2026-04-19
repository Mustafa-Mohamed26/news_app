import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/data/data_sources/source_data_source.dart';
import 'package:news_app/data/data_sources/articles_data_source.dart';
import 'package:news_app/api/mapper/news_mapper.dart';
import 'package:news_app/domain/entities/article_entity.dart';
import 'package:news_app/domain/entities/source_entity.dart';
import 'package:news_app/domain/repositories/news_repository.dart';

/// Implementation of [NewsRepository] that coordinates data flow between
/// remote and local data sources.
///
/// It follows an **Offline-First** strategy:
/// 1. Check internet connectivity using [Connectivity].
/// 2. If online: Fetch from remote source and automatically cache results locally.
/// 3. If offline or remote fetch fails: Serve data from the local Hive cache.
@Injectable(as: NewsRepository)
class NewsRepositoryImpl implements NewsRepository {
  final SourceDataSource remoteSourceDataSource;
  final SourceDataSource localSourceDataSource;
  final ArticlesDataSource remoteArticlesDataSource;
  final ArticlesDataSource localArticlesDataSource;

  NewsRepositoryImpl(
    @Named('remote') this.remoteSourceDataSource,
    @Named('local') this.localSourceDataSource,
    @Named('remote') this.remoteArticlesDataSource,
    @Named('local') this.localArticlesDataSource,
  );

  @override
  Future<List<SourceEntity>> getSources(String categoryId, String language) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    
    // Step 1: If explicitly offline, immediately fallback to local storage
    if (connectivityResult.contains(ConnectivityResult.none)) {
      var localResponse = await localSourceDataSource.getSources(categoryId, language);
      if (localResponse == null || localResponse.sources == null || localResponse.sources!.isEmpty) {
        throw Exception('No internet connection and no cached data available.');
      }
      return localResponse.sources!.map((source) => source.toEntity()).toList();
    }

    try {
      // Step 2: Try fetching from the remote API
      var response = await remoteSourceDataSource.getSources(categoryId, language);
      if (response?.status == 'error') {
        throw Exception(response?.message ?? 'Failed to fetch sources');
      }
      
      // Step 3: Cache the successful remote response for future offline use
      if (response != null) {
        await localSourceDataSource.cacheSources(categoryId, language, response);
      }

      var sourcesList = response?.sources ?? [];
      return sourcesList.map((source) => source.toEntity()).toList();
    } catch (e) {
      // Step 4: If the API call fails (e.g., timeout or server error), try local fallback
      var localResponse = await localSourceDataSource.getSources(categoryId, language);
      if (localResponse == null || localResponse.sources == null || localResponse.sources!.isEmpty) {
        throw Exception(e.toString());
      }
      return localResponse.sources!.map((source) => source.toEntity()).toList();
    }
  }

  @override
  Future<List<ArticleEntity>> getNewsBySourceId({
    required String sourceId,
    required String language,
    int page = 1,
    int pageSize = 20,
    String? query,
  }) async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    // Step 1: Explicit offline check
    if (connectivityResult.contains(ConnectivityResult.none)) {
      var localResponse = await localArticlesDataSource.getNewsBySourceId(sourceId: sourceId, language: language, page: page, pageSize: pageSize, query: query);
      if (localResponse == null || localResponse.articles == null || localResponse.articles!.isEmpty) {
        throw Exception('No internet connection and no cached data available.');
      }
      return localResponse.articles!.map((article) => article.toEntity()).toList();
    }

    try {
      // Step 2: Fetch from remote
      var response = await remoteArticlesDataSource.getNewsBySourceId(
        sourceId: sourceId,
        language: language,
        page: page,
        pageSize: pageSize,
        query: query,
      );
      if (response?.status == 'error') {
        throw Exception(response?.message ?? 'Failed to fetch news');
      }

      // Step 3: Automatic caching on success
      if (response != null) {
        await localArticlesDataSource.cacheNews(sourceId: sourceId, language: language, page: page, pageSize: pageSize, query: query, response: response);
      }
      
      var articlesList = response?.articles ?? [];
      return articlesList.map((article) => article.toEntity()).toList();
    } catch (e) {
      // Step 4: Robust fallback on any endpoint error
       var localResponse = await localArticlesDataSource.getNewsBySourceId(sourceId: sourceId, language: language, page: page, pageSize: pageSize, query: query);
      if (localResponse == null || localResponse.articles == null || localResponse.articles!.isEmpty) {
        throw Exception(e.toString());
      }
      return localResponse.articles!.map((article) => article.toEntity()).toList();
    }
  }
}
