import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/inf_memory_image.dart';

class OfferShortSummaryTile extends StatelessWidget {
  const OfferShortSummaryTile({
    Key key,
    @required this.offer,
    @required this.onPressed,
    this.tag,
    this.isListTile = true,
    this.backGroundColor = AppTheme.grey,
  }) : super(key: key);

  final BusinessOffer offer;
  final VoidCallback onPressed;
  final String tag;
  final Color backGroundColor;
  final bool isListTile;

  @override
  Widget build(BuildContext context) {
    Widget imageArea = InfImage(
      // HACK for demo
      lowResUrl: offer.images[0].lowresUrl,
      imageUrl: offer.images[0].imageUrl,
      // fixme
      // lowResUrl: offer.thumbnailImage.lowresUrl,
      // imageUrl: offer.thumbnailImage.imageUrl,
      fit: BoxFit.cover,
    );
    if (tag != null) {
      imageArea = Hero(
        tag: tag,
        child: imageArea,
      );
    }

    var channelsAndDleiverables = <Widget>[];
    for (var channel in offer.terms.deliverable.channels) {
      channelsAndDleiverables.add(
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: CircleAvatar(
            radius: 12,
            backgroundColor:
                channel.logoBackGroundColor != null ? Color(channel.logoBackGroundColor) : Colors.transparent,
            backgroundImage: channel.logoBackgroundData != null ? MemoryImage(channel.logoBackgroundData) : null,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: InfMemoryImage(
                channel.logoMonochromeData,
              ),
            ),
          ),
        ),
      );
    }

    for (var deliverableType in offer.terms.deliverable.types) {
      channelsAndDleiverables.addAll([
        SizedBox(width: 10.0),
        InfMemoryImage(
          backend<ConfigService>().getDeliveryIconFromType(deliverableType).iconData,
          width: 20.0,
        ),
      ]);
    }

    var topRowItems = <Widget>[
      Expanded(
              child: Text(
          offer.title,
          textScaleFactor: 1.2,
          style: TextStyle(color: Colors.white),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: channelsAndDleiverables,
      )
    ];

    return Material(
      color: backGroundColor,
      elevation: isListTile ? 2.0 : 0,
      borderRadius: isListTile ? BorderRadius.circular(5.0) : null,
      child: Container(
        height: 104,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: InkResponse(
          onTap: onPressed,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
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
              SizedBox(width: 16.0),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: topRowItems,
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InfAssetImage(
                          AppIcons.value,
                          height: 16,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          offer.terms.reward.getTotalValueAsString(),
                          textScaleFactor: 1.2,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      offer.description ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: AppTheme.white30),
                    ),
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
