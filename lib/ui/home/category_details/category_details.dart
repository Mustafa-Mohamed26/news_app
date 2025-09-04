import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api/api_manager.dart';
import 'package:news_app/api/app_exception.dart';
import 'package:news_app/api/dio_api_manager.dart';
import 'package:news_app/model/category.dart';
import 'package:news_app/model/source_response.dart';
import 'package:news_app/providers/app_language_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<AppLanguageProvider>(context);

    // snapshot => Represents the state of the Future that fetches data from the API
    // It can be in different states: waiting, active, done, or error.
    return FutureBuilder<SourceResponse?>(
      future: DioApiManager.getInstance().getSources(widget.category.id),
      builder: (context, snapshot) {
        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.greyColor),
          );
        }

        // error form client
        if (snapshot.hasError) {
          String errorMessage;
          if (snapshot.error is DioException &&
              (snapshot.error as DioException).error is AppException) {
            // object dioException => AppException
            errorMessage =
                ((snapshot.error as DioException).error as AppException)
                    .message;
          } else {
            errorMessage = snapshot.error.toString();
          }
          return Column(
            children: [
              Text(
                errorMessage,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              ElevatedButton(
                onPressed: () {
                  DioApiManager.getInstance().getSources(widget.category.id);
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
        } else if (snapshot.hasData) {
          var sourcesList = snapshot.data!.sources;
          if (sourcesList == null || sourcesList.isEmpty) {
            return Center(
              child: Text(
                'No Source Found',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            );
          } else {
            return SourceTabWidget(sourcesList: sourcesList);
          }
        } else {
          return Center(
            child: Text(
              'Starting fetching data',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          );
        }

        // // Server response in case of success or error
        // // server error
        // if (snapshot.data?.status == 'error') {
        //   return Column(
        //     children: [
        //       Text(
        //         snapshot.data!.message!,
        //         style: Theme.of(context).textTheme.labelMedium,
        //       ),
        //       ElevatedButton(
        //         onPressed: () {
        //           DioApiManager().getSources(widget.category.id);
        //           setState(() {}); // Refresh the widget to try again
        //         },
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: AppColors.greyColor,
        //         ),
        //         child: Text(
        //           'Try Again',
        //           style: Theme.of(context).textTheme.labelMedium,
        //         ),
        //       ),
        //     ],
        //   );
        // }

        // // success
        // var sourcesList = snapshot.data?.sources ?? [];
        // return SourceTabWidget(sourcesList: sourcesList);
      },
    );
  }
}
