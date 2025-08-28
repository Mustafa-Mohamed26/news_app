import 'package:injectable/injectable.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/data/repository/news/data_sources/remote/news_remote_data_source.dart';
import 'package:news_app/model/news_response.dart';

@Injectable(as: NewsRemoteDataSource)
class NewsRemoteDataSourceImpl  implements NewsRemoteDataSource{
  ApiManager apiManager;
  NewsRemoteDataSourceImpl({required this.apiManager});
  @override
  Future<NewsResponse?> getNewsBySourceId(String sourceId, String language) async{
    var response = await apiManager.getNewsBySourceId(sourceId: sourceId, language: language);
    return response;
  }
}

class NewsRemoteDataSourceDioImpl implements NewsRemoteDataSource{
  @override
  Future<NewsResponse?> getNewsBySourceId(String sourceId, String language) {
    // TODO: implement getNewsBySourceId
    throw UnimplementedError();
  }
  
}