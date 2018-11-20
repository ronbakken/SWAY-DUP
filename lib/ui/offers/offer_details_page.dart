import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/sign_up/sign_up_page.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/inf_page_indicator.dart';
import 'package:inf/ui/widgets/page_widget.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:inf/ui/widgets/bottom_sheet.dart' as inf_bottom_sheet;
import 'package:inf/ui/widgets/white_border_circle_avatar.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class OfferDetailsPage extends PageWidget {
  static Route<dynamic> route(Observable<BusinessOffer> offerStream,
      [String tag]) {
    return FadePageRoute(
      builder: (BuildContext context) => OfferDetailsPage(
            cachedOfferStream: offerStream,
            tag: tag,
          ),
    );
  }

  OfferDetailsPage({
    Key key,
    @required this.cachedOfferStream,
    this.tag,
  }) : super(key: key);

  final Observable<BusinessOffer> cachedOfferStream;
  final String tag;

  @override
  OfferDetailsPageState createState() => OfferDetailsPageState();
}

class OfferDetailsPageState extends PageState<OfferDetailsPage> {
  final pageController = PageController();

  BusinessOffer offer;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<BusinessOffer>(
          stream: widget.cachedOfferStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              offer = snapshot.data;
              return Scaffold(
                resizeToAvoidBottomPadding: false,
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(offer.title),
                ),
                body: _buildBody(),
              );
            }
            // TODO what do we show while waiting
            return SizedBox();
          }),
    );
  }

  Widget _buildBody() {
    Widget imageArea = _buildImageArea();
    if (widget.tag != null) {
      imageArea = Hero(
        tag: widget.tag,
        child: imageArea,
        flightShuttleBuilder: (
          BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext,
        ) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget child) {
              return ClipRRect(
                borderRadius: BorderRadius.lerp(BorderRadius.circular(8.0),
                    BorderRadius.only(), animation.value),
                child: child,
              );
            },
            child: InfImage(
              imageUrl: offer.coverUrls[0],
              lowRes: offer.coverLowRes[0],
            ),
          );
        },
      );
    }
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
                  child: imageArea,
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
                        text: offer.description,
                      ),
                      Divider(height: 1, color: AppTheme.white30),
                      _DetailEntry(
                        icon: AppIcons.deliverable,
                        title: 'DELIVERABLES',
                        rightSideIcons: [
                          AppLogo.getDeliverableChannel(
                              offer.deliverables[0].channel)
                        ],
                        text: offer.deliverables[0].description,
                      ),
                      !backend.get<UserManager>().isLoggedIn
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
        !backend.get<UserManager>().isLoggedIn
            ? Container(
                color: AppTheme.blackTwo,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 26.0),
                    child: RaisedButton(
                      onPressed: () {
                        return inf_bottom_sheet.showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) =>
                              _ProposalBottomSheet(),
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
    final reward = offer.reward;
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
      ),
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
        children: offer.categories.map<Widget>(
          (category) {
            return Container(
              decoration: ShapeDecoration(
                shape: const StadiumBorder(),
                color: AppTheme.blue,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
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
          WhiteBorderCircleAvatar(
              child: Image.network(offer.businessAvatarThumbnailUrl)),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(offer.businessName),
                Text(
                  offer.businessDescription,
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
            '${offer.numberRemaining}/${offer.numberOffered} Available',
          ),
          Expanded(
            child: offer.expiryDate != null
                ? Text(
                    'Ends ${DateFormat('MM/dd/yy').format(offer.expiryDate.toLocal())}',
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
    for (int i = 0; i < offer.coverUrls.length; i++) {
      imageArray.add(InfImage(
        imageUrl: offer.coverUrls[i],
        lowRes: offer.coverLowRes[i],
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
            controller: pageController,
            itemCount: offer.coverUrls.length,
          ),
        ),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 27.0, vertical: 13.0),
                    child: Text(
                      'To view the full offer and apply you need to be a member of INF.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 27.0, vertical: 13.0),
                    child: Text(
                      "It's fre to sign up and takes only a few seconds",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 26.0),
                    child: RaisedButton(
                      onPressed: () => Navigator.of(context)
                        ..push(SignUpPage.route(
                            userType: UserType.influcencer, topPadding: 0)),
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
                  Material(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 26, right: 26.0, bottom: 20.0),
                      child: InkWell(
                        onTap: () => Navigator.of(context)
                          ..push(SignUpPage.route(
                              userType: UserType.influcencer, topPadding: 0)),
                        child: Text(
                          'ALREADY A MEMBER? LOGIN',
                          textAlign: TextAlign.center,
                        ),
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
                child: Text(
                  'Tell us what you can offer',
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 90.0, 12.0, 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 26.0, vertical: 12.0),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0),
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
