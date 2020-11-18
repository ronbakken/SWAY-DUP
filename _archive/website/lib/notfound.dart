import 'package:flutter_web/material.dart';
import 'package:inf_website/routes.dart';

class NotFoundPage extends StatelessWidget {
  static Route<dynamic> route({RouteSettings settings}) {
    return WebPageRoute(
      settings: settings,
      title: 'Whoops! Page Not Found',
      builder: (BuildContext context) => NotFoundPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'The content you are looking for is not here. Perhaps you have the wrong address or clicked on a old link.',
    );
  }
}
