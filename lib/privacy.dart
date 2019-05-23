import 'package:flutter_web/material.dart';
import 'package:inf_website/routes.dart';
import 'package:inf_website/widgets.dart';

class PrivacyPage extends StatelessWidget {
  static Route<dynamic> route({RouteSettings settings}) {
    return WebPageRoute(
      settings: settings,
      title: 'Privacy Policy',
      builder: (BuildContext context) {
        return PrivacyPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownAsset(
      assetName: 'privacy.md',
    );
  }
}
