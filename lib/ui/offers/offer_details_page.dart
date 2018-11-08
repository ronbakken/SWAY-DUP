import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/inf_page_indicator.dart';
import 'package:inf/ui/widgets/page_widget.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:inf/ui/widgets/bottom_sheet.dart' as infBottomSheet;

class OfferDetailsPage extends PageWidget {
  final BusinessOffer offer;

  static Route<dynamic> route(BusinessOffer offer) {
    return FadePageRoute(
      builder: (BuildContext context) => OfferDetailsPage(offer: offer),
    );
  }

  OfferDetailsPage({
    Key key,
    @required this.offer,
  }) : super(key: key);

  @override
  OfferDetailsPageState createState() => OfferDetailsPageState();
}

class OfferDetailsPageState extends PageState<OfferDetailsPage> {
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.offer.title),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: (16.0 / 9.0),
                  child: _buildImageArea(),
                ),
                _buildBusinessRow(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _DetailEntry(
                        icon: AppIcons.descriptionIcon,
                        title: 'DESCRIPTION',
                        text: widget.offer.description,
                      ),
                      Divider(height: 1, color: AppTheme.white30),
                      _DetailEntry(
                        icon: AppLogo.getDeliverableChannel(widget.offer.deliverables[0].channel),
                        title: 'DELIVERABLES',
                        text: widget.offer.deliverables[0].description,
                      ),
                      Divider(height: 1, color: AppTheme.white30),
                      _DetailEntry(
                        icon: AppIcons.rewardsIcon,
                        title: 'REWARDS',
                        text: widget.offer.reward.description,
                      ),
                      Divider(height: 1, color: AppTheme.white30),
                      _DetailEntry(
                        icon: AppIcons.locationIcon,
                        title: 'LOCATION',
                        text: 'What do we display here?',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: AppTheme.blackTwo,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: RaisedButton(
                color: Colors.white,
                textColor: Colors.black,
                onPressed: () {
                  return infBottomSheet.showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) => _ProposalBottomSheet(),
                    dismissOnTap: false,
                    resizeToAvoidBottomPadding: true,
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
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      color: Colors.black,
      child: Row(
        children: <Widget>[
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: AppTheme.darkGrey,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4.0),
            child: Container(
              foregroundDecoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 0.7),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.network(widget.offer.businessAvatarThumbnailUrl),
              ),
            ),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(widget.offer.businessName),
                Text(
                  widget.offer.businessDescription,
                  style: const TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImageArea() {
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
          child: InfPageIndicator(
            pageController: pageController,
            count: widget.offer.coverUrls.length,
          ),
        )
      ],
    );
  }
}

class _DetailEntry extends StatelessWidget {
  const _DetailEntry({
    Key key,
    this.icon,
    this.rightSideIcons,
    this.title,
    this.text,
    this.margin = const EdgeInsets.only(top: 16.0, bottom: 12.0), 
  }) : super(key: key);

  final List<AppAsset> rightSideIcons;
  final AppAsset icon;
  final String title;
  final String text;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;
    if (icon.type == AppAssetType.Bitmap) {
      iconWidget = Image.asset(icon.path, width: 12.0);
    } else {
      iconWidget = SvgPicture.asset(icon.path, width: 12.0);
    }
    return Padding(
      padding: margin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: const Color(0x33000000),
                radius: 14.0,
                child: iconWidget,
              ),
              SizedBox(width: 12.0),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white54,
                  height: 0.95,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(text),
          )
        ],
      ),
    );
  }
}

class _ProposalBottomSheet extends StatefulWidget {
  @override
  _ProposalBottomSheetState createState() => _ProposalBottomSheetState();
}

class _ProposalBottomSheetState extends State<_ProposalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Tell US WHAT YOU CAN OFFER'),
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final textStyle = DefaultTextStyle.of(context);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: InputDecorator(
                          decoration: const InputDecoration(),
                          isFocused: false,
                          child: SizedBox(
                            height: textStyle.style.fontSize * 8,
                            child: TextField(
                              decoration: null,
                              maxLines: null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  RaisedButton(
                    onPressed: () {},
                    shape: const StadiumBorder(),
                    child: Container(
                      alignment: Alignment.center,
                      height: 44.0,
                      child: Text(
                        'MAKE PROPOSAL',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: InkResponse(
                onTap: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Text('Close'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
