import 'package:json_annotation/json_annotation.dart';
part 'source.g.dart';
@JsonSerializable()
class Source {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "url")
  final String? url;
  @JsonKey(name: "category")
  final String? category;
  @JsonKey(name: "language")
  final String? language;
  @JsonKey(name: "country")
  final String? country;

  Source ({
    this.id,
    this.name,
    this.description,
    this.url,
    this.category,
    this.language,
    this.country,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return _$SourceFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SourceToJson(this);
  }
}