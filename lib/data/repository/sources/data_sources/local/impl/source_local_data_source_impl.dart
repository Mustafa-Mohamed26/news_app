import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/data/repository/sources/data_sources/local/source_local_data_source.dart';
import 'package:news_app/model/source_response.dart';

@Injectable(as: SourceLocalDataSource)
class SourceLocalDataSourceImpl implements SourceLocalDataSource{
  @override
  Future<SourceResponse?> getSources(String categoryId) async{
    var box = await Hive.openBox("SourceTab");
    // var sourceTab = SourceResponse.fromJson(box.get(categoryId)); // Map => object
    var sourceTab = box.get(categoryId);
    return sourceTab;
  }

  @override
  void saveSources(SourceResponse? sourceResponse, String categoryId) async{
    var box = await Hive.openBox("SourceTab");
    // await box.put(categoryId, sourceResponse?.toJson()); // object => Map
    await box.put(categoryId, sourceResponse);
    await box.close();
  }
}