import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/inf_memory_image.dart';
import 'package:inf/ui/widgets/white_border_circle_avatar.dart';
import 'package:inf_common/inf_common.dart';

class OfferPostTile extends StatelessWidget {
  const OfferPostTile({
    Key key,
    @required this.config,
    @required this.offer,
    @required this.onPressed,
    this.heroTag,
    this.backGroundColor = AppTheme.grey,
  }) : super(key: key);

  final ConfigData config;
  final DataOffer offer;
  final VoidCallback onPressed;
  final String heroTag;
  final Color backGroundColor;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    Widget imageArea = InfImage(
      lowRes: offer.thumbnailBlurred,
      imageUrl: offer.thumbnailUrl,
      fit: BoxFit.fitWidth,
      height: mediaQuery.size.height * 0.22,
    );
    if (heroTag != null) {
      imageArea = Hero(
        tag: heroTag,
        child: imageArea,
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.listViewItemBackground,
        boxShadow: [
          BoxShadow(
              color: AppTheme.white30, spreadRadius: 0.75, blurRadius: 1.0)
        ],
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
            new _OfferDetailsRow(config: config, offer: offer),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Text(
                offer.description ?? "",
                style: TextStyle(
                    color: Colors.white, fontSize: 14.5, height: 1.25),
              ),
            ),
            InkResponse(
              onTap: onPressed,
              child: CurvedBox(
                bottom: false,
                top: true,
                color: AppTheme.blue,
                curveFactor: 2.0,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'READ MORE',
                    ),
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
    @required this.config,
    @required this.offer,
  }) : super(key: key);

  final ConfigData config;
  final DataOffer offer;

  static String centsToDollars(int cents) {
    return '\$' +
        (Decimal.fromInt(cents) / Decimal.fromInt(100)).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rowContent = <Widget>[]..addAll(
        [
          WhiteBorderCircleAvatar(
            child: Image.network(
                offer.senderAvatarUrl), // TODO(kaetemi): senderAvatarBlurred
            radius: 32,
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(offer.senderName),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  offer
                      .locationAddress, // TODO(kaetemi): Fetch sender offer.location.name ?? offer.businessDescription ?? '',
                  style: const TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.0),
          SizedBox(
            height: 32,
            child: Material(
              color: Colors.black,
              shape: StadiumBorder(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                      '${centsToDollars(offer.terms.rewardCashValue + offer.terms.rewardItemOrServiceValue)}',
                      style: const TextStyle(fontSize: 14.5),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 8.0,
          )
        ],
      );

    for (int providerId in offer.terms.deliverableSocialPlatforms) {
      rowContent.add(
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.black,
          child: InfMemoryImage(
            config.oauthProviders[providerId].foregroundImage,
            width: 16.0,
          ),
        ),
      );
    }

    return Container(
      height: 68.0,
      color: AppTheme.darkGrey,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(children: rowContent),
    );
  }
}
