import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/inf_icon.dart';

class MessageActionWidget extends StatelessWidget {
  const MessageActionWidget({
    Key key,
    @required this.user,
    @required this.action,
  }) : super(key: key);

  final User user;
  final MessageAction action;

  @override
  Widget build(BuildContext context) {
    switch (action) {
      case MessageAction.accept:
        return _MessageActionContent(
          color: AppTheme.blue,
          text: 'Congratulations - ${user.name} have agreed to your offer.',
          icon: const Icon(
            Icons.thumb_up,
            color: Colors.white,
          ),
        );
      case MessageAction.counter:
        return _MessageActionContent(
          color: AppTheme.charcoalGrey,
          text: '${user.name} have countered your offer.',
          icon: const Icon(
            Icons.subdirectory_arrow_left,
            color: Colors.white,
          ),
        );
      case MessageAction.reject:
        return _MessageActionContent(
          color: AppTheme.red,
          text: '${user.name} have declined your offer.',
          icon: const Icon(
            Icons.clear,
            color: Colors.white,
          ),
        );
      case MessageAction.completed:
        return _MessageActionContent(
          color: AppTheme.blue,
          text: '${user.name} has marked the deal as COMPLETE.',
          icon: const InfIcon(
            AppIcons.tick,
            color: Colors.white,
          ),
        );
      default:
        throw ArgumentError.value(action, 'action', 'MessageActionWidget: Action invalid.');
    }
  }
}

class _MessageActionContent extends StatelessWidget {
  const _MessageActionContent({
    Key key,
    this.text,
    this.textSpan,
    this.icon,
    this.color,
  }) : super(key: key);

  final String text;
  final TextSpan textSpan;
  final Widget icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: <Widget>[
          Material(
            type: MaterialType.circle,
            elevation: 2.0,
            color: color,
            child: icon,
          ),
          Expanded(
            child: text != null ? Text(text) : Text.rich(textSpan),
          ),
        ],
      ),
    );
  }
}
