import 'package:flutter/material.dart';
import 'package:news_app/ui/home/drawer/widget/app_config_bottom_sheet.dart';
import 'package:news_app/ui/home/drawer/widget/drawer_item.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_styles.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
            DrawerItem(icon: Icons.home_outlined, text: "Go To Home"),

            Divider(
              color: AppColors.whiteColor,
              thickness: 2,
              indent: width * 0.04,
              endIndent: width * 0.04,
            ),
            DrawerItem(icon: Icons.format_paint_outlined, text: "Theme"),
            AppConfigBottomSheet(text: 'Dark'),
            SizedBox(height: height * 0.02),
            Divider(
              color: AppColors.whiteColor,
              thickness: 2,
              indent: width * 0.04,
              endIndent: width * 0.04,
            ),
            DrawerItem(icon: Icons.language, text: "Language"),
            AppConfigBottomSheet(text: 'English'),
            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }
}
