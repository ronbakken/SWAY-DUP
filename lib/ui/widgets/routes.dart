import 'package:flutter/material.dart';

class NoTransitionRoute<T> extends PageRoute<T> {
	NoTransitionRoute({
		@required this.builder,
		RouteSettings settings: const RouteSettings(),
		bool fullscreenDialog: false,
		this.maintainState: true,
		this.transitionDuration = const Duration(milliseconds: 450),
	}) : super(
		settings: settings,
		fullscreenDialog: fullscreenDialog,
	);

	final WidgetBuilder builder;

	@override
	final bool maintainState;

	@override
	final bool barrierDismissible = false;

	@override
	final Color barrierColor = null;

	@override
	String get barrierLabel => null;

	@override
	bool get opaque => false;

	@override
	Duration transitionDuration;

	@override
	Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
		final Widget result = new Semantics(
			scopesRoute: true,
			explicitChildNodes: true,
			child: builder(context),
		);
		assert(() {
			if (result == null) {
				throw new FlutterError(
					'The builder for route "${settings.name}" returned null.\n'
						'Route builders must never return null.'
				);
			}
			return true;
		}());
		return result;
	}
}



class FadePageRoute<T> extends NoTransitionRoute<T> {
	FadePageRoute({
		@required WidgetBuilder builder,
		RouteSettings settings = const RouteSettings(),
		bool fullscreenDialog = false,
		bool maintainState = true,
		Duration transitionDuration = const Duration(milliseconds: 450),
	}) : super(
		builder: builder,
		settings: settings,
		fullscreenDialog: fullscreenDialog,
		maintainState: maintainState,
		transitionDuration: transitionDuration,
	);

	@override
	Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
		return FadeTransition(opacity: animation, child: child);
	}
}