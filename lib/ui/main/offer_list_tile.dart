import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/inf_memory_image.dart';
import 'package:inf_common/inf_common.dart';

class OfferListTile extends StatelessWidget {
  const OfferListTile({
    Key key,
    @required this.config,
    @required this.offer,
    @required this.onPressed,
    this.heroTag,
    this.backGroundColor = AppTheme.grey,
  }) : super(key: key);

  final ConfigData config;
  final DataOffer offer;
  final void Function() onPressed;
  final String heroTag;
  final Color backGroundColor;

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
    return Material(
      color: backGroundColor,
      elevation: 2.0,
      borderRadius: BorderRadius.circular(5.0),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
              const SizedBox(width: 16.0),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(offer.title,
                            textScaleFactor: 1.2,
                            style: const TextStyle(color: Colors.white)),
                        const SizedBox(width: 10.0),
                        offer.terms.deliverableSocialPlatforms.isNotEmpty
                            ? InfMemoryImage(
                                config
                                    .oauthProviders[offer
                                        .terms.deliverableSocialPlatforms[0]]
                                    .foregroundImage,
                                width: 20.0,
                              )
                            : const SizedBox(width: 20.0),
                        /* TODO: (offer.numberOfProposals ?? 0) > 0
                            ? Expanded(
                                child: Align(
                                  heightFactor: 2,
                                  alignment: Alignment.topRight,
                                  child: NotificationMarker(),
                                ),
                              )
                            : SizedBox(),*/
                      ],
                    ),
                    offer.terms.deliverableSocialPlatforms.isNotEmpty
                        ? const SizedBox(height: 10.0)
                        : const SizedBox(),
                    Text(offer.locationAddress,
                        style: const TextStyle(color: AppTheme.white30)),
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
