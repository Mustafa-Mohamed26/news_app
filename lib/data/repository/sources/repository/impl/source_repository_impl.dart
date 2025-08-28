// source repository impl
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:news_app/data/repository/sources/data_sources/local/source_local_data_source.dart';
import 'package:news_app/data/repository/sources/data_sources/remote/source_remote_data_source.dart';
import 'package:news_app/data/repository/sources/repository/source_repository.dart';
import 'package:news_app/model/source_response.dart';

class SourceRepositoryImpl implements SourceRepository {
  SourceRemoteDataSource sourceRemoteDataSource;
  SourceLocalDataSource sourceLocalDataSource;
  SourceRepositoryImpl({
    required this.sourceRemoteDataSource,
    required this.sourceLocalDataSource,
  });

  @override
  Future<SourceResponse?> getSources(String categoryId, String language) async {
    // var response = await sourceRemoteDataSource.getSources(categoryId, language);
    // return response;

    // internet => remote ds
    // no internet => local ds

    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());

    // This condition is for demo purposes only to explain every connection type.
    // Use conditions which work for your requirements.
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      var sourceResponse = await sourceRemoteDataSource.getSources(categoryId, language);
      // save to local ds
      sourceLocalDataSource.saveSources(sourceResponse, categoryId);
      return sourceResponse;
    } else {
      // no internet => local ds
      var sourceResponse = await sourceLocalDataSource.getSources(categoryId);
      return sourceResponse;
    }
  }
}
