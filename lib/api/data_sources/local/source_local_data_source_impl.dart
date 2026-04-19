import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/api/model/source_response.dart';
import 'package:news_app/data/data_sources/source_data_source.dart';

@Named('local')
@Injectable(as: SourceDataSource)
class SourceLocalDataSourceImpl implements SourceDataSource {
  @override
  Future<SourceResponse?> getSources(String categoryId, String language) async {
    var box = await Hive.openBox('SourceTab');
    final key = 'sources_${categoryId}_$language';
    final result = box.get(key) as SourceResponse?;
    return result;
  }

  @override
  Future<void> cacheSources(String categoryId, String language, SourceResponse response) async {
    var box = await Hive.openBox('SourceTab');
    final key = 'sources_${categoryId}_$language';
    await box.put(key, response);
  }
}
