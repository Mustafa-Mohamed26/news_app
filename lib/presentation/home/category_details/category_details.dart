import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/api/model/category.dart';
import 'package:news_app/config/di/di.dart';
import 'package:news_app/core/providers/app_language_provider.dart';
import 'package:news_app/core/theme/app_colors.dart';
import 'package:news_app/presentation/bloc/source/source_view_model.dart';
import 'package:news_app/presentation/bloc/source/source_event.dart';
import 'package:news_app/presentation/bloc/source/source_state.dart';
import 'package:news_app/presentation/home/category_details/sources/source_tab_widget.dart';
import 'package:provider/provider.dart';

/// Detailed screen for a specific category. 
/// It initializes the [SourceViewModel] to fetch the tabs/sources 
/// available for the chosen category.
class CategoryDetails extends StatefulWidget {
  final Category category;
  const CategoryDetails({super.key, required this.category});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  late SourceViewModel _sourceViewModel;

  @override
  void initState() {
    super.initState();
    _sourceViewModel = getIt<SourceViewModel>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var languageProvider = Provider.of<AppLanguageProvider>(context, listen: false);
    _sourceViewModel.add(LoadSourcesEvent(
      categoryId: widget.category.id,
      language: languageProvider.appLanguage,
    ));
  }

  @override
  void dispose() {
    _sourceViewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _sourceViewModel,
      child: BlocBuilder<SourceViewModel, SourceState>(
        builder: (context, state) {
          if (state is SourceLoading || state is SourceInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.greyColor));
          } else if (state is SourceError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Something went wrong: ${state.message}',
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: () {
                    var languageProvider = Provider.of<AppLanguageProvider>(context, listen: false);
                    _sourceViewModel.add(LoadSourcesEvent(categoryId: widget.category.id, language: languageProvider.appLanguage));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.greyColor),
                  child: Text('Try Again', style: Theme.of(context).textTheme.labelMedium),
                ),
              ],
            );
          } else if (state is SourceSuccess) {
            return SourceTabWidget(sourcesList: state.sources);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
