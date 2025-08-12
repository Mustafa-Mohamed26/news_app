// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:news_app/l10n/app_localizations.dart';
import 'package:news_app/model/source_response.dart';
import 'package:news_app/ui/home/category_details/news/news_widget.dart';
import 'package:news_app/ui/home/category_details/sources/source_name.dart';
import 'package:news_app/utils/app_colors.dart';

class SourceTabWidget extends StatefulWidget {
  List<Source> sourcesList;

  SourceTabWidget({super.key, required this.sourcesList});

  @override
  State<SourceTabWidget> createState() => _SourceTabWidgetState();
}

class _SourceTabWidgetState extends State<SourceTabWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.sourcesList.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noResources,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      );
    }

    return DefaultTabController(
      length: widget.sourcesList.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            indicatorColor: Theme.of(context).indicatorColor,
            dividerColor: AppColors.transparentColor,
            tabAlignment: TabAlignment.start,
            onTap: (index) {
              selectedIndex = index;
              setState(() {});
            },
            tabs: widget.sourcesList.map((source) {
              return SourceName(
                sources: source,
                isSelected: selectedIndex == widget.sourcesList.indexOf(source),
              );
            }).toList(),
          ),
          Expanded(
            child: NewsWidget(source: widget.sourcesList[selectedIndex]),
          ),
        ],
      ),
    );
  }
}
