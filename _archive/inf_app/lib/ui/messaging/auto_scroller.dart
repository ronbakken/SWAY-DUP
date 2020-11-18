import 'package:flutter/material.dart';

class AutoScroller<T> extends StatefulWidget {
  const AutoScroller({
    Key key,
    @required this.data,
    @required this.sliver,
  }) : super(key: key);

  final List<T> data;

  final Widget sliver;

  @override
  _AutoScrollerState<T> createState() => _AutoScrollerState<T>();
}

class _AutoScrollerState<T> extends State<AutoScroller<T>> {
  ScrollPosition _position;
  bool _atBottom = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _newPosition = Scrollable.of(context)?.position;
    if (_newPosition != _position) {
      _position?.removeListener(_onScrollChanged);
      _position = _newPosition;
      _position?.addListener(_onScrollChanged);
    }
  }

  void _onScrollChanged() {
    _atBottom = (_position != null) && (_position.pixels >= _position.maxScrollExtent - 100.0);
  }

  @override
  void dispose() {
    _position?.removeListener(_onScrollChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(AutoScroller oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_position != null) {
      if (oldWidget.data.length < widget.data.length && _atBottom) {
        scrollToBottom();
      }
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _position.animateTo(
        _position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.sliver;
  }
}
