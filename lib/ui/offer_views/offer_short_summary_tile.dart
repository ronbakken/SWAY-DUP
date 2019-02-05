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
      lowRes: offer.thumbnailLowRes,
      imageUrl: offer.thumbnailUrl,
      fit: BoxFit.cover,
    );
    if (tag != null) {
      imageArea = Hero(
        tag: tag,
        child: imageArea,
      );
    }

    var topRowItems = <Widget>[
       Text(offer.title, textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
       Spacer()
    ];

    for(var channel in offer.terms.deliverable.channels)
    { 
      topRowItems.addAll([
        SizedBox(width: 10.0),
        InfMemoryImage(
          channel.logoColoredData != null ? channel.logoColoredData : channel.logoMonochromeData,
          width: 20.0,
        ),]);
    }

    for(var deliverableType in offer.terms.deliverable.types)
    { 
      topRowItems.addAll([
        SizedBox(width: 10.0),
        InfMemoryImage(
          backend.get<ConfigService>().getDeliveryIconFromType(deliverableType).iconData,
          width: 20.0,
        ),]);
    }


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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
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
