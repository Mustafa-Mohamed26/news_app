// SourceViewModel => object SourceRepository
// SourceRepository => object SourceRemoteDataSource
// SourceRemoteDataSource => object ApiManager

import 'package:news_app/api/api_manager.dart';
import 'package:news_app/data/repository/news/data_sources/remote/impl/news_remote_data_source_impl.dart';
import 'package:news_app/data/repository/news/data_sources/remote/news_remote_data_source.dart';
import 'package:news_app/data/repository/news/repository/impl/news_repository_impl.dart';
import 'package:news_app/data/repository/news/repository/news_repository.dart';
import 'package:news_app/data/repository/sources/data_sources/local/impl/source_local_data_source_impl.dart';
import 'package:news_app/data/repository/sources/data_sources/local/source_local_data_source.dart';
import 'package:news_app/data/repository/sources/data_sources/remote/impl/source_remote_data_source_impl.dart';
import 'package:news_app/data/repository/sources/data_sources/remote/source_remote_data_source.dart';
import 'package:news_app/data/repository/sources/repository/impl/source_repository_impl.dart';
import 'package:news_app/data/repository/sources/repository/source_repository.dart';

SourceRepository injectSourceRepository() {
  return SourceRepositoryImpl(
    sourceRemoteDataSource: injectSourceRemoteDataSource(),
    sourceLocalDataSource: injectSourceLocalDataSource(),
  );
}

SourceRemoteDataSource injectSourceRemoteDataSource() {
  return SourceRemoteDataSourceImpl(apiManager: injectApiManger());
}

SourceLocalDataSource injectSourceLocalDataSource() {
  return SourceLocalDataSourceImpl();
}

ApiManager injectApiManger() {
  return ApiManager();
}

// ===============================================================================================================================

// NewsViewModel => object NewsRepository
// NewsRepository => object NewsRemoteDataSource
// NewsRemoteDataSource => object ApiManager

NewsRepository injectNewsRepository() {
  return NewsRepositoryImpl(newsRemoteDataSource: injectNewsRemoteDataSource());
}

NewsRemoteDataSource injectNewsRemoteDataSource() {
  return NewsRemoteDataSourceImpl(apiManager: injectApiManger());
}
