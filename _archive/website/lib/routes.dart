import 'package:flutter_web/material.dart';

class WebPageRoute<T> extends PageRoute<T> {
  WebPageRoute({
    this.title,
    RouteSettings settings,
    @required this.builder,
  }) : super(settings: settings);

  final String title;
  final WidgetBuilder builder;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
      ),
      child: Padding(
        padding: const EdgeInsets.all(64.0),
        child: FractionallySizedBox(
          alignment: Alignment.topRight,
          widthFactor: 0.7,
          heightFactor: 0.85,
          child: Card(
            child: Builder(
              builder: (BuildContext context) {
                final theme = Theme.of(context);
                return Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const BackButton(),
                        Expanded(child: Text(this.title, style: theme.textTheme.headline)),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(12.0),
                        child: builder(context),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    final PageTransitionsTheme theme = Theme.of(context).pageTransitionsTheme;
    return theme.buildTransitions<T>(this, context, animation, secondaryAnimation, child);
  }

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black26;

  @override
  String get barrierLabel => 'Dismiss';

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}
