import 'package:flutter/material.dart';
import 'package:sway_mobile_app/app/theme.dart';
import 'package:sway_mobile_app/ui/widgets/inf_image.dart';
import 'package:sway_mobile_app/ui/widgets/white_border_circle_avatar.dart';
import 'package:sway_common/inf_common.dart';

class BrowseCarouselItem extends StatelessWidget {
  const BrowseCarouselItem({
    Key key,
    @required this.offer,
    this.onPressed,
    this.heroTag,
  }) : super(key: key);

  final DataOffer offer;
  final VoidCallback onPressed;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    Widget imageArea = InfImage(
      lowRes: offer.thumbnailBlurred,
      imageUrl: offer.thumbnailUrl,
      fit: BoxFit.cover,
    );
    if (heroTag != null) {
      imageArea = Hero(
        tag: heroTag,
        child: imageArea,
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkGrey,
        boxShadow: [
          BoxShadow(color: AppTheme.white30, spreadRadius: 1.0, blurRadius: 2.0)
        ],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: imageArea,
                ),
                Row(
                  children: <Widget>[
                    Align(
                      heightFactor: 0.75,
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                        child: WhiteBorderCircleAvatar(
                          child: Image.network(offer
                              .senderAvatarUrl), // TODO(kaetemi): senderAvatarBlurred
                          radius: 24.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              offer.title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                            Text(
                              offer.senderName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 11.0),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onPressed,
                child: SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
