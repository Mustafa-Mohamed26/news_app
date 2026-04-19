import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/domain/use_cases/get_sources_use_case.dart';
import 'source_event.dart';
import 'source_state.dart';

@injectable
class SourceViewModel extends Bloc<SourceEvent, SourceState> {
  final GetSourcesUseCase getSourcesUseCase;

  SourceViewModel({required this.getSourcesUseCase}) : super(SourceInitial()) {
    on<LoadSourcesEvent>((event, emit) async {
      // 1. Try to fetch from Cache INSTANTLY
      try {
        final cachedSources = await getSourcesUseCase.repository.getSourcesFromCache(event.categoryId, event.language);
        if (cachedSources != null && cachedSources.isNotEmpty) {
          emit(SourceSuccess(cachedSources));
        } else {
          // Only show loading if we have NO cached data at all
          emit(SourceLoading());
        }
      } catch (e) {
        // Cache fail is silent, we still want to try network
        emit(SourceLoading());
      }

      // 2. Fetch from Remote in the "background"
      try {
        var sources = await getSourcesUseCase.execute(event.categoryId, event.language);
        emit(SourceSuccess(sources));
      } catch (e) {
        // Only emit error if we don't already have cached data showing
        if (state is! SourceSuccess) {
           emit(SourceError(e.toString()));
        }
      }
    });
  }
}
