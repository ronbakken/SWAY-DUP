import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/offer_views/offer_edit_page.dart';
import 'package:inf/ui/widgets/bottom_sheet.dart' as inf_bottom_sheet;
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_bottom_button.dart';
import 'package:inf/ui/widgets/inf_icon.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/inf_memory_image.dart';
import 'package:inf/ui/widgets/inf_page_indicator.dart';
import 'package:inf/ui/widgets/inf_page_scroll_view.dart';
import 'package:inf/ui/widgets/page_widget.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:inf/ui/widgets/white_border_circle_avatar.dart';
import 'package:inf/ui/widgets/widget_utils.dart';
import 'package:intl/intl.dart';
import 'package:pedantic/pedantic.dart';

class OfferDetailsPage extends PageWidget {
  static Route<dynamic> route(
    Stream<BusinessOffer> offerStream, {
    BusinessOffer initialOffer,
    String tag,
  }) {
    return FadePageRoute(
      builder: (BuildContext context) {
        return OfferDetailsPage(
          offerStream: offerStream,
          initialOffer: initialOffer,
          tag: tag,
        );
      },
    );
  }

  OfferDetailsPage({
    Key key,
    @required this.offerStream,
    this.initialOffer,
    this.tag,
  }) : super(key: key);

  final Stream<BusinessOffer> offerStream;
  final BusinessOffer initialOffer;
  final String tag;

  @override
  OfferDetailsPageState createState() => OfferDetailsPageState();
}

class OfferDetailsPageState extends PageState<OfferDetailsPage> {
  final pageController = PageController();

  BusinessOffer offer;

  bool _canBeEdited(BusinessOffer offer) => true;

  // Fixme
  // !offer.isPartial && offer.businessAccountId == backend<UserManager>().currentUser.id;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<BusinessOffer>(
        initialData: widget.initialOffer,
        stream: widget.offerStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            offer = snapshot.data;
            return Scaffold(
              resizeToAvoidBottomPadding: false,
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  offer.title,
                ),
                actions: _canBeEdited(offer)
                    ? [
                        InkResponse(
                          child: const Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InfAssetImage(AppIcons.edit, height: 24),
                          ),
                          onTap: onEdit,
                        ),
                      ]
                    : null,
              ),
              body: _buildBody(),
            );
          }
          // TODO what do we show while waiting
          return emptyWidget;
        },
      ),
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
                borderRadius: BorderRadius.lerp(BorderRadius.circular(8.0), const BorderRadius.only(), animation.value),
                child: child,
              );
            },
            child: InfImage(
              imageUrl: offer.images[0].imageUrl,
              lowResUrl: offer.images[0].lowresUrl,
            ),
          );
        },
      );
    }

    var deliverableIcons = <Widget>[Spacer()]..addAll(
        offer.terms.deliverable.channels.map<Widget>(
          (channel) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: InfMemoryImage(
                  channel.logoColoredData ?? channel.logoMonochromeData,
                  width: 24.0,
                ),
              ),
        ),
      );

    deliverableIcons.addAll(
      offer.terms.deliverable.types.map<Widget>(
        (type) => Padding(
              padding: const EdgeInsets.only(left: 8),
              child: InfMemoryImage(
                backend<ConfigService>().getDeliveryIconFromType(type).iconData,
                width: 20.0,
              ),
            ),
      ),
    );

    return InfPageScrollView(
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
                  icon: const InfAssetImage(AppIcons.description),
                  title: 'DESCRIPTION',
                  text: offer.description,
                ),
                const Divider(height: 1, color: AppTheme.white30),
                _DetailEntry(
                  icon: const InfAssetImage(AppIcons.deliverable),
                  title: 'DELIVERABLES',
                  rightSideIcons: deliverableIcons,
                  text: offer.terms.deliverable.description,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(height: 1, color: AppTheme.white30),
                    buildRewardsRow(),
                    const Divider(height: 1, color: AppTheme.white30),
                    _DetailEntry(
                      icon: const InfAssetImage(AppIcons.location),
                      title: 'LOCATION',
                      text: offer.location.name ?? '',
                    ),
                    const Divider(height: 1, color: AppTheme.white30),
                    buildCategories(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottom: InfBottomButton(
        text: 'TELL US WHAT YOU CAN OFFER',
        onPressed: _onMakeOffer,
        panelColor: AppTheme.blackTwo,
      ),
    );
  }

  void _onMakeOffer() {
    inf_bottom_sheet.showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => _ProposalBottomSheet(),
      dismissOnTap: false,
      resizeToAvoidBottomPadding: true,
    );
  }

  _DetailEntry buildRewardsRow() {
    final reward = offer.terms.reward;
    return _DetailEntry(
      icon: const InfAssetImage(AppIcons.gift),
      title: 'REWARDS',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Value of ${reward.getTotalValueAsString()}'),
          verticalMargin12,
          reward.cashValue != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppTheme.blue,
                      radius: 15.0,
                      child: InfAssetImage(
                        AppIcons.dollarSign,
                        height: 18,
                        color: Colors.white,
                      ),
                    ),
                    horizontalMargin8,
                    Text('${reward.cashValueAsString}'),
                  ],
                )
              : emptyWidget,
          verticalMargin12,
          reward.description != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppTheme.blue,
                      radius: 15.0,
                      child: InfAssetImage(
                        AppIcons.gift,
                        height: 14,
                        color: Colors.white,
                      ),
                    ),
                    horizontalMargin8,
                    Text('${reward.description ?? ''}'),
                  ],
                )
              : emptyWidget,
        ],
      ),
    );
  }

  _DetailEntry buildCategories() {
    return _DetailEntry(
      icon: const InfAssetImage(AppIcons.browse, color: Color(0xFFA7A7A7)),
      title: 'CATEGORIES',
      content: offer.categories != null
          ? Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              alignment: WrapAlignment.start,
              children: mapChildren(offer.categories, (category) {
                return Container(
                  decoration: const ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: AppTheme.blue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(category.name),
                        horizontalMargin8,
                        const Icon(Icons.check, size: 12.0),
                      ],
                    ),
                  ),
                );
              }),
            )
          : emptyWidget,
    );
  }

  Widget _buildBusinessRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      color: Colors.black,
      child: Row(
        children: <Widget>[
          WhiteBorderCircleAvatar(
            child: Image.network(
              offer.businessAvatarThumbnailUrl,
              fit: BoxFit.cover,
            ),
          ),
          horizontalMargin12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(offer.businessName ?? ''),
                Text(
                  offer.businessDescription ?? '',
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
            (offer.unlimitedAvailable ?? false)
                ? 'unlimited Available'
                : '${offer.numberRemaining}/${offer.numberOffered} Available',
          ),
          Expanded(
            child: offer.endDate != null
                ? Text(
                    'Ends ${DateFormat('MM/dd/yy').format(offer.endDate.toLocal())}',
                    textAlign: TextAlign.end,
                  )
                : emptyWidget,
          )
        ],
      ),
    );
  }

  Widget _buildImageArea() {
    List<InfImage> imageArray = <InfImage>[];
    for (int i = 0; i < offer.images.length; i++) {
      imageArray.add(
        InfImage(
          imageUrl: offer.images[i].imageUrl,
          lowResUrl: offer.images[i].lowresUrl,
          fit: BoxFit.fitHeight,
        ),
      );
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
            itemCount: offer.images.length,
          ),
        ),
      ],
    );
  }

  void onEdit() async {
    unawaited(Navigator.push(context, OfferEditPage.route(offer)));
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

  final List<Widget> rightSideIcons;
  final Widget icon;
  final String title;
  final String text;
  final EdgeInsetsGeometry margin;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    final titleRow = <Widget>[
      CircleAvatar(
        backgroundColor: const Color(0x33000000),
        radius: 16.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: icon,
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
      titleRow.addAll(rightSideIcons);
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
          verticalMargin8,
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
                child: const Text(
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
                              keyboardAppearance: Brightness.dark,
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
                        child: const Text(
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
                  child: const Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    child: InfIcon(AppIcons.close, size: 16.0),
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
