import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
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
                _buildAvailablility(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _DetailEntry(
                        icon: AppIcons.description,
                        title: 'DESCRIPTION',
                        text: widget.offer.description,
                      ),
                      Divider(height: 1, color: AppTheme.white30),
                      _DetailEntry(
                        icon: AppIcons.deliverable,
                        title: 'DELIVERABLES',
                        rightSideIcons: [AppLogo.getDeliverableChannel(widget.offer.deliverables[0].channel)],
                        text: widget.offer.deliverables[0].description,
                      ),
                      Divider(height: 1, color: AppTheme.white30),
                      _DetailEntry(
                        icon: AppIcons.rewards,
                        title: 'REWARDS',
                        text: widget.offer.reward.description,
                      ),
                      Divider(height: 1, color: AppTheme.white30),
                      _DetailEntry(
                        icon: AppIcons.location,
                        title: 'LOCATION',
                        text: 'What do we display here?',
                      ),
                      Divider(height: 1, color: AppTheme.white30),
                      buildCategories(),
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
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 26.0),
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

  _DetailEntry buildCategories() {
    return _DetailEntry(
      icon: AppIcons.category,
      title: 'CATEGORIES',
      content: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        alignment: WrapAlignment.start,
        children: widget.offer.categories
            .map<Widget>((category) => Container(
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: AppTheme.blue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(category.name),
                        SizedBox(
                          width: 10.0,
                        ),
                        Icon(
                          Icons.check,
                          size: 12.0,
                        )
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
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

  Widget _buildAvailablility() {

    return Container(
      height: 38.0,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      color: AppTheme.grey,
      child: Row(
        children: [
          Text(
            '${widget.offer.numberAvailable - widget.offer.proposalsCountAccepted}/${widget.offer.numberAvailable} Available',
          ),
          Expanded(
            child: widget.offer.expiryDate != null ? Text(
              'Ends ${DateFormat('MM/dd/yy').format(widget.offer.expiryDate.toLocal())}',
            textAlign: TextAlign.end,
            ) : SizedBox(),
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
    this.content,
    this.margin = const EdgeInsets.only(top: 16.0, bottom: 12.0),
  })  : assert(!(text != null && content != null)),
        super(key: key);

  final List<AppAsset> rightSideIcons;
  final AppAsset icon;
  final String title;
  final String text;
  final EdgeInsetsGeometry margin;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    final titleRow = <Widget>[
      CircleAvatar(
        backgroundColor: const Color(0x33000000),
        radius: 15.0,
        child: InfAssetImage(
          icon,
          height: 14.0,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white54,
            height: 0.95,
          ),
        ),
      ),
    ];
    if (rightSideIcons != null) {
      titleRow.addAll(rightSideIcons
          .map<InfAssetImage>((asset) => InfAssetImage(
                asset,
                height: 18.0,
              ))
          .toList());
    }

    return Padding(
      padding: margin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: titleRow,
          ),
          SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: text != null ? Text(text) : content,
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
            Positioned(
              child: Container(
                color: AppTheme.blue,
                height: 100.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
                    child: Text('Tell us what you can offer'),
                  ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 12.0),
                    child: RaisedButton(
                      onPressed: () {},
                      color: Colors.white,
                      textColor: Colors.black,
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
                  child: Icon(Icons.close),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
