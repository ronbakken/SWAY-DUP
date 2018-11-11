import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/inf_page_indicator.dart';
import 'package:inf/ui/widgets/page_widget.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:inf/ui/widgets/bottom_sheet.dart' as infBottomSheet;
import 'package:intl/intl.dart';

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
                _buildAvailability(),
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
                      !widget.offer.displayLimited
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Divider(height: 1, color: AppTheme.white30),
                                buildRewardsRow(),
                                Divider(height: 1, color: AppTheme.white30),
                                _DetailEntry(
                                  icon: AppIcons.location,
                                  title: 'LOCATION',
                                  text: 'What do we display here?',
                                ),
                                Divider(height: 1, color: AppTheme.white30),
                                buildCategories(),
                              ],
                            )
                          : buildLockedSign(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        !widget.offer.displayLimited
            ? Container(
                color: AppTheme.blackTwo,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 26.0),
                    child: RaisedButton(
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
              )
            : SizedBox(),
      ],
    );
  }

  _DetailEntry buildRewardsRow() {
    final reward = widget.offer.reward;
    return _DetailEntry(
        icon: AppIcons.gift,
        title: 'REWARDS',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Value of ${reward.totalValueAsString}'),
            SizedBox(
              height: 12.0,
            ),
            reward.cashValue != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.blue,
                        radius: 15.0,
                        child: InfAssetImage(
                          AppIcons.dollarSign,
                          height: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text('${reward.cashValueAsString}'),
                    ],
                  )
                : SizedBox(),
            SizedBox(
              height: 12.0,
            ),
            reward.description != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.blue,
                        radius: 15.0,
                        child: InfAssetImage(
                          AppIcons.gift,
                          height: 14,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text('${reward.description}'),
                    ],
                  )
                : SizedBox(),
          ],
        ));
  }

  _DetailEntry buildCategories() {
    return _DetailEntry(
      icon: AppIcons.category,
      title: 'CATEGORIES',
      content: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        alignment: WrapAlignment.start,
        children: widget.offer.categories.map<Widget>(
          (category) {
            return Container(
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
            );
          },
        ).toList(),
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

  Widget _buildAvailability() {
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
            child: widget.offer.expiryDate != null
                ? Text(
                    'Ends ${DateFormat('MM/dd/yy').format(widget.offer.expiryDate.toLocal())}',
                    textAlign: TextAlign.end,
                  )
                : SizedBox(),
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

  Widget buildLockedSign() {
    return SafeArea(
      child: Column(
        children: [
          /// We add the title of the Reward group here to have a better teaser
          Divider(height: 1, color: AppTheme.white30),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0x33000000),
                  radius: 15.0,
                  child: InfAssetImage(
                    AppIcons.gift,
                    height: 14.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'REWARD',
                    style: const TextStyle(
                      color: Colors.white54,
                      height: 0.95,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Here starts the lock shield
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Material(
              elevation: 3.0,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(6.0),
              color: AppTheme.grey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CurvedBox(
                    bottom: true,
                    color: AppTheme.blue,
                    curveFactor: 0.8,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24.0, bottom: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.lock, size: 36.0),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text('THERE IS MUCH MORE TO SEE'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27.0, vertical: 13.0),
                    child: Text(
                      'To view the full offer and apply you need to be a member of INF.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27.0, vertical: 13.0),
                    child: Text(
                      "It's fre to sign up and takes only a few seconds",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 26.0),
                    child: RaisedButton(
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
                          'SIGNUP TO SEE ALL',
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 26, right: 26.0, bottom: 20.0),
                    child: InkWell(
                      child: Text(
                        'ALREADY A MEMBER? LOGIN',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
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
            CurvedBox(
              bottom: true,
              curveFactor: 0.9,
              color: AppTheme.blue,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 35.0, bottom: 45.0),
                child: Text('Tell us what you can offer', textAlign: TextAlign.center, textScaleFactor: 1.2,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0,90.0,12.0,12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
              child: Material(
                type: MaterialType.transparency,
                              child: InkResponse(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
