import 'package:json_annotation/json_annotation.dart';
import 'package:news_app/api/model/articles.dart';

part 'news_response.g.dart';

@JsonSerializable()
class NewsResponse {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "totalResults")
  final int? totalResults;
  @JsonKey(name: "articles")
  final List<Articles>? articles;

  NewsResponse ({
    this.status,
    this.totalResults,
    this.articles,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return _$NewsResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$NewsResponseToJson(this);
  }
}






