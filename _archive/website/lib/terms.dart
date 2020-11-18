import 'package:flutter_web/material.dart';
import 'package:inf_website/routes.dart';
import 'package:inf_website/widgets.dart';

class TermsPage extends StatelessWidget {
  static Route<dynamic> route({RouteSettings settings}) {
    return WebPageRoute(
      settings: settings,
      title: 'Terms of Service',
      builder: (BuildContext context) {
        return TermsPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownAsset(
      assetName: 'terms.md',
    );
  }
}
