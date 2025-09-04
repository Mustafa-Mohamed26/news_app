import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_app/api/end_points.dart';
import 'package:news_app/api/model/source_response.dart';
import 'package:news_app/model/news_response.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_services.g.dart';

@RestApi(baseUrl: 'https://newsapi.org')
abstract class RetrofitServices {
  factory RetrofitServices(Dio dio, {String? baseUrl}) = _RetrofitServices;

  @GET(EndPoints.sourceApi)
  Future<SourceResponse> getSources(
    @Query('apiKey') String apiKey,
    @Query('category') String category,
  );

  @GET(EndPoints.newsApi)
  Future<NewsResponse> getNewsBySourceId(
    @Query('apiKey') String apiKey,
    @Query('sources') String sourceId,
  );
}
