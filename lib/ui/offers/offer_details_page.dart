import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/inf_page_indicator.dart';
import 'package:inf/ui/widgets/page_widget.dart';
import 'package:inf/ui/widgets/routes.dart';

class OfferDetailsPage extends PageWidget {
  final BusinessOffer offer;

  static Route<dynamic> route(BusinessOffer offer) {
    return FadePageRoute(
      builder: (BuildContext context) => OfferDetailsPage(
            offer: offer,
          ),
    );
  }

  OfferDetailsPage({this.offer});

  @override
  OfferDetailsPageState createState() {
    return new OfferDetailsPageState();
  }
}

class OfferDetailsPageState extends PageState<OfferDetailsPage> {
  PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(widget.offer.title),
      ),
      body: buildBody(),
    );
  }

  OfferDetailsPageState() {
    pageController = new PageController();
  }

  Column buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        buildImageArea(),
        buildBusinessRow(),
        DetailEntry(
          icon: SvgPicture.asset(Vectors.browseIcon),
          title: 'DESCRIPTION',
          text: widget.offer.description,
        ),
        Container(
          height: 2,
          color: Colors.grey,
        ),
        DetailEntry(
          icon: getDeliverableChannelImages(widget.offer.deliverables[0].channel),
          title: 'DELIVERABLES',
          text: widget.offer.deliverables[0].description,
        ),
        Container(height: 2, color: Colors.grey),
        DetailEntry(
          icon: SvgPicture.asset(Vectors.rewardsIcon),
          title: 'REWARDS',
          text: widget.offer.reward.description,
        ),
        Container(height: 2, color: Colors.grey),
        DetailEntry(
          icon: SvgPicture.asset(Vectors.locationIcon),
          title: 'LOCATION',
          text: 'What do we display here?',
        ),
        SafeArea(
          child: RaisedButton(
            onPressed: () {
              return showModalBottomSheet(
                context: context,
                builder: (context) => ProposalBottomSheet(),
              );
            },
            shape: const StadiumBorder(),
            child: Container(
              alignment: Alignment.center,
              height: 44.0,
              child: Text(
                'TELL US WHAT YOU CAN OFFER',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container buildBusinessRow() {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.black,
      height: 80.0,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(widget.offer.businessAvatarThumbnailUrl),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(widget.offer.businessName),
                Text(widget.offer.businessDescription),
              ],
            ),
          )
        ],
      ),
    );
  }

  Stack buildImageArea() {
    List<InfImage> imageArray = <InfImage>[];
    for (int i = 0; i < widget.offer.coverUrls.length; i++) {
      imageArray.add(InfImage(
        imageUrl: widget.offer.coverUrls[i],
        lowRes: widget.offer.coverLowRes[i],
      ));
    }
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        PageView(
          controller: pageController,
          children: imageArray,
        ),
        Positioned(
          bottom: 20.0,
          child: new InfPageIndicator(pageController: pageController, count: widget.offer.coverUrls.length),
        )
      ],
    );
  }
}

class DetailEntry extends StatelessWidget {
  const DetailEntry({
    Key key,
    this.icon,
    this.title,
    this.text,
  }) : super(key: key);

  final Widget icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(radius: 15.0, child: SizedBox(width: 20.0, height: 20.0, child: icon)),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Text(title),
              )
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: Text(text),
          )
        ],
      ),
    );
  }
}

class ProposalBottomSheet extends StatefulWidget {
  @override
  ProposalBottomSheetState createState() {
    return new ProposalBottomSheetState();
  }
}

class ProposalBottomSheetState extends State<ProposalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.0,
      child: Stack(
        children: [
          Positioned(
            right: 10.0,
            child: InkResponse(
              onTap: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ),
          Positioned(
            child: Column(
              children: [
                Text('Tell US WHAT YOU CAN OFFER'),
                Expanded(child: TextField()),
                SafeArea(
                  child: RaisedButton(
                      onPressed: () {},
                      shape: const StadiumBorder(),
                      child: Container(
                          alignment: Alignment.center,
                          height: 44.0,
                          child: Text('MAKE PROPOSAL', style: const TextStyle(fontWeight: FontWeight.normal)))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
