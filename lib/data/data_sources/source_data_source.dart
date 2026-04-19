import 'package:news_app/api/model/source_response.dart';

abstract class SourceDataSource {
  Future<SourceResponse?> getSources(String categoryId, String language);
  Future<void> cacheSources(String categoryId, String language, SourceResponse response);
}
