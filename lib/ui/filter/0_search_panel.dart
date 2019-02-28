import 'dart:math' as math show pi;

import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/filter/expand_transition.dart';
import 'package:inf/ui/filter/filter_button.dart';
import 'package:inf/ui/widgets/inf_icon.dart';
import 'package:inf/utils/animation_choreographer.dart';
import 'package:inf/utils/trim_path.dart';

typedef SearchPanelButtonPressed = void Function(FilterButton button);

class SearchFilterPanel extends StatefulWidget {
  const SearchFilterPanel({
    Key key,
    @required this.onButtonPressed,
  }) : super(key: key);

  final SearchPanelButtonPressed onButtonPressed;

  @override
  _SearchFilterPanelState createState() => _SearchFilterPanelState();
}

class _SearchFilterPanelState extends State<SearchFilterPanel> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Decoration> _backgroundAnim;
  Animation<double> _expandAnim;
  Animation<double> _inputAnim;

  TextEditingController _searchController;
  FocusNode _searchFocus;
  FocusNode _panelFocus;

  bool _expanded = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: 350), vsync: this);
    _controller.addStatusListener((AnimationStatus status) {
      setState(() => _expanded = (status != AnimationStatus.dismissed));
    });

    _backgroundAnim = DecorationTween(
      begin: BoxDecoration(
        color: Colors.transparent,
      ),
      end: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
      ),
    ).animate(_controller);

    _expandAnim = CurvedAnimation(
      parent: AnimationChoreographer.of(context),
      curve: Interval(0.4, 1.0),
    );

    _inputAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCirc,
    );

    _searchController = TextEditingController();
    _searchFocus = FocusNode();
    _searchFocus.addListener(_onSearchFocusChanged);
    _panelFocus = FocusNode();
  }

  @override
  void dispose() {
    _panelFocus.dispose();
    _searchFocus.dispose();
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchFocusChanged() {
    if (!_expanded) {
      _controller.forward();
    }
  }

  void _hideSearch() {
    FocusScope.of(context).requestFocus(_panelFocus);
    _controller.reverse().then((_){
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.padding.bottom;
    return Stack(
      children: <Widget>[
        Positioned.fill(
          top: 16.0,
          bottom: bottomPadding + 48.0,
          child: FadeTransition(
            opacity: _expandAnim,
            child: ExpandTransition(
              distance: _expandAnim,
              startAngle: 210.0,
              tickAngle: 40.0,
              children: FilterButton.searchPanel.map((button) {
                return FilterPanelButton(
                  button: button,
                  onTap: widget.onButtonPressed,
                );
              }).toList(growable: false),
            ),
          ),
        ),
        IgnorePointer(
          ignoring: !_expanded,
          child: Material(
            type: MaterialType.transparency,
            child: DecoratedBoxTransition(
              decoration: _backgroundAnim,
              child: InkWell(
                onTap: _hideSearch,
                child: SizedBox.expand(),
              ),
            ),
          ),
        ),
        Positioned(
          left: 24.0,
          right: 24.0,
          bottom: bottomPadding + 8.0,
          height: 42.0,
          child: CustomSingleChildLayout(
            delegate: _SearchDelegate(_controller),
            child: CustomPaint(
              painter: _SearchBorderPainter(_inputAnim),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocus,
                decoration: InputDecoration(
                  prefixIcon: InfIcon(AppIcons.search, size: 16.0),
                  contentPadding: const EdgeInsets.fromLTRB(0.0, 12.0, 24.0, 12.0),
                  border: InputBorder.none,
                  hintText: 'Keyword search',
                  hintMaxLines: 1,
                ),
                keyboardAppearance: Brightness.dark,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: bottomPadding + 20.0,
          right: 0.0,
          child: IgnorePointer(
            ignoring: !_expanded,
            child: FadeTransition(
              opacity: _inputAnim,
              child: RawMaterialButton(
                onPressed: _hideSearch,
                fillColor: AppTheme.lightBlue,
                constraints: BoxConstraints(minWidth: 20.0, minHeight: 20.0),
                materialTapTargetSize: MaterialTapTargetSize.padded,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(2.0),
                child: Icon(Icons.close, size: 16.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchDelegate extends SingleChildLayoutDelegate {
  Animation<double> expanded;

  _SearchDelegate(this.expanded) : super(relayout: expanded);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final height = constraints.maxHeight;
    final width = height + ((constraints.maxWidth - height) * expanded.value);
    return BoxConstraints.tight(Size(width, height));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(size.width - childSize.width, 0.0);
  }

  @override
  bool shouldRelayout(_SearchDelegate old) => old.expanded != expanded;
}

class _SearchBorderPainter extends CustomPainter {
  _SearchBorderPainter(this.expanded) : super(repaint: expanded);

  final Animation<double> expanded;

  final borderSide = const BorderSide(color: Colors.white, width: 2.0);
  final borderRadius = const BorderRadius.all(Radius.circular(4.0));

  @override
  void paint(Canvas canvas, Size size) {
    final roundRect = borderRadius.toRRect(Offset.zero & size);

    final Rect brCorner = Rect.fromLTWH(
      roundRect.right - roundRect.brRadiusX * 2.0,
      roundRect.bottom - roundRect.brRadiusY * 2.0,
      roundRect.brRadiusX * 2.0,
      roundRect.brRadiusY * 2.0,
    );

    const double cornerArcSweep = math.pi / 2.0;

    final path = Path()
      ..moveTo(roundRect.right, roundRect.top + (roundRect.height * 0.5))
      ..lineTo(roundRect.right, roundRect.bottom - roundRect.brRadiusY)
      ..addArc(brCorner, 0.0, cornerArcSweep)
      ..lineTo(roundRect.left + roundRect.blRadiusX, roundRect.bottom);

    canvas.drawPath(trimPath(path, expanded.value), borderSide.toPaint());
  }

  @override
  bool shouldRepaint(_SearchBorderPainter old) => true;
}

class FilterPanelButton extends StatelessWidget {
  const FilterPanelButton({
    Key key,
    @required this.button,
    this.onTap,
  }) : super(key: key);

  final FilterButton button;
  final SearchPanelButtonPressed onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 72.0,
          height: 72.0,
          child: Material(
            type: MaterialType.circle,
            color: AppTheme.buttonHalo,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => onTap(button),
              child: Center(
                child: InfIcon(button.icon),
              ),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Text(button.title),
      ],
    );
  }
}
