import 'package:injectable/injectable.dart';
import 'package:news_app/data/data_sources/news_remote_data_source.dart';
import 'package:news_app/api/mapper/news_mapper.dart';
import 'package:news_app/domain/entities/article_entity.dart';
import 'package:news_app/domain/entities/source_entity.dart';
import 'package:news_app/domain/repositories/news_repository.dart';

@Injectable(as: NewsRepository)
class NewsRepositoryImpl implements NewsRepository {
  NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<SourceEntity>> getSources(String categoryId, String language) async {
    var response = await remoteDataSource.getSources(categoryId, language);
    if (response?.status == 'error') {
      throw Exception(response?.message ?? 'Failed to fetch sources');
    }
    
    var sourcesList = response?.sources ?? [];
    return sourcesList.map((source) => source.toEntity()).toList();
  }

  @override
  Future<List<ArticleEntity>> getNewsBySourceId({
    required String sourceId,
    required String language,
    int page = 1,
    int pageSize = 20,
    String? query,
  }) async {
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
    
    var articlesList = response?.articles ?? [];
    return articlesList.map((article) => article.toEntity()).toList();
  }
}
