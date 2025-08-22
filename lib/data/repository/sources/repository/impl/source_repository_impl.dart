// source repository impl
import 'package:news_app/data/repository/sources/data_sources/remote/source_remote_data_source.dart';
import 'package:news_app/data/repository/sources/repository/source_repository.dart';
import 'package:news_app/model/source_response.dart';

class SourceRepositoryImpl implements SourceRepository {
  SourceRemoteDataSource sourceRemoteDataSource;
  SourceRepositoryImpl({required this.sourceRemoteDataSource});

  @override
  Future<SourceResponse?> getSources(String categoryId, String language) async{
    var response = await sourceRemoteDataSource.getSources(categoryId, language);
    return response;
  }
}
