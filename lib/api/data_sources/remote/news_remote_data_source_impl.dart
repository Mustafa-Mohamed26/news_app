import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:news_app/api/api_constants.dart';
import 'package:news_app/api/end_points.dart';
import 'package:news_app/api/model/news_response.dart';
import 'package:news_app/api/model/source_response.dart';
import 'package:news_app/data/data_sources/news_data_source.dart';

@Named('remote')
@Injectable(as: NewsDataSource)
class NewsRemoteDataSourceImpl implements NewsDataSource {
  @override
  Future<SourceResponse?> getSources(String categoryId, String language) async {
    Uri url = Uri.https(ApiConstants.baseUrl, EndPoints.sourceApi, {
      'apiKey': ApiConstants.apiKey,
      'category': categoryId,
      'language': language,
    });
    try {
      var response = await http.get(url);
      var responseBody = response.body;
      var json = jsonDecode(responseBody);
      return SourceResponse.fromJson(json);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<NewsResponse?> getNewsBySourceId({
    required String sourceId,
    required String language,
    int page = 1,
    int pageSize = 20,
    String? query,
  }) async {
    Uri url = Uri.https(ApiConstants.baseUrl, EndPoints.newsApi, {
      'apiKey': ApiConstants.apiKey,
      'sources': sourceId,
      'language': language,
      'page': page.toString(),
      'pageSize': pageSize.toString(),
      if (query != null && query.isNotEmpty) 'q': query,
    });

    try {
      var response = await http.get(url);
      var responseBody = response.body;
      return NewsResponse.fromJson(jsonDecode(responseBody));
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> cacheSources(String categoryId, String language, SourceResponse response) async {}

  @override
  Future<void> cacheNews({
    required String sourceId,
    required String language,
    required int page,
    required int pageSize,
    String? query,
    required NewsResponse response,
  }) async {}
}
