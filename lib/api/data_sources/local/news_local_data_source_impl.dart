import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/api/model/news_response.dart';
import 'package:news_app/api/model/source_response.dart';
import 'package:news_app/data/data_sources/news_data_source.dart';

@Named('local')
@Injectable(as: NewsDataSource)
class NewsLocalDataSourceImpl implements NewsDataSource {
  Box get _box => Hive.box('news_cache');

  @override
  Future<SourceResponse?> getSources(String categoryId, String language) async {
    final key = 'sources_${categoryId}_$language';
    final data = _box.get(key);
    if (data != null) {
      return SourceResponse.fromJson(jsonDecode(data));
    }
    return null;
  }

  @override
  Future<NewsResponse?> getNewsBySourceId({
    required String sourceId,
    required String language,
    int page = 1,
    int pageSize = 20,
    String? query,
  }) async {
    final key = 'news_${sourceId}_${language}_${page}_${pageSize}_${query ?? ""}';
    final data = _box.get(key);
    if (data != null) {
      return NewsResponse.fromJson(jsonDecode(data));
    }
    return null;
  }

  @override
  Future<void> cacheSources(String categoryId, String language, SourceResponse response) async {
    final key = 'sources_${categoryId}_$language';
    await _box.put(key, jsonEncode(response.toJson()));
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
    final key = 'news_${sourceId}_${language}_${page}_${pageSize}_${query ?? ""}';
    await _box.put(key, jsonEncode(response.toJson()));
  }
}
