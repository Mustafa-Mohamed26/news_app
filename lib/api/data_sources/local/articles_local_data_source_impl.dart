import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/api/model/news_response.dart';
import 'package:news_app/data/data_sources/articles_data_source.dart';

@Named('local')
@Injectable(as: ArticlesDataSource)
class ArticlesLocalDataSourceImpl implements ArticlesDataSource {
  @override
  Future<NewsResponse?> getNewsBySourceId({
    required String sourceId,
    required String language,
    int page = 1,
    int pageSize = 20,
    String? query,
  }) async {
    var box = await Hive.openBox('ArticlesTab');
    final key = 'news_${sourceId}_${language}_${page}_${pageSize}_${query ?? ""}';
    return box.get(key) as NewsResponse?;
  }

  @override
  Future<void> cacheNews({
    required String sourceId,
    required String language,
    required int page,
    required int pageSize,
    String? query,
    required NewsResponse response,
  }) async {
    var box = await Hive.openBox('ArticlesTab');
    final key = 'news_${sourceId}_${language}_${page}_${pageSize}_${query ?? ""}';
    await box.put(key, response);
  }
}
