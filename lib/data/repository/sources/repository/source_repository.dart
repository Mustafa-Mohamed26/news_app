// interface source repository

import 'package:news_app/model/source_response.dart';

abstract class SourceRepository {
  Future<SourceResponse?> getSources(String categoryId, String language);
}