import 'package:flutter/material.dart';
import 'package:news_app/domain/entities/source_entity.dart';

class SourceName extends StatelessWidget {
  final SourceEntity sources;
  final bool isSelected;
  const SourceName({
    super.key,
    required this.sources,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      sources.name,
      style: isSelected
          ? Theme.of(context).textTheme.labelLarge
          : Theme.of(context).textTheme.labelMedium,
    );
  }
}
