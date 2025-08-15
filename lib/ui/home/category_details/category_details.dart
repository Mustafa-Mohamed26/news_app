import 'package:flutter/material.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/model/category.dart';
import 'package:news_app/model/source_response.dart';
import 'package:news_app/providers/app_language_provider.dart';
import 'package:news_app/ui/home/category_details/category_view_model.dart';
import 'package:news_app/ui/home/category_details/sources/source_tab_widget.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:provider/provider.dart';

class CategoryDetails extends StatefulWidget {
  Category category;
  CategoryDetails({super.key, required this.category});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  CategoryViewModel viewModel = CategoryViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.getSources(widget.category.id);
  }
  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<AppLanguageProvider>(context);

    // snapshot => Represents the state of the Future that fetches data from the API
    // It can be in different states: waiting, active, done, or error.
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Consumer<CategoryViewModel>(
        builder: (context, viewModel, child) {
          if(viewModel.errorMessage != null) {
            return Column(
              children: [
                Text(
                  viewModel.errorMessage!,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                ElevatedButton(
                  onPressed: () {
                    viewModel.getSources(widget.category.id);
                    setState(() {}); // Refresh the widget to try again
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greyColor,
                  ),
                  child: Text(
                    'Try Again',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ],
            );
          }
          if (viewModel.sourcesList.isEmpty) {
            // loading
            return const Center(
              child: CircularProgressIndicator(color: AppColors.greyColor),
            );
          } else {
             return SourceTabWidget(sourcesList:  viewModel.sourcesList);
          }
        },
      ),
      // FutureBuilder<SourceResponse?>(
      //   future: ApiManager.getSources(
      //     categoryID:  widget.category.id,
      //     language: languageProvider.appLanguage,
      //   ),
      //   builder: (context, snapshot) {
      //     // loading
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(
      //         child: CircularProgressIndicator(color: AppColors.greyColor),
      //       );
      //     }

      //     // error form client
      //     if (snapshot.hasError) {
      //       return Column(
      //         children: [
      //           Text(
      //             'Something went wrong: ${snapshot.error}',
      //             style: Theme.of(context).textTheme.labelMedium,
      //           ),
      //           ElevatedButton(
      //             onPressed: () {
      //               ApiManager.getSources(
      //                 categoryID:  widget.category.id,
      //                 language: languageProvider.appLanguage,
      //               );
      //               setState(() {}); // Refresh the widget to try again
      //             },
      //             style: ElevatedButton.styleFrom(
      //               backgroundColor: AppColors.greyColor,
      //             ),
      //             child: Text(
      //               'Try Again',
      //               style: Theme.of(context).textTheme.labelMedium,
      //             ),
      //           ),
      //         ],
      //       );
      //     }

      //     // Server response in case of success or error
      //     // server error
      //     if (snapshot.data?.status == 'error') {
      //       return Column(
      //         children: [
      //           Text(
      //             snapshot.data!.message!,
      //             style: Theme.of(context).textTheme.labelMedium,
      //           ),
      //           ElevatedButton(
      //             onPressed: () {
      //               ApiManager.getSources(
      //                 categoryID:  widget.category.id,
      //                 language: languageProvider.appLanguage,
      //               );
      //               setState(() {}); // Refresh the widget to try again
      //             },
      //             style: ElevatedButton.styleFrom(
      //               backgroundColor: AppColors.greyColor,
      //             ),
      //             child: Text(
      //               'Try Again',
      //               style: Theme.of(context).textTheme.labelMedium,
      //             ),
      //           ),
      //         ],
      //       );
      //     }

      //     // success
      //     var sourcesList = snapshot.data?.sources ?? [];
      //     return SourceTabWidget(sourcesList: sourcesList);
      //   },
      // ),
    );
  }
}
