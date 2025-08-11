import 'package:flutter/material.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_styles.dart';

class DrawerItem extends StatelessWidget {
  IconData icon;
  String text;
  DrawerItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.02,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.whiteColor, size: 35),
          SizedBox(width: width * 0.04),
          Text(text, style: AppStyles.bold16White),
          
        ],
      ),
    );
  }
}
