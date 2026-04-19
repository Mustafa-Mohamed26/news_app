import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:news_app/api/api_constants.dart';
import 'package:news_app/api/end_points.dart';
import 'package:news_app/api/model/source_response.dart';
import 'package:news_app/data/data_sources/source_data_source.dart';

@Named('remote')
@Injectable(as: SourceDataSource)
class SourceRemoteDataSourceImpl implements SourceDataSource {
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
  Future<void> cacheSources(String categoryId, String language, SourceResponse response) async {}
}
