import 'package:news_app/model/news_response.dart';

// interface news remote data source (ds)
abstract class NewsRemoteDataSource {
  Future<NewsResponse?> getNewsBySourceId(String sourceId, String language);
  
}
