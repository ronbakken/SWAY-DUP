import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/ui/offer_views/browse_carousel_item.dart';
import 'package:inf/ui/offer_views/offer_post_tile.dart';
import 'package:inf/ui/offer_views/offer_details_page.dart';
import 'package:inf/ui/widgets/inf_toggle.dart';

enum BrowseMode { map, list }

class MainBrowseSection extends StatefulWidget {
  const MainBrowseSection({
    Key key,
    this.map,
    this.featured,
    this.list,
  }) : super(key: key);

  final Widget map;
  final Widget featured;
  final Widget list;

  @override
  _MainBrowseSectionState createState() => _MainBrowseSectionState();
}

class _MainBrowseSectionState extends State<MainBrowseSection>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _carouselAnim;
  Animation<double> _listAnim;
  BrowseMode _browseMode = BrowseMode.map;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _carouselAnim =
        Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.0, 0.0)).animate(
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
          child: widget.map,
        ),
        IgnorePointer(
          ignoring: _browseMode == BrowseMode.list,
          child: SlideTransition(
            position: _carouselAnim,
            child: widget.featured,
          ),
        ),
        IgnorePointer(
          ignoring: _browseMode == BrowseMode.map,
          child: AnimatedBuilder(
            animation: _listAnim,
            builder: (BuildContext context, Widget child) {
              final blur = 3.0 * _listAnim.value;
              return /* BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child:*/
                  child /*,
              )*/
                  ;
            },
            child: RepaintBoundary(
              child: Container(
                color: Colors.transparent,
                child: FadeTransition(
                  opacity: _listAnim,
                  child: widget.list,
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
