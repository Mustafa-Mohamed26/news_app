import 'package:flutter/material.dart';
import 'package:news_app/l10n/app_localizations.dart';
import 'package:news_app/model/news_response.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsBottomSheet extends StatelessWidget {
  final Articles article;
  const NewsDetailsBottomSheet({super.key, required this.article});

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(Uri.encodeFull(url));
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        debugPrint("Could not launch $url");
      }
    } catch (e) {
      debugPrint("Launch error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  article.urlToImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
             SizedBox(height: height * 0.02),
            Text(
              article.description ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: height * 0.02),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (article.url != null) {
                    _launchURL(article.url!);
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.readFullArticle,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }
}
