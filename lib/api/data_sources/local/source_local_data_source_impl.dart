import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/api/model/source_response.dart';
import 'package:news_app/data/data_sources/source_data_source.dart';

/// Implementation of [SourceDataSource] specifically for local Hive storage.
/// 
/// We use the **On-Demand** pattern here: Every method explicitly opens the
/// box it needs ([SourceTab]). This ensures we don't hold memory for unused
/// boxes and handles potential box-closing scenarios gracefully.
@Named('local')
@Injectable(as: SourceDataSource)
class SourceLocalDataSourceImpl implements SourceDataSource {
  @override
  Future<SourceResponse?> getSources(String categoryId, String language) async {
    // Open the box uniquely for this operation
    var box = await Hive.openBox('SourceTab');
    final key = 'sources_${categoryId}_$language';
    
    // Binary Retrieval: Thanks to Hive adapters, we get strongly-typed objects
    final result = box.get(key) as SourceResponse?;
    return result;
  }

  @override
  Future<void> cacheSources(String categoryId, String language, SourceResponse response) async {
    var box = await Hive.openBox('SourceTab');
    final key = 'sources_${categoryId}_$language';
    
    // Binary Storage: Efficiently store the whole object in local disk
    await box.put(key, response);
  }
}
