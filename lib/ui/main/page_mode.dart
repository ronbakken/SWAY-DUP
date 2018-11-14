import 'package:inf/app/assets.dart';


class MainPageMode {
  static const browse = MainPageMode._(AppIcons.browse, 'BROWSE');
  static const activities = MainPageMode._(AppIcons.inbox, 'ACTIVITIES');

  final AppAsset icon;
  final String text;

  const MainPageMode._(this.icon, this.text);
}
