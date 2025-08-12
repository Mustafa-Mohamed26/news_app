import 'package:flutter/material.dart';
import 'package:news_app/l10n/app_localizations.dart';
import 'package:news_app/providers/app_language_provider.dart';
import 'package:news_app/providers/app_theme_provider.dart';
import 'package:news_app/ui/home/drawer/widget/app_config_bottom_sheet.dart';
import 'package:news_app/ui/home/drawer/widget/drawer_item.dart';
import 'package:news_app/ui/home/drawer/widget/language_bottom_sheet.dart';
import 'package:news_app/ui/home/drawer/widget/theme_bottom_sheet.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_styles.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatefulWidget {
  VoidCallback onDrawerItemClick;
  HomeDrawer({super.key, required this.onDrawerItemClick});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  void showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => LanguageBottomSheet(),
    );
  }

  void showThemeBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ThemeBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var appLanguageProvider = Provider.of<AppLanguageProvider>(context);
    var appThemeProvider = Provider.of<AppThemeProvider>(context);
    return Drawer(
      child: Container(
        color: AppColors.blackColor,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: height * 0.2,
              color: AppColors.whiteColor,
              child: Text("News App", style: AppStyles.medium24Black),
            ),
            InkWell(
              onTap: () {
                widget.onDrawerItemClick();
              },
              child: DrawerItem(
                icon: Icons.home_outlined,
                text: AppLocalizations.of(context)!.goToHome,
              ),
            ),

            Divider(
              color: AppColors.whiteColor,
              thickness: 2,
              indent: width * 0.04,
              endIndent: width * 0.04,
            ),
            DrawerItem(
              icon: Icons.format_paint_outlined,
              text: AppLocalizations.of(context)!.theme,
            ),
            InkWell(
              onTap: () {
                showThemeBottomSheet();
              },
              child: AppConfigBottomSheet(
                text: appThemeProvider.isDarkMode()
                    ? AppLocalizations.of(context)!.dark
                    : AppLocalizations.of(context)!.light,
              ),
            ),
            SizedBox(height: height * 0.02),
            Divider(
              color: AppColors.whiteColor,
              thickness: 2,
              indent: width * 0.04,
              endIndent: width * 0.04,
            ),
            DrawerItem(
              icon: Icons.language,
              text: AppLocalizations.of(context)!.language,
            ),
            InkWell(
              onTap: () {
                showLanguageBottomSheet();
              },
              child: AppConfigBottomSheet(
                text: appLanguageProvider.appLanguage == 'en'
                    ? AppLocalizations.of(context)!.english
                    : AppLocalizations.of(context)!.arabic,
              ),
            ),
            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }
}
