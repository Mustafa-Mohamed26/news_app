import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/api/api_constants.dart';
import 'package:news_app/api/end_points.dart';
import 'package:news_app/model/news_response.dart';
import 'package:news_app/model/source_response.dart';

class ApiManager {
  // singleton is a design pattern that restricts the instantiation of a class to one single instance.
  // This is useful when exactly one object is needed to coordinate actions across the system.
  static ApiManager? _instant; // singleton object

  // private constructor
  ApiManager._();

  static ApiManager getInstance() {
    _instant ??= ApiManager._();
    return _instant!;
  }

  Future<SourceResponse?> getSources(String categoryID, String language) async {
    // authority => The domain name of the server
    // unencodedPath => The path to the resource on the server
    Uri url = Uri.https(ApiConstants.baseUrl, EndPoints.sourceApi, {
      'apiKey': ApiConstants.apiKey,
      'category': categoryID,
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
}
