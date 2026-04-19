import 'package:injectable/injectable.dart';
import 'package:news_app/domain/entities/article_entity.dart';
import 'package:news_app/domain/repositories/news_repository.dart';

/// Use case for retrieving articles based on a source ID, language, and search query.
@injectable
class GetNewsUseCase {
  final NewsRepository repository;

  GetNewsUseCase({required this.repository});

  Future<List<ArticleEntity>> execute({
    required String sourceId,
    required String language,
    int page = 1,
    int pageSize = 20,
    String? query,
  }) {
    return repository.getNewsBySourceId(
      sourceId: sourceId,
      language: language,
      page: page,
      pageSize: pageSize,
      query: query,
    );
  }
}
