import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_image.dart';

class BrowseListTile extends StatelessWidget {
  const BrowseListTile({
    Key key,
    @required this.offer,
    @required this.onPressed,
    this.tag, this.backGroundColor =AppTheme.grey,
  }) : super(key: key);

  final BusinessOffer offer;
  final VoidCallback onPressed;
  final String tag;
  final Color backGroundColor;

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
                        Text(offer.title, textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
                        SizedBox(width: 10.0),
                        InfAssetImage(
                          AppLogo.getDeliverableChannel(offer.deliverables[0].channel),
                          width: 20.0,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Text(offer.description, style: TextStyle(color: AppTheme.white30)),
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
