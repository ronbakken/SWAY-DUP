import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/inf_icon.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

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
          color: AppTheme.lightBlue,
          text: TextSpan(children: <TextSpan>[
            const TextSpan(text: 'Congratulations - '),
            TextSpan(text: user.name, style: TextStyle(fontWeight: FontWeight.w500)),
            const TextSpan(text: ' have agreed to your offer.'),
          ]),
          iconAsset: AppIcons.thumbUp,
        );
      case MessageAction.reject:
        return _MessageActionContent(
          color: AppTheme.red,
          text: TextSpan(children: <TextSpan>[
            TextSpan(text: user.name, style: TextStyle(fontWeight: FontWeight.w500)),
            const TextSpan(text: ' has declined your offer.'),
          ]),
          iconAsset: AppIcons.close,
        );
      case MessageAction.completed:
        return _MessageActionContent(
          color: AppTheme.lightBlue,
          text: TextSpan(children: <TextSpan>[
            TextSpan(text: user.name, style: TextStyle(fontWeight: FontWeight.w500)),
            const TextSpan(text: ' has marked the deal as COMPLETE.'),
          ]),
          iconAsset: AppIcons.tick,
        );
      default:
        throw ArgumentError.value(action, 'action', 'MessageActionWidget: Action invalid.');
    }
  }
}

class _MessageActionContent extends StatelessWidget {
  const _MessageActionContent({
    Key key,
    this.color,
    this.text,
    this.iconAsset,
  }) : super(key: key);

  final Color color;
  final TextSpan text;
  final AppAsset iconAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
      color: AppTheme.charcoalGrey,
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.buttonHalo, width: 3.0),
              color: color,
            ),
            alignment: Alignment.center,
            child: InfIcon(
              iconAsset,
              color: Colors.white,
              size: 18.0,
            ),
          ),
          horizontalMargin16,
          Expanded(
            child: Text.rich(text),
          ),
        ],
      ),
    );
  }
}
