import 'package:flutter_web/material.dart';
import 'package:inf_website/home.dart';
import 'package:inf_website/model.dart';
import 'package:inf_website/notfound.dart';
import 'package:inf_website/privacy.dart';
import 'package:inf_website/terms.dart';

final _carouselItems = <CarouselModel>[
  CarouselModel('food', 'Food'),
  CarouselModel('drinks', 'Drinks'),
  CarouselModel('fashion', 'Fashion'),
  CarouselModel('heart', 'Heart'),
  CarouselModel('beauty', 'Beauty'),
  CarouselModel('plane', 'Travel'),
  CarouselModel('drinks', 'Coffee'),
];

class WebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sway - Marketplace',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFFD7BFFD),
        fontFamily: 'ProximaNova',
      ),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/') {
          return HomePage.route(_carouselItems, settings: settings,);
        } else if (settings.name == '/privacy') {
          return PrivacyPage.route(settings: settings);
        } else if (settings.name == '/terms') {
          return TermsPage.route(settings: settings);
        } else {
          return null;
        }
      },
      onUnknownRoute: (RouteSettings settings) {
        return NotFoundPage.route(settings: settings);
      },
    );
  }
}
