import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/filter/bottom_nav.dart';
import 'package:inf/ui/main/map_view.dart';
import 'package:inf/ui/offer_views/browse_carousel_item.dart';
import 'package:inf/ui/offer_views/offer_details_page.dart';
import 'package:inf/ui/offer_views/offer_post_tile.dart';
import 'package:inf/ui/user_profile/view_profile_page.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/inf_toggle.dart';
import 'package:inf/ui/widgets/white_border_circle_avatar.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

enum BrowseMode { map, list }

class MainBrowseSection extends StatefulWidget {
  const MainBrowseSection({
    Key key,
    this.padding = EdgeInsets.zero,
  })  : assert(padding != null),
        super(key: key);

  final EdgeInsets padding;

  @override
  _MainBrowseSectionState createState() => _MainBrowseSectionState();
}

class _MainBrowseSectionState extends State<MainBrowseSection> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _carouselAnim;
  Animation<double> _listAnim;
  BrowseMode _browseMode = BrowseMode.map;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );
    _carouselAnim = Tween<Offset>(begin: const Offset(0.0, 0.0), end: const Offset(1.0, 0.0)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );
    _listAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    _animate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        IgnorePointer(
          ignoring: _browseMode == BrowseMode.list,
          child: MainMapView(),
        ),
        IgnorePointer(
          ignoring: _browseMode == BrowseMode.list,
          child: SlideTransition(
            position: _carouselAnim,
            child: _BrowseCarouselView(
              padding: widget.padding,
            ),
          ),
        ),
        IgnorePointer(
          ignoring: _browseMode == BrowseMode.map,
          child: AnimatedBuilder(
            animation: _listAnim,
            builder: (BuildContext context, Widget child) {
              final blur = 3.0 * _listAnim.value;
              return BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: child,
              );
            },
            child: RepaintBoundary(
              child: Container(
                color: Colors.transparent,
                child: FadeTransition(
                  opacity: _listAnim,
                  child: _BrowseListView(),
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          bottom: false,
          child: Container(
            alignment: Alignment.centerRight,
            height: 48.0,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InfToggle<BrowseMode>(
                leftState: BrowseMode.map,
                rightState: BrowseMode.list,
                currentState: _browseMode,
                left: AppIcons.location,
                right: AppIcons.browse,
                onChanged: _onSwitchToggled,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onSwitchToggled(BrowseMode value) {
    setState(() {
      _browseMode = value;
      _animate();
    });
  }

  void _animate() {
    if (_browseMode == BrowseMode.map) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }
}

class _BrowseCarouselView extends StatefulWidget {
  const _BrowseCarouselView({
    Key key,
    @required this.padding,
  }) : super(key: key);

  final EdgeInsets padding;

  @override
  _BrowseCarouselViewState createState() => _BrowseCarouselViewState();
}

class _BrowseCarouselViewState extends State<_BrowseCarouselView> {
  final _controller = PageController(viewportFraction: 1.0 / 2.5); // TODO: work out dimensions

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BusinessOffer>>(
      stream: backend<OfferManager>().featuredOffers,
      builder: (BuildContext context, AsyncSnapshot<List<BusinessOffer>> snapshot) {
        if (snapshot.hasData) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                assert(constraints.hasBoundedHeight);
                return Container(
                  margin: widget.padding + const EdgeInsets.only(bottom: 32.0),
                  height: constraints.maxHeight / 5.0,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    controller: _controller,
                    physics: const PageScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final offer = snapshot.data[index];
                      final tag = 'browse-offer-carousel-${offer.id}';
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: AspectRatio(
                          aspectRatio: 5.0 / 4.3,
                          child: BrowseCarouselItem(
                            offer: offer,
                            onPressed: () => () => _onShowDetails(context, offer, tag),
                            tag: tag,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        } else {
          return emptyWidget;
        }
      },
    );
  }
}

class _BrowseListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return StreamBuilder<List<InfItem>>(
      stream: backend<ListManager>().listItems,
      builder: (BuildContext context, AsyncSnapshot<List<InfItem>> snapshot) {
        if (!snapshot.hasData) {
          // TODO
          return const Center(child: Text('Sorry no offer matches your criteria'));
        }
        final users =
            snapshot.data.where((item) => item.type == InfItemType.user).map<User>((item) => item.user).toList();
        final offers = snapshot.data
            .where((item) => item.type == InfItemType.offer)
            .map<BusinessOffer>((item) => item.offer)
            .toList();
        return Material(
          color: AppTheme.blackTwo,
          child: Stack(
            children: <Widget>[
              ListView.builder(
                padding: EdgeInsets.only(
                  top: mediaQuery.padding.top + 54.0,
                  bottom: mediaQuery.padding.bottom + kBottomNavHeight,
                ),
                itemCount: offers.length + (users.isNotEmpty ? 1 : 0),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0 && users.isNotEmpty) {
                    return Material(
                      color: AppTheme.grey,
                      child: SizedBox(
                        height: 96.0,
                        child: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: constraints.copyWith(
                                  minWidth: constraints.maxWidth,
                                  maxWidth: double.infinity,
                                ),
                                child: IntrinsicWidth(
                                  child: Row(
                                    children: <Widget>[
                                      for (final user in users)
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => Navigator.of(context).push(ViewProfilePage.route(user)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 12.0),
                                              child: AspectRatio(
                                                aspectRatio: 1.1,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: WhiteBorderCircle(
                                                        child: InfImage(
                                                          lowResUrl: user.avatarThumbnail.lowResUrl,
                                                          imageUrl: user.avatarThumbnail.imageUrl,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(user.name),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    if (users.isNotEmpty) {
                      index--;
                    }
                    final offer = offers[index];
                    final tag = 'browse-offer-list-${offer.id}';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: OfferPostTile(
                        offer: offer,
                        onPressed: () => _onShowDetails(context, offer, tag),
                        tag: tag,
                      ),
                    );
                  }
                },
              ),
              SafeArea(
                bottom: false,
                child: Container(
                  height: 48.0,
                  alignment: Alignment.center,
                  child: Text('${offers.length} OFFERS NEAR YOU'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

void _onShowDetails(BuildContext context, BusinessOffer partialOffer, String tag) {
  Navigator.of(context).push(
    OfferDetailsPage.route(
      Stream.fromFuture(backend.get<OfferManager>().getFullOffer(partialOffer.id)),
      initialOffer: partialOffer,
      tag: tag,
    ),
  );
}
