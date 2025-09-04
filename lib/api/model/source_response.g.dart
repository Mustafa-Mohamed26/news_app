// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceResponse _$SourceResponseFromJson(Map<String, dynamic> json) =>
    SourceResponse(
      status: json['status'] as String?,
      sources: (json['sources'] as List<dynamic>?)
          ?.map((e) => Source.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SourceResponseToJson(SourceResponse instance) =>
    <String, dynamic>{'status': instance.status, 'sources': instance.sources};
