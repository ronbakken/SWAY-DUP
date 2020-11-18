import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/white_border_circle_avatar.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

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
      lowResUrl: offer.images[0].lowResUrl,
      imageUrl: offer.images[0].imageUrl,
      fit: BoxFit.fitWidth,
      height: mediaQuery.size.height * 0.22,
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
            _OfferDetailsRow(offer: offer),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Text(
                offer.description ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 14.5, height: 1.25),
              ),
            ),
            InkResponse(
              onTap: onPressed,
              child: const CurvedBox(
                bottom: false,
                top: true,
                color: AppTheme.blue,
                curveFactor: 2.0,
                child: Center(
                  child: const Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text('READ MORE'),
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
          WhiteBorderCircle(
            child: Image.network(
              offer.businessAvatarThumbnailUrl,
              fit: BoxFit.cover,
            ),
            radius: 32,
          ),
          horizontalMargin8,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(offer.businessName),
                verticalMargin4,
                Text(
                  offer.location.name ?? '',
                  style: const TextStyle(
                    color: Colors.white54,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          horizontalMargin8,
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (final channel in offer.terms.deliverable.channels)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: channel.logoBackgroundColor,
                        backgroundImage: channel.logoBackgroundImage,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: InfAssetImage(
                            channel.logoRawAssetMonochrome,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              verticalMargin8,
              SizedBox(
                height: 32.0,
                child: Material(
                  color: AppTheme.black12,
                  shape: const StadiumBorder(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        const InfAssetImage(AppIcons.value, width: 20.0),
                        horizontalMargin8,
                        Text(
                          '${offer.terms.getTotalValueAsString(0)}',
                          style: const TextStyle(fontSize: 14.5),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      );

    return Container(
      height: 86.0,
      color: AppTheme.darkGrey,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(children: rowContent),
    );
  }
}
