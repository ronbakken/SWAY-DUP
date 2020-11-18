import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class OfferShortSummaryTile extends StatelessWidget {
  const OfferShortSummaryTile({
    Key key,
    @required this.offer,
    this.tag,
    @required this.onPressed,
  }) : super(key: key);

  final BusinessOffer offer;
  final String tag;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    Widget imageArea = InfImage(
      lowResUrl: offer.thumbnailImage.lowResUrl,
      imageUrl: offer.thumbnailImage.imageUrl,
      fit: BoxFit.cover,
    );
    if (tag != null) {
      imageArea = Hero(
        tag: tag,
        child: imageArea,
      );
    }

    var channelsAndDeliverables = <Widget>[];

    for (var channel in offer.terms.deliverable.channels) {
      channelsAndDeliverables.add(
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: CircleAvatar(
            radius: 12,
            backgroundColor: channel.logoBackgroundColor,
            backgroundImage: channel.logoBackgroundImage,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: InfAssetImage(
                channel.logoRawAsset,
              ),
            ),
          ),
        ),
      );
    }

    for (var deliverableType in offer.terms.deliverable.types) {
      channelsAndDeliverables.addAll([
        horizontalMargin8,
        InfAssetImage(
          backend<ConfigService>().getDeliveryIconFromType(deliverableType).iconAsset,
          width: 20.0,
        ),
      ]);
    }

    return Material(
      color: AppTheme.listViewItemBackground,
      elevation: 2.0,
      borderRadius: BorderRadius.circular(5.0),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 2,
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
              horizontalMargin16,
              Flexible(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            offer.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: channelsAndDeliverables,
                        ),
                      ],
                    ),
                    verticalMargin4,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const InfAssetImage(AppIcons.value, height: 16),
                        horizontalMargin8,
                        Text(
                          offer.terms.getTotalValueAsString(),
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    verticalMargin4,
                    Text(
                      offer.description ?? '',
                      style: const TextStyle(color: AppTheme.white30),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
