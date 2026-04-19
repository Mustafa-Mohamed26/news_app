import 'package:news_app/api/model/source_response.dart';
import 'package:news_app/api/model/news_response.dart';
import 'package:news_app/domain/entities/source_entity.dart';
import 'package:news_app/domain/entities/article_entity.dart';

extension SourceMapper on Source {
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

extension ArticleMapper on Articles {
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
