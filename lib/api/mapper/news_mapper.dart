import 'package:news_app/api/model/source_response.dart';
import 'package:news_app/api/model/news_response.dart';
import 'package:news_app/domain/entities/source_entity.dart';
import 'package:news_app/domain/entities/article_entity.dart';

/// Extension for mapping Source API models to Domain entities.
extension SourceMapper on Source {
  /// Converts a [Source] API model to a [SourceEntity] domain object.
  SourceEntity toEntity() => SourceEntity(
    id: id ?? '',
    name: name ?? '',
    description: description ?? '',
    url: url ?? '',
    category: category ?? '',
    language: language ?? '',
    country: country ?? '',
  );
}

/// Extension for mapping Article API models to Domain entities.
extension ArticleMapper on Articles {
  /// Converts an [Articles] API model to an [ArticleEntity] domain object.
  ArticleEntity toEntity() => ArticleEntity(
    author: author ?? '',
    title: title ?? '',
    description: description ?? '',
    url: url ?? '',
    urlToImage: urlToImage ?? '',
    publishedAt: publishedAt ?? '',
    content: content ?? '',
  );
}
