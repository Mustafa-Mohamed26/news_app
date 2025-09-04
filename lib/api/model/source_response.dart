import 'package:json_annotation/json_annotation.dart';
import 'package:news_app/api/model/source.dart';

part 'source_response.g.dart';

@JsonSerializable()
class SourceResponse {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "sources")
  final List<Source>? sources;

  SourceResponse ({
    this.status,
    this.sources,
  });

  factory SourceResponse.fromJson(Map<String, dynamic> json) {
    return _$SourceResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SourceResponseToJson(this);
  }
}




