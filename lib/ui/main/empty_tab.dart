import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/filter/bottom_nav.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class EmptyTab extends StatelessWidget {
  const EmptyTab({
    Key key,
    @required this.contentText,
    this.ctaText = '',
    this.onCtaPressed,
  }) : super(key: key);

  final String contentText;
  final String ctaText;
  final VoidCallback onCtaPressed;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const Opacity(
            opacity: 0.75,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    const Color(0x00000000),
                    const Color(0xCC000000),
                    const Color(0xFF000000),
                  ],
                  stops: <double>[
                    0.3,
                    0.60,
                    0.85,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kBottomNavHeight),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: InfAssetImage(AppImages.handshake),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        contentText,
                        style: TextStyle(color: Colors.white.withOpacity(0.9)),
                      ),
                      verticalMargin24,
                      Opacity(
                        opacity: ctaText.isEmpty && onCtaPressed == null ? 0.0 : 1.0,
                        child: InfStadiumButton(
                          text: ctaText,
                          color: AppTheme.lightBlue,
                          onPressed: onCtaPressed,
                        ),
                      ),
                      verticalMargin36,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
