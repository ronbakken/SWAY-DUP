import 'package:decimal/decimal.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/inf_memory_image.dart';
import 'package:inf/ui/widgets/inf_page_indicator.dart';
import 'package:inf/ui/widgets/bottom_sheet.dart' as inf_bottom_sheet;
import 'package:inf/ui/widgets/white_border_circle_avatar.dart';
import 'package:inf_common/inf_common.dart';
import 'package:intl/intl.dart';

class OfferDetailsPage extends StatefulWidget {
  const OfferDetailsPage({
    Key key,
    @required this.onApply,
    @required this.onNegotiate,
    @required this.account,
    @required this.offer,
    @required this.senderAccount,
    @required this.config,
    this.onOnboardingPressed,
    this.onSenderAccountPressed,
    this.onProposalPressed,
    this.heroTag,
  }) : super(key: key);

  final Future<DataProposal> Function(String remarks) onApply;
  final Future<DataProposal> Function(String remarks) onNegotiate;

  final DataAccount account;
  final DataOffer offer;
  final DataAccount senderAccount;
  final ConfigData config;

  final Function() onOnboardingPressed;
  final Function() onSenderAccountPressed;
  final Function() onProposalPressed; // TODO: Already proposed!

  final String heroTag;

  @override
  OfferDetailsPageState createState() => OfferDetailsPageState();
}

class OfferDetailsPageState extends State<OfferDetailsPage> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.offer.title),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final DataAccount account = widget.account;
    final DataOffer offer = widget.offer;
    Widget imageArea = _buildImageArea();
    if (widget.heroTag != null) {
      imageArea = Hero(
        tag: widget.heroTag,
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
                    const BorderRadius.only(), animation.value),
                child: child,
              );
            },
            child: InfImage(
              imageUrl: offer.coverUrls[0],
              lowRes: offer.coversBlurred[0],
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
                  aspectRatio: 16.0 / 9.0,
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
                        // TODO(escamoteur): show all
                        rightSideIcons: offer.terms.deliverableSocialPlatforms
                            .take(1)
                            .map<Widget>((int providerId) => InfMemoryImage(
                                widget.config.oauthProviders[providerId]
                                    .foregroundImage)).toList(),
                        text: offer.terms.deliverableContentFormats.isEmpty
                            ? ''
                            : widget
                                .config
                                .contentFormats[
                                    offer.terms.deliverableContentFormats[0]]
                                .label,
                      ),
                      account.accountId != Int64.ZERO // Logged in
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Divider(
                                    height: 1, color: AppTheme.white30),
                                buildRewardsRow(),
                                const Divider(
                                    height: 1, color: AppTheme.white30),
                                _DetailEntry(
                                  icon: const InfAssetImage(AppIcons.location),
                                  title: 'LOCATION',
                                  text: offer.locationAddress,
                                ),
                                const Divider(
                                    height: 1, color: AppTheme.white30),
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
        account.accountId != Int64.ZERO && account.accountType != offer.senderAccountType // Logged in
            ? Container(
                color: AppTheme.blackTwo,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 26.0),
                    child: RaisedButton(
                      onPressed: _showProposalBottomSheet,
                      shape: const StadiumBorder(),
                      child: Container(
                        alignment: Alignment.center,
                        height: 44.0,
                        child: const Text(
                          'TELL US WHAT YOU CAN OFFER',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  _ProposalBottomSheet _proposalBottomSheetBuilder(BuildContext context) {
    return _ProposalBottomSheet(
      onApply: widget.onApply,
      onNegotiate: widget.onNegotiate,
    );
  }

  void _showProposalBottomSheet() {
    inf_bottom_sheet.showModalBottomSheet<void>(
      context: context,
      builder: _proposalBottomSheetBuilder,
      dismissOnTap: false,
      resizeToAvoidBottomPadding: true,
    );
  }

  static String centsToDollars(int cents) {
    return '\$' +
        (Decimal.fromInt(cents) / Decimal.fromInt(100)).toStringAsFixed(2);
  }

  _DetailEntry buildRewardsRow() {
    final DataOffer offer = widget.offer;
    final DataTerms terms = offer.terms;
    return _DetailEntry(
      icon: const InfAssetImage(AppIcons.gift),
      title: 'REWARDS',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              'Total value of ${centsToDollars(terms.rewardCashValue + terms.rewardItemOrServiceValue)}'),
          const SizedBox(
            height: 12.0,
          ),
          terms.rewardCashValue > 0
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const CircleAvatar(
                      backgroundColor: AppTheme.blue,
                      radius: 15.0,
                      child: InfAssetImage(
                        AppIcons.dollarSign,
                        height: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text('${centsToDollars(terms.rewardCashValue)}'),
                  ],
                )
              : const SizedBox(),
          terms.rewardCashValue > 0
              ? const SizedBox(
                  height: 12.0,
                )
              : const SizedBox(),
          terms.rewardItemOrServiceDescription.isNotEmpty
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const CircleAvatar(
                      backgroundColor: AppTheme.blue,
                      radius: 15.0,
                      child: InfAssetImage(
                        AppIcons.gift,
                        height: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text('${terms.rewardItemOrServiceDescription}'),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  _DetailEntry buildCategories() {
    final DataOffer offer = widget.offer;
    return _DetailEntry(
      icon: const InfAssetImage(AppIcons.category),
      title: 'CATEGORIES',
      content: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        alignment: WrapAlignment.start,
        children: offer.categories.map<Widget>(
          (int categoryId) {
            return Container(
              decoration: const ShapeDecoration(
                shape: StadiumBorder(),
                color: AppTheme.blue,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(widget.config.categories[categoryId].label),
                    const SizedBox(
                      width: 10.0,
                    ),
                    const Icon(
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
    final DataOffer offer = widget.offer;
    final DataAccount senderAccount = widget.senderAccount;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      color: Colors.black,
      child: Row(
        children: <Widget>[
          WhiteBorderCircleAvatar(
              child: Image.network(senderAccount.hasAvatarUrl()
                  ? senderAccount.avatarUrl
                  : offer
                      .senderAvatarUrl)), // TODO(kaetemi): offer.sendarAvatarBlurred
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(senderAccount.hasName()
                    ? senderAccount.name
                    : offer.senderName),
                Text(
                  senderAccount.description,
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
    final DataOffer offer = widget.offer;
    return Container(
      height: 38.0,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      color: AppTheme.grey,
      child: Row(
        children: <Widget>[
          Text(
            '${offer.amountRemaining}/${offer.amountOffered} Available',
          ),
          Expanded(
            child: offer.hasScheduledClose()
                ? Text(
                    'Ends ${DateFormat('MM/dd/yy').format(DateTime.fromMillisecondsSinceEpoch(offer.scheduledClose.toInt()).toLocal())}',
                    textAlign: TextAlign.end,
                  )
                : const SizedBox(),
          )
        ],
      ),
    );
  }

  Widget _buildImageArea() {
    final DataOffer offer = widget.offer;
    final List<InfImage> imageArray = <InfImage>[];
    for (int i = 0; i < offer.coverUrls.length; ++i) {
      imageArray.add(InfImage(
        imageUrl: offer.coverUrls[i],
        lowRes: offer.coversBlurred[i],
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
        children: <Widget>[
          /// We add the title of the Reward group here to have a better teaser
          const Divider(height: 1, color: AppTheme.white30),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: const <Widget>[
                CircleAvatar(
                  backgroundColor: Color(0x33000000),
                  radius: 15.0,
                  child: InfAssetImage(
                    AppIcons.gift,
                    height: 14.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'REWARD',
                    style: TextStyle(
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
                children: <Widget>[
                  CurvedBox(
                    bottom: true,
                    color: AppTheme.blue,
                    curveFactor: 0.8,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24.0, bottom: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(Icons.lock, size: 36.0),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text('THERE IS MUCH MORE TO SEE'),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 27.0, vertical: 13.0),
                    child: Text(
                      'To view the full offer and apply you need to be a member of INF.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 27.0, vertical: 13.0),
                    child: Text(
                      "It's free to sign up and only takes a few seconds",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 26.0),
                    child: RaisedButton(
                      onPressed: widget.onOnboardingPressed,
                      /*() => Navigator.of(context)
                        ..push<void>(SignUpPage.route(
                            userType: AccountType.influencer, topPadding: 0)),*/
                      shape: const StadiumBorder(),
                      child: Container(
                        alignment: Alignment.center,
                        height: 44.0,
                        child: const Text(
                          'CONTINUE TO SEE MORE',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  )
                  /*
                  ,
                  Material(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 26, right: 26.0, bottom: 20.0),
                      child: InkWell(
                        onTap: widget.onSignUp ,
                        / * () => Navigator.of(context)
                          ..push<void>(SignUpPage.route(
                              userType: AccountType.influencer, topPadding: 0)),* /
                        child: Text(
                          'ALREADY A MEMBER? LOGIN',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                  */
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

  final List<Widget> rightSideIcons;
  final Widget icon;
  final String title;
  final String text;
  final EdgeInsetsGeometry margin;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    final List<Widget> titleRow = <Widget>[
      CircleAvatar(
        backgroundColor: const Color(0x33000000),
        radius: 15.0,
        child: icon,
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
          const SizedBox(height: 8.0),
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
  final Future<DataProposal> Function(String remarks) onApply;
  final Future<DataProposal> Function(String remarks) onNegotiate;

  const _ProposalBottomSheet({
    Key key,
    @required this.onApply,
    @required this.onNegotiate,
  }) : super(key: key);

  @override
  _ProposalBottomSheetState createState() => _ProposalBottomSheetState();
}

class _ProposalBottomSheetState extends State<_ProposalBottomSheet> {
  final TextEditingController _remarksEditingController =
      TextEditingController();

  void _onApply() {
    widget.onApply(_remarksEditingController.text);
  }

  void _onNegotiate() {
    widget.onNegotiate(_remarksEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Stack(
          children: <Widget>[
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
                children: <Widget>[
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      final DefaultTextStyle textStyle =
                          DefaultTextStyle.of(context);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: InputDecorator(
                          decoration: const InputDecoration(),
                          isFocused: false,
                          child: SizedBox(
                            height: textStyle.style.fontSize * 1.5,
                            child: TextField(
                              controller: _remarksEditingController,
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
                      onPressed: widget.onApply != null ? _onApply : null,
                      shape: const StadiumBorder(),
                      child: Container(
                        alignment: Alignment.center,
                        height: 44.0,
                        child: const Text(
                          'APPLY',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 12.0),
                    child: RaisedButton(
                      onPressed: widget.onNegotiate != null ? _onNegotiate : null,
                      shape: const StadiumBorder(),
                      child: Container(
                        alignment: Alignment.center,
                        height: 44.0,
                        child: const Text(
                          'NEGOTIATE',
                          style: TextStyle(
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
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
