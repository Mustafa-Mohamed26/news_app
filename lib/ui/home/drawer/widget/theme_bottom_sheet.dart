import 'package:flutter/material.dart';
import 'package:news_app/l10n/app_localizations.dart';
import 'package:news_app/providers/app_theme_provider.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_styles.dart';
import 'package:provider/provider.dart';

class ThemeBottomSheet extends StatefulWidget {
  const ThemeBottomSheet({super.key});

  @override
  State<ThemeBottomSheet> createState() => _ThemeBottomSheetState();
}

class _ThemeBottomSheetState extends State<ThemeBottomSheet> {
  Widget getSelectedLanguage({required String textTheme}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(textTheme, style: AppStyles.medium20Gray),
        Icon(Icons.check, color: AppColors.whiteColor, size: 35),
      ],
    );
  }

  Widget getUnSelectedLanguage({required String textTheme}) {
    return Text(textTheme, style: AppStyles.medium20Black);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var themeProvider = Provider.of<AppThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.02,
        vertical: height * 0.04,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              themeProvider.changeTheme(ThemeMode.dark);
              setState(() {});
            },
            child: themeProvider.isDarkMode()
                ? getSelectedLanguage(
                    textTheme: AppLocalizations.of(context)!.dark,
                  )
                : getUnSelectedLanguage(
                    textTheme: AppLocalizations.of(context)!.dark,
                  ),
          ),
          SizedBox(height: height * 0.02),
          InkWell(
            onTap: () {
              themeProvider.changeTheme(ThemeMode.light);
              setState(() {});
            },
            child: !(themeProvider.isDarkMode())
                ? getSelectedLanguage(
                    textTheme: AppLocalizations.of(context)!.light,
                  )
                : getUnSelectedLanguage(
                    textTheme: AppLocalizations.of(context)!.light,
                  ),
          ),
        ],
      ),
    );
  }
}