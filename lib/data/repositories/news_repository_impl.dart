import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/data/data_sources/news_data_source.dart';
import 'package:news_app/api/mapper/news_mapper.dart';
import 'package:news_app/domain/entities/article_entity.dart';
import 'package:news_app/domain/entities/source_entity.dart';
import 'package:news_app/domain/repositories/news_repository.dart';

@Injectable(as: NewsRepository)
class NewsRepositoryImpl implements NewsRepository {
  final NewsDataSource remoteDataSource;
  final NewsDataSource localDataSource;

  NewsRepositoryImpl(
    @Named('remote') this.remoteDataSource,
    @Named('local') this.localDataSource,
  );

  @override
  Future<List<SourceEntity>> getSources(String categoryId, String language) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    
    if (connectivityResult.contains(ConnectivityResult.none)) {
      var localResponse = await localDataSource.getSources(categoryId, language);
      if (localResponse == null || localResponse.sources == null || localResponse.sources!.isEmpty) {
        throw Exception('No internet connection and no cached data available.');
      }
      return localResponse.sources!.map((source) => source.toEntity()).toList();
    }

    try {
      var response = await remoteDataSource.getSources(categoryId, language);
      if (response?.status == 'error') {
        throw Exception(response?.message ?? 'Failed to fetch sources');
      }
      
      if (response != null) {
        await localDataSource.cacheSources(categoryId, language, response);
      }

      var sourcesList = response?.sources ?? [];
      return sourcesList.map((source) => source.toEntity()).toList();
    } catch (e) {
      var localResponse = await localDataSource.getSources(categoryId, language);
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

    if (connectivityResult.contains(ConnectivityResult.none)) {
      var localResponse = await localDataSource.getNewsBySourceId(sourceId: sourceId, language: language, page: page, pageSize: pageSize, query: query);
      if (localResponse == null || localResponse.articles == null || localResponse.articles!.isEmpty) {
        throw Exception('No internet connection and no cached data available.');
      }
      return localResponse.articles!.map((article) => article.toEntity()).toList();
    }

    try {
      var response = await remoteDataSource.getNewsBySourceId(
        sourceId: sourceId,
        language: language,
        page: page,
        pageSize: pageSize,
        query: query,
      );
      if (response?.status == 'error') {
        throw Exception(response?.message ?? 'Failed to fetch news');
      }

      if (response != null) {
        await localDataSource.cacheNews(sourceId: sourceId, language: language, page: page, pageSize: pageSize, query: query, response: response);
      }
      
      var articlesList = response?.articles ?? [];
      return articlesList.map((article) => article.toEntity()).toList();
    } catch (e) {
       var localResponse = await localDataSource.getNewsBySourceId(sourceId: sourceId, language: language, page: page, pageSize: pageSize, query: query);
      if (localResponse == null || localResponse.articles == null || localResponse.articles!.isEmpty) {
        throw Exception(e.toString());
      }
      return localResponse.articles!.map((article) => article.toEntity()).toList();
    }
  }
}
