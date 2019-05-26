import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/offer_views/offer_details_page.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_business_row.dart';
import 'package:inf/ui/widgets/inf_icon.dart';
import 'package:inf/ui/widgets/widget_utils.dart';


class OfferProfileHeader extends StatelessWidget {
  const OfferProfileHeader({
    Key key,
    @required this.offer,
  }) : super(key: key);

  final BusinessOffer offer;

  @override
  Widget build(BuildContext context) {
    return InfBusinessRow(
      onPressed: () {
        return Navigator.of(context).push(
          OfferDetailsPage.route(
            Stream.fromFuture(backend.get<OfferManager>().getFullOffer(offer.id)),
            initialOffer: offer,
          ),
        );
      },
      leading: Image.network(
        offer.businessAvatarThumbnailUrl,
        fit: BoxFit.cover,
      ),
      title: offer.businessName,
      subtitle: offer.businessDescription,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: const ShapeDecoration(
              color: AppTheme.darkGrey,
              shape: StadiumBorder(),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const InfIcon(AppIcons.value, size: 16.0),
                horizontalMargin8,
                Padding(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  child: Text(
                    offer.terms.reward.getTotalValueAsString(),
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 2.0),
          for (final channel in offer.terms.deliverable.channels)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              alignment: Alignment.center,
              decoration: const ShapeDecoration(
                color: AppTheme.darkGrey,
                shape: CircleBorder(),
              ),
              width: 28.0,
              height: 28.0,
              child: SizedBox(
                width: 16.0,
                height: 16.0,
                child: InfAssetImage(
                  channel.logoRawAsset,
                  width: 16.0,
                  height: 16.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

