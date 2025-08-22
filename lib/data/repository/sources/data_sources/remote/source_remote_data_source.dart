// interface source remote data source (ds)

import 'package:news_app/model/source_response.dart';

abstract class SourceRemoteDataSource {
  Future<SourceResponse?> getSources(String categoryId, String language);
}