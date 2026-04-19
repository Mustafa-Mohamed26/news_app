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
    final bool isOffline = connectivityResult.contains(ConnectivityResult.none);
    
    // Attempt Remote if not explicitly offline
    if (!isOffline) {
      try {
        var response = await remoteSourceDataSource.getSources(categoryId, language);
        if (response != null && response.status != 'error') {
          // Success: Cache it and return
          await localSourceDataSource.cacheSources(categoryId, language, response);
          var sourcesList = response.sources ?? [];
          return sourcesList.map((source) => source.toEntity()).toList();
        }
      } catch (e) {
        // Log the error and fall through to local fallback
        print('Remote fetch failed, falling back to local: $e');
      }
    }

    // Local Fallback (triggered by explicit offline OR remote failure)
    var localResponse = await localSourceDataSource.getSources(categoryId, language);
    if (localResponse != null && localResponse.sources != null && localResponse.sources!.isNotEmpty) {
      return localResponse.sources!.map((source) => source.toEntity()).toList();
    }

    // Final Failure Case: Both remote and local failed
    throw Exception(isOffline 
      ? 'No internet connection and no cached data available.' 
      : 'Network error and no local data found.');
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
    final bool isOffline = connectivityResult.contains(ConnectivityResult.none);

    // Attempt Remote if not explicitly offline
    if (!isOffline) {
      try {
        var response = await remoteArticlesDataSource.getNewsBySourceId(
          sourceId: sourceId,
          language: language,
          page: page,
          pageSize: pageSize,
          query: query,
        );
        if (response != null && response.status != 'error') {
          // Success: Cache it and return
          await localArticlesDataSource.cacheNews(
            sourceId: sourceId,
            language: language,
            page: page,
            pageSize: pageSize,
            query: query,
            response: response,
          );
          var articlesList = response.articles ?? [];
          return articlesList.map((article) => article.toEntity()).toList();
        }
      } catch (e) {
        // Log the error and fall through to local fallback
        print('Remote fetch failed, falling back to local: $e');
      }
    }

    // Local Fallback (triggered by explicit offline OR remote failure)
    var localResponse = await localArticlesDataSource.getNewsBySourceId(
      sourceId: sourceId,
      language: language,
      page: page,
      pageSize: pageSize,
      query: query,
    );
    
    if (localResponse != null && localResponse.articles != null && localResponse.articles!.isNotEmpty) {
      return localResponse.articles!.map((article) => article.toEntity()).toList();
    }

    // Final Failure Case
    throw Exception(isOffline 
      ? 'No internet connection and no cached data available.' 
      : 'Network error and no local data found.');
  }
}
