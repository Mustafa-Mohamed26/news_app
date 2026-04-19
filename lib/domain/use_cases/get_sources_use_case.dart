import 'package:injectable/injectable.dart';
import 'package:news_app/domain/entities/source_entity.dart';
import 'package:news_app/domain/repositories/news_repository.dart';

@injectable
class GetSourcesUseCase {
  final NewsRepository repository;

  GetSourcesUseCase({required this.repository});

  Future<List<SourceEntity>> invoke(String categoryId, String language) {
    return repository.getSources(categoryId, language);
  }
}
