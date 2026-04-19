// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../api/data_sources/remote/articles_remote_data_source_impl.dart'
    as _i866;
import '../../api/data_sources/remote/source_remote_data_source_impl.dart'
    as _i212;
import '../../data/data_sources/articles_data_source.dart' as _i1042;
import '../../api/data_sources/local/articles_local_data_source_impl.dart'
    as _i799;
import '../../api/data_sources/local/source_local_data_source_impl.dart'
    as _i626;
import '../../data/data_sources/source_data_source.dart' as _i543;
import '../../data/repositories/news_repository_impl.dart' as _i213;
import '../../domain/repositories/news_repository.dart' as _i88;
import '../../domain/use_cases/get_news_use_case.dart' as _i899;
import '../../domain/use_cases/get_sources_use_case.dart' as _i855;
import '../../presentation/bloc/news/news_view_model.dart' as _i243;
import '../../presentation/bloc/source/source_view_model.dart' as _i224;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i543.SourceDataSource>(
      () => _i626.SourceLocalDataSourceImpl(),
      instanceName: 'local',
    );
    gh.factory<_i543.SourceDataSource>(
      () => _i212.SourceRemoteDataSourceImpl(),
      instanceName: 'remote',
    );
    gh.factory<_i1042.ArticlesDataSource>(
      () => _i799.ArticlesLocalDataSourceImpl(),
      instanceName: 'local',
    );
    gh.factory<_i1042.ArticlesDataSource>(
      () => _i866.ArticlesRemoteDataSourceImpl(),
      instanceName: 'remote',
    );
    gh.factory<_i88.NewsRepository>(
      () => _i213.NewsRepositoryImpl(
        gh<_i543.SourceDataSource>(instanceName: 'remote'),
        gh<_i543.SourceDataSource>(instanceName: 'local'),
        gh<_i1042.ArticlesDataSource>(instanceName: 'remote'),
        gh<_i1042.ArticlesDataSource>(instanceName: 'local'),
      ),
    );
    gh.factory<_i899.GetNewsUseCase>(
      () => _i899.GetNewsUseCase(repository: gh<_i88.NewsRepository>()),
    );
    gh.factory<_i855.GetSourcesUseCase>(
      () => _i855.GetSourcesUseCase(repository: gh<_i88.NewsRepository>()),
    );
    gh.factory<_i243.NewsViewModel>(
      () => _i243.NewsViewModel(getNewsUseCase: gh<_i899.GetNewsUseCase>()),
    );
    gh.factory<_i224.SourceViewModel>(
      () => _i224.SourceViewModel(
        getSourcesUseCase: gh<_i855.GetSourcesUseCase>(),
      ),
    );
    return this;
  }
}
