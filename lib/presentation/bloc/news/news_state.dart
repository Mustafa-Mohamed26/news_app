import 'package:news_app/domain/entities/article_entity.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}
class NewsLoading extends NewsState {}
class NewsSuccess extends NewsState {
  final List<ArticleEntity> articles;
  final bool hasMore;
  final bool isFetchingMore;
  NewsSuccess(this.articles, this.hasMore, {this.isFetchingMore = false});
}
class NewsError extends NewsState {
  final String message;
  NewsError(this.message);
}
