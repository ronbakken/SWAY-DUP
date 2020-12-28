import 'package:sway_mobile_app/app/assets.dart';

class MainPageMode {
  static const browse = const MainPageMode._(AppIcons.browse, 'EXPLORE');
  static const activities = const MainPageMode._(AppIcons.inbox, 'ACTIVITIES');

  final AppAsset icon;
  final String text;

  const MainPageMode._(this.icon, this.text);

  @override
  String toString() => 'MainPageMode($hashCode){$text}';
}
