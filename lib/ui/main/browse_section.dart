import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/main/browse_carousel_item.dart';
import 'package:inf/ui/main/browse_list_tile.dart';
import 'package:inf/ui/main/map_view.dart';
import 'package:inf/ui/offers/offer_details_page.dart';
import 'package:inf/ui/widgets/inf_toggle.dart';

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
    _carouselAnim = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.0, 0.0)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );
    _listAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 1.0, curve: Curves.easeOut),
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
      stream: backend.get<OfferManager>().getFeaturedBusinessOffers(),
      builder: (BuildContext context, AsyncSnapshot<List<BusinessOffer>> snapshot) {
        if (snapshot.hasData) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                assert(constraints.hasBoundedHeight);
                return Container(
                  margin: widget.padding + EdgeInsets.only(bottom: 32.0),
                  height: constraints.maxHeight / 5.0,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    controller: _controller,
                    physics: const PageScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final offer = snapshot.data[index];
                      final tag = 'browse-offer-carousel-${offer.offerId}';
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: AspectRatio(
                          aspectRatio: 5.0 / 4.3,
                          child: BrowseCarouselItem(
                            offer: offer,
                            onPressed: () => Navigator.of(context).push(OfferDetailsPage.route(offer, tag)),
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
          return SizedBox();
        }
      },
    );
  }
}

class _BrowseListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return StreamBuilder<List<BusinessOffer>>(
      stream: backend.get<OfferManager>().getBusinessOffers(),
      builder: (BuildContext context, AsyncSnapshot<List<BusinessOffer>> snapShot) {
        if (snapShot.connectionState == ConnectionState.active) {
          // TODO
          return Center(child: Text('Here has to be an waiting spinner'));
        }
        if (!snapShot.hasData) {
          // TODO
          return Center(child: Text('Here has to be an Error message'));
        }
        final offers = snapShot.data;
        return Stack(
          children: <Widget>[
            ListView.builder(
              padding: EdgeInsets.fromLTRB(16.0, mediaQuery.padding.top + 54.0, 16.0, 0.0),
              itemCount: offers.length,
              itemBuilder: (BuildContext context, int index) {
                final offer = offers[index];
                final tag = 'browse-offer-list-${offer.offerId}';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: BrowseListTile(
                    offer: offer,
                    onPressed: () => Navigator.of(context).push(OfferDetailsPage.route(offer, tag)),
                    tag: tag,
                  ),
                );
              },
            ),
            SafeArea(
              child: Container(
                height: 48.0,
                alignment: Alignment.center,
                child: Text('${offers.length} OFFERS NEAR YOU'),
              ),
            ),
          ],
        );
      },
    );
  }
}
