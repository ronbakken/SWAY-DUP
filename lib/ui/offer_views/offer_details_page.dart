import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/messaging/bottom_sheets/negotiation_sheet.dart';
import 'package:inf/ui/messaging/conversation_screen.dart';
import 'package:inf/ui/offer_views/offer_edit_page.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_bottom_button.dart';
import 'package:inf/ui/widgets/inf_bottom_sheet.dart';
import 'package:inf/ui/widgets/inf_business_row.dart';
import 'package:inf/ui/widgets/inf_icon_button.dart';
import 'package:inf/ui/widgets/inf_divider.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/inf_page_indicator.dart';
import 'package:inf/ui/widgets/inf_page_scroll_view.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/page_widget.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:inf/ui/widgets/widget_utils.dart';
import 'package:intl/intl.dart';

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

  bool _canBeEdited(BusinessOffer offer) {
    return offer.businessAccountId == backend<UserManager>().currentUser.id;
  }

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
                title: Text(offer.title),
                actions: [
                  if (_canBeEdited(offer))
                    InfIconButton(
                      icon: AppIcons.edit,
                      onPressed: onEdit,
                    ),
                ],
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
              lowResUrl: offer.images[0].lowResUrl,
            ),
          );
        },
      );
    }

    final configService = backend<ConfigService>();

    return InfPageScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AspectRatio(
            aspectRatio: (16.0 / 12.0),
            child: imageArea,
          ),
          InfBusinessRow(
            leading: Image.network(
              offer.businessAvatarThumbnailUrl,
              fit: BoxFit.cover,
            ),
            title: offer.businessName,
            subtitle: offer.businessDescription,
          ),
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
                const InfDivider(),
                _DetailEntry(
                  icon: const InfAssetImage(AppIcons.deliverable),
                  title: 'DELIVERABLES',
                  rightSideIcons: <Widget>[
                    ...offer.terms.deliverable.channels.map<Widget>(
                      (channel) {
                        return InfAssetImage(
                          channel.logoRawAsset,
                          width: 24.0,
                          height: 24.0,
                        );
                      },
                    ),
                    ...offer.terms.deliverable.types.map<Widget>(
                      (type) {
                        return InfAssetImage(
                          configService.getDeliveryIconFromType(type).iconAsset,
                          width: 16.0,
                          height: 16.0,
                        );
                      },
                    ),
                  ].map<Widget>((widget) {
                    return Container(
                      margin: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                      alignment: Alignment.center,
                      width: 24.0,
                      height: 24.0,
                      child: widget,
                    );
                  }).toList(),
                  text: offer.terms.deliverable.description,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const InfDivider(),
                    buildRewardsRow(),
                    const InfDivider(),
                    _DetailEntry(
                      icon: const InfAssetImage(AppIcons.location),
                      title: 'LOCATION',
                      text: offer.location.name ?? '',
                    ),
                    const InfDivider(),
                    buildCategories(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottom: _DetailsBottomButton(
        offer: offer,
      ),
    );
  }

  _DetailEntry buildRewardsRow() {
    final terms = offer.terms;
    return _DetailEntry(
      icon: const InfAssetImage(AppIcons.gift),
      title: 'REWARDS',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Value of ${terms.getTotalValueAsString()}'),
          verticalMargin12,
          if (terms.cashValue != null)
            Row(
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
                Text('${terms.cashValueAsString}'),
              ],
            ),
          verticalMargin12,
          if (terms.serviceDescription != null)
            Row(
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
                Text('${terms.serviceDescription ?? ''}'),
              ],
            ),
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
              children: <Widget>[
                for (final category in offer.categories)
                  Container(
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
                  ),
              ],
            )
          : emptyWidget,
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
          lowResUrl: offer.images[i].lowResUrl,
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

  void onEdit() {
    Navigator.of(context).push(OfferEditPage.route(offer));
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
              if (rightSideIcons != null)
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    children: rightSideIcons,
                  ),
                ),
            ],
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

class _DetailsBottomButton extends StatefulWidget implements PreferredSizeWidget {
  const _DetailsBottomButton({
    Key key,
    @required this.offer,
  }) : super(key: key);

  final BusinessOffer offer;

  @override
  Size get preferredSize => const Size(double.infinity, 48.0 + 12.0);

  @override
  _DetailsBottomButtonState createState() => _DetailsBottomButtonState();
}

class _DetailsBottomButtonState extends State<_DetailsBottomButton> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      vsync: this,
      duration: kThemeChangeDuration,
      alignment: Alignment.topCenter,
      curve: Curves.fastOutSlowIn,
      child: FutureBuilder<Optional<ConversationHolder>>(
        future: backend<ConversationManager>().findConversationHolderWithTopicId(widget.offer.topicId),
        initialData: backend<ConversationManager>().getConversationHolderFromCache(widget.offer.topicId),
        builder: (BuildContext context, AsyncSnapshot<Optional<ConversationHolder>> snapshot) {
          if ((snapshot.hasData || snapshot.connectionState == ConnectionState.done) && !snapshot.hasError) {
            return InfBottomButton(
              text: snapshot.data.isPresent ? 'OPEN CONVERSATION' : 'TELL US WHAT YOU CAN OFFER',
              onPressed: snapshot.data.isPresent ? () => _openConversation(snapshot.data.value) : _showApplyBottomSheet,
              panelColor: AppTheme.blackTwo,
            );
          } else {
            return emptyWideWidget;
          }
        },
      ),
    );
  }

  void _openConversation(ConversationHolder conversationHolder) {
    Navigator.of(context).push(ConversationScreen.route(conversationHolder));
  }

  void _showApplyBottomSheet() {
    Navigator.of(context).push(_ApplyBottomSheet.route(widget.offer));
  }
}

class _ApplyBottomSheet extends StatefulWidget {
  static Route<dynamic> route(BusinessOffer offer) {
    return InfBottomSheet.route(
      title: 'What can you offer?',
      child: _ApplyBottomSheet(offer: offer),
    );
  }

  const _ApplyBottomSheet({
    Key key,
    @required this.offer,
  }) : super(key: key);

  final BusinessOffer offer;

  @override
  _ApplyBottomSheetState createState() => _ApplyBottomSheetState();
}

class _ApplyBottomSheetState extends State<_ApplyBottomSheet> {
  final _initialOffer = TextEditingController();

  Future<ConversationHolder> _createFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _createFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InputDecorator(
                        decoration: const InputDecoration(),
                        isFocused: false,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextField(
                            controller: _initialOffer,
                            decoration: null,
                            maxLines: null,
                            keyboardAppearance: Brightness.dark,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                verticalMargin12,
                InfStadiumButton(
                  onPressed: _onApplyPressed,
                  text: 'APPLY',
                ),
                verticalMargin8,
                InfStadiumButton(
                  onPressed: _onNegotiatePressed,
                  text: 'NEGOTIATE',
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          return const Padding(
            padding: const EdgeInsets.all(32.0),
            child: loadingWidget,
          );
        }
      },
    );
  }

  void _onApplyPressed() {
    createConversation(_initialOffer.text, widget.offer.terms.toProposal());
  }

  void _onNegotiatePressed() async {
    final proposal = await Navigator.of(context).push<Proposal>(
      NegotiationSheet.route(
        existingProposal: widget.offer.terms.toProposal(),
        confirmButtonTitle: 'APPLY',
      ),
    );
    if (proposal != null) {
      createConversation(null, proposal);
    }
  }

  void createConversation(String text, Proposal proposal) {
    if (mounted) {
      final currentUser = backend<UserManager>().currentUser;
      final message = Message(currentUser, text: text, action: MessageAction.offer, attachments: [
        MessageAttachment.forObject(proposal),
      ]);
      setState(() {
        _createFuture =
            backend<ConversationManager>().createConversationForOffer(widget.offer, message).then((conversationHolder) {
          if (mounted) {
            final nav = Navigator.of(context);
            nav.pop();
            nav.push(ConversationScreen.route(conversationHolder));
          }
        });
      });
    }
  }
}
