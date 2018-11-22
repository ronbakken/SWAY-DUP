import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/notification_marker.dart';
import 'package:inf/ui/widgets/white_border_circle_avatar.dart';

class OfferPostTile extends StatelessWidget {
  const OfferPostTile({
    Key key,
    @required this.offer,
    @required this.onPressed,
    this.tag,
    this.backGroundColor = AppTheme.grey,
  }) : super(key: key);

  final BusinessOffer offer;
  final VoidCallback onPressed;
  final String tag;
  final Color backGroundColor;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    Widget imageArea = InfImage(
      lowRes: offer.coverLowRes[0],
      imageUrl: offer.coverUrls[0],
      fit: BoxFit.fitWidth,
      height: mediaQuery.size.height * 0.25,
    );
    if (tag != null) {
      imageArea = Hero(
        tag: tag,
        child: imageArea,
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.listViewItemBackground,
        boxShadow: [BoxShadow(color: AppTheme.white30, spreadRadius: 0.75, blurRadius: 1.0)],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            imageArea,
            Container(
              color: AppTheme.white30,
              height: 1.5,
            ),
            new _OfferDetailsRow(offer: offer),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Text(offer.description ?? "", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(
              height: 16,
            ),
            InkResponse(
              onTap: onPressed,
              child: CurvedBox(
                bottom: false,
                top: true,
                color: AppTheme.blue,
                curveFactor: 2.5,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text('READ MORE', ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _OfferDetailsRow extends StatelessWidget {
  const _OfferDetailsRow({
    Key key,
    @required this.offer,
  }) : super(key: key);

  final BusinessOffer offer;

  @override
  Widget build(BuildContext context) {
    List<Widget> rowContent = <Widget>[]..addAll(
        [
          WhiteBorderCircleAvatar(child: Image.network(offer.businessAvatarThumbnailUrl)),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(offer.businessName),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  offer.location.name ?? offer.businessDescription ?? '',
                  style: const TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.0),
          Material(
            color: Colors.black,
            shape: StadiumBorder(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  InfAssetImage(
                    AppIcons.payments,
                    width: 20.0,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    '${offer.reward.getTotalValueAsString(0)}',
                    style: const TextStyle(fontSize: 18.0),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 8.0,
          )
        ],
      );

    for (var deliverable in offer.deliverables) {
      rowContent.add(
        CircleAvatar(
          backgroundColor: Colors.black,
          child: InfAssetImage(
            AppLogo.getDeliverableChannel(deliverable.channel),
            width: 16.0,
          ),
        ),
      );
    }
    // (offer.newChatMessages ?? 0) > 0
    //     ? Expanded(
    //         child: Align(
    //           heightFactor: 2,
    //           alignment: Alignment.topRight,
    //           child: NotificationMarker(),
    //         ),
    //       )
    //     : SizedBox(),

    return Container(
      color: AppTheme.darkGrey,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(children: rowContent),
    );
  }
}
