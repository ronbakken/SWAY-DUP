import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/notification_marker.dart';

class OfferListTile extends StatelessWidget {
  const OfferListTile({
    Key key,
    @required this.offerSummery,
    @required this.onPressed,
    this.tag,
    this.backGroundColor = AppTheme.grey,
  }) : super(key: key);

  final BusinessOfferSummery offerSummery;
  final VoidCallback onPressed;
  final String tag;
  final Color backGroundColor;

  @override
  Widget build(BuildContext context) {
    Widget imageArea = InfImage(
      lowRes: offerSummery.thumbnailLowRes,
      imageUrl: offerSummery.thumbnailUrl,
      fit: BoxFit.cover,
    );
    if (tag != null) {
      imageArea = Hero(
        tag: tag,
        child: imageArea,
      );
    }
    return Material(
      color: backGroundColor,
      elevation: 2.0,
      borderRadius: BorderRadius.circular(5.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: InkResponse(
          onTap: onPressed,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: imageArea,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(offerSummery.title,
                            textScaleFactor: 1.2,
                            style: TextStyle(color: Colors.white)),
                        SizedBox(width: 10.0),
                        InfAssetImage(
                          AppLogo.getDeliverableChannel(
                              offerSummery.channels[0]),
                          width: 20.0,
                        ),
                        // (offer.newChatMessages ?? 0) > 0
                        //     ? Expanded(
                        //         child: Align(
                        //           heightFactor: 2,
                        //           alignment: Alignment.topRight,
                        //           child: NotificationMarker(),
                        //         ),
                        //       )
                        //     : SizedBox(),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Text(offerSummery.description ?? "",
                        style: TextStyle(color: AppTheme.white30)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
