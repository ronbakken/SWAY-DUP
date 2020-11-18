import 'package:inf/app/assets.dart';

class MainPageMode {
  static const browse = const MainPageMode._(AppIcons.browse, 'BROWSE');
  static const activities = const MainPageMode._(AppIcons.inbox, 'ACTIVITIES');

  final AppAsset icon;
  final String text;

  const MainPageMode._(this.icon, this.text);

  @override
  String toString() => 'MainPageMode($hashCode){$text}';
}
