import 'package:injectable/injectable.dart';
import 'package:news_app/domain/entities/source_entity.dart';
import 'package:news_app/domain/repositories/news_repository.dart';

/// Use case for retrieving available news sources filterable by category and language.
@injectable
class GetSourcesUseCase {
  final NewsRepository repository;

  GetSourcesUseCase({required this.repository});

  Future<List<SourceEntity>> execute(String categoryId, String language) {
    return repository.getSources(categoryId, language);
  }
}
