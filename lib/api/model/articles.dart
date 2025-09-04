import 'package:json_annotation/json_annotation.dart';
import 'package:news_app/api/model/source.dart';

part 'articles.g.dart';

@JsonSerializable()
class Articles {
  @JsonKey(name: "source")
  final Source? source;
  @JsonKey(name: "author")
  final String? author;
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "url")
  final String? url;
  @JsonKey(name: "urlToImage")
  final String? urlToImage;
  @JsonKey(name: "publishedAt")
  final String? publishedAt;
  @JsonKey(name: "content")
  final String? content;

  Articles ({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory Articles.fromJson(Map<String, dynamic> json) {
    return _$ArticlesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ArticlesToJson(this);
  }
}