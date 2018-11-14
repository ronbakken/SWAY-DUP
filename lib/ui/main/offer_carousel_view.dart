import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/white_border_circle_avatar.dart';

class OfferCarouselView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BusinessOffer>>(
      stream: backend.get<OfferManager>().getFeaturedBusinessOffers(),
      builder: (BuildContext context, AsyncSnapshot<List<BusinessOffer>> snapshot) {
        if (!snapshot.hasData) {
          return SizedBox();
        }
        return ListView.builder(
          itemCount: snapshot.data.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            var offer = snapshot.data[index];
            return Container(
              margin: const EdgeInsets.only(left: 12.0, top: 8.0, bottom: 8.0),
              decoration: BoxDecoration(
                  color: AppTheme.darkGrey,
                  boxShadow: [BoxShadow(color: AppTheme.white30, spreadRadius: 1.0, blurRadius: 2.0)],
                  borderRadius: BorderRadius.circular(8.0)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: AspectRatio(
                  aspectRatio: 148.0 / 132,
                  child: Stack(
                    children: <Widget>[
                      InfImage(
                        imageUrl: offer.coverUrls[0],
                        lowRes: offer.coverLowRes[0],
                        fit: BoxFit.fitWidth,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                          child: WhiteBorderCircleAvatar(
                            child: Image.network(offer.businessAvatarThumbnailUrl),
                            radius: 24.0,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 55.0, bottom: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  offer.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white, fontSize: 14.0),
                                ),
                                Text(
                                  offer.businessName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white54, fontSize: 11.0),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}