import 'package:flutter_native_splash/cli_commands.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/data/repository/news/data_sources/remote/news_remote_data_source.dart';
import 'package:news_app/data/repository/news/repository/news_repository.dart';
import 'package:news_app/model/news_response.dart';

// news repository impl
@Injectable(as: NewsRepository)
class NewsRepositoryImpl implements NewsRepository{
  NewsRemoteDataSource newsRemoteDataSource;
  NewsRepositoryImpl({required this.newsRemoteDataSource});
  @override
  Future<NewsResponse?> getNewsBySourceId(String sourceId, String language) {
    return newsRemoteDataSource.getNewsBySourceId(sourceId, language);
  }

}