import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inf/app/theme.dart';

class OnBoardingPager extends StatefulWidget {
  const OnBoardingPager({
    Key key,
    this.controller,
    this.physics,
    this.padding,
    this.radius,
    this.inset = 12.0,
    this.onPageChanged,
    this.pageSnapping = true,
    this.addRepaintBoundaries = false,
    this.addSemanticIndexes = true,
    @required this.children,
  }) : super(key: key);

  final PageController controller;
  final ScrollPhysics physics;
  final EdgeInsets padding;
  final Radius radius;
  final double inset;
  final ValueChanged<int> onPageChanged;
  final bool pageSnapping;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final List<Widget> children;

  @override
  _OnBoardingPagerState createState() => _OnBoardingPagerState();
}

const PageScrollPhysics _kPagePhysics = PageScrollPhysics();

class _OnBoardingPagerState extends State<OnBoardingPager> {
  PageController _controller;
  int _lastReportedPage = 0;

  PageController get _effectiveController => widget.controller ?? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = PageController();
    }
    _lastReportedPage = _effectiveController.initialPage;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  List<Widget> buildChildren() {
    return List.generate(widget.children.length, (int index) {
      Widget child = widget.children[index];
      if (widget.addRepaintBoundaries) {
        child = RepaintBoundary.wrap(child, index);
      }
      if (widget.addSemanticIndexes) {
        child = IndexedSemantics(
          index: index,
          child: child,
        );
      }
      return child;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const StackViewportScrollBehavior(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification.depth == 0 && widget.onPageChanged != null && notification is ScrollUpdateNotification) {
            final PageMetrics metrics = notification.metrics;
            final int currentPage = metrics.page.round();
            if (currentPage != _lastReportedPage) {
              _lastReportedPage = currentPage;
              widget.onPageChanged(currentPage);
            }
          }
          return false;
        },
        child: Scrollable(
          axisDirection: AxisDirection.right,
          controller: _effectiveController,
          physics: _kPagePhysics.applyTo(widget.physics),
          viewportBuilder: (BuildContext context, ViewportOffset position) {
            return StackViewport(
              viewportOffset: position,
              padding: widget.padding,
              radius: widget.radius,
              inset: widget.inset,
              children: buildChildren(),
            );
          },
        ),
      ),
    );
  }
}

class StackViewportScrollBehavior extends ScrollBehavior {
  const StackViewportScrollBehavior() : super();

  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class StackViewport extends MultiChildRenderObjectWidget {
  StackViewport({
    Key key,
    @required this.viewportOffset,
    this.padding,
    this.radius,
    this.inset = 12.0,
    List<Widget> children = const <Widget>[],
  })  : assert(viewportOffset != null),
        assert(inset != null),
        super(key: key, children: children);

  final ViewportOffset viewportOffset;
  final EdgeInsets padding;
  final Radius radius;
  final double inset;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderStackViewport(
      viewportOffset: viewportOffset,
      padding: padding,
      radius: radius,
      inset: inset,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderStackViewport renderObject) {
    renderObject
      ..viewportOffset = viewportOffset
      ..padding = padding
      ..radius = radius
      ..inset = inset;
  }
}

class RenderStackViewport extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _ChildParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _ChildParentData> {
  RenderStackViewport({
    @required ViewportOffset viewportOffset,
    double inset,
    EdgeInsets padding,
    Radius radius,
    List<RenderBox> children,
  })  : assert(viewportOffset != null),
        _viewportOffset = viewportOffset,
        _padding = padding ?? EdgeInsets.zero,
        _radius = radius ?? Radius.zero,
        _inset = inset ?? 0.0,
        super() {
    addAll(children);
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _ChildParentData) child.parentData = _ChildParentData();
  }

  ViewportOffset _viewportOffset;

  ViewportOffset get viewportOffset => _viewportOffset;

  set viewportOffset(ViewportOffset value) {
    assert(value != null);
    if (value == _viewportOffset) {
      return;
    }
    if (attached) _viewportOffset.removeListener(markNeedsPaint);
    _viewportOffset = value;
    if (attached) _viewportOffset.addListener(markNeedsPaint);
    // We need to go through layout even if the new offset has the same pixels
    // value as the old offset so that we will apply our viewport and content
    // dimensions.
    markNeedsLayout();
  }

  EdgeInsets _padding;

  EdgeInsets get padding => _padding;

  set padding(EdgeInsets value) {
    assert(value != null);
    if (value == _padding) {
      return;
    }
    _padding = value;
    markNeedsLayout();
  }

  Radius _radius;

  Radius get radius => _radius;

  set radius(Radius value) {
    assert(value != null);
    if (value == _radius) {
      return;
    }
    _radius = value;
    markNeedsLayout();
  }

  double _inset;

  double get inset => _inset;

  set inset(double value) {
    assert(value != null);
    if (value == _inset) {
      return;
    }
    _inset = value;
    markNeedsLayout();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _viewportOffset.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _viewportOffset.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  bool get alwaysNeedsCompositing => true;

  @override
  void performResize() {
    super.performResize();
    size = constraints.biggest;
    viewportOffset.applyViewportDimension(size.width);
  }

  @override
  void performLayout() {
    if (childCount == 0) {
      size = constraints.biggest;
      assert(size.isFinite);
      viewportOffset.applyViewportDimension(0.0);
      viewportOffset.applyContentDimensions(0.0, 0.0);
      return;
    }
    double width = constraints.minWidth;
    double height = constraints.minHeight;
    double contentDimension = 0.0;
    _ChildParentData childData;
    int index = 0;
    final childConstraints = BoxConstraints.tight(
      _padding.deflateSize(constraints.biggest),
    );
    for (RenderBox child = firstChild; child != null; child = childData.nextSibling) {
      child.layout(childConstraints, parentUsesSize: true);
      width = math.max(width, child.size.width);
      height = math.max(height, child.size.height);
      contentDimension += child.size.width;
      childData = child.parentData;
      childData.index = index++;
      childData.offset = _padding.topLeft;
    }
    size = Size(width, height);
    contentDimension -= childConstraints.maxWidth;
    _viewportOffset.applyViewportDimension(childConstraints.maxWidth);
    _viewportOffset.applyContentDimensions(0.0, contentDimension);
    assert(size.width == constraints.constrainWidth(width));
    assert(size.height == constraints.constrainHeight(height));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _ChildParentData childData;
    for (RenderBox child = lastChild; child != null; child = childData.previousSibling) {
      childData = child.parentData;
      final paddedSize = _padding.deflateSize(size);
      final params = _ChildParams.create(childData.index, viewportOffset.pixels, paddedSize.width, inset);
      context.pushTransform(true, offset, params.getTransform(size), (PaintingContext context, Offset offset) {
        context.pushOpacity(offset, (255 * params.opacity).toInt(), (PaintingContext context, Offset offset) {
          offset = childData.offset + offset + Offset(0.0, params.offsetY);
          final roundedRect = RRect.fromRectAndRadius(offset & child.size, _radius);
          final Path offsetRRectAsPath = Path()..addRRect(roundedRect);
          final PhysicalModelLayer physicalModel = PhysicalModelLayer(
            clipPath: offsetRRectAsPath,
            clipBehavior: Clip.antiAlias,
            elevation: 4.0,
            color: AppTheme.darkGrey,
            shadowColor: Colors.black,
          );
          context.pushLayer(physicalModel, (PaintingContext context, Offset offset) {
            context.paintChild(child, offset);
            if (params.visible < 0.0) {
              final overlayPaint = Paint()..color = Colors.white.withOpacity(0.75 * -params.visible);
              context.canvas.drawRect(offset & child.size, overlayPaint);
            }
          }, offset, childPaintBounds: roundedRect.outerRect);
        });
      });
    }
  }

  @override
  bool hitTestChildren(HitTestResult result, {Offset position}) {
    _ChildParentData childData;
    final paddedSize = _padding.deflateSize(size);
    for (RenderBox child = firstChild; child != null; child = childData.nextSibling) {
      childData = child.parentData;
      final params = _ChildParams.create(childData.index, viewportOffset.pixels, paddedSize.width, inset);
      if (params.visible != 0.0) {
        continue;
      }
      final Matrix4 inverse = Matrix4.tryInvert(params.getTransform(size));
      if (inverse == null) {
        // We cannot invert the effective transform. That means the child
        // doesn't appear on screen and cannot be hit.
        continue;
      }
      Offset childPos = MatrixUtils.transformPoint(inverse, position);
      if (child.hitTest(result, position: childPos - childData.offset)) {
        return true;
      }
    }
    return false;
  }
}

class _ChildParentData extends ContainerBoxParentData<RenderBox> {
  int index;
}

class _ChildParams {
  static _ChildParams create(int index, double offset, double width, double inset) {
    double page = math.max(0.0, offset) / math.max(1.0, width);
    final visible = _getPageVisibleAmount(index, page);

    double scale = ((inset * 2) / width);
    if (visible <= 0.0) {
      scale = 1.0 - scale * index * -visible;
    } else {
      scale = 1.0 + (0.5 * visible);
    }
    //print('getScaleForIndex($index) = $visible = $scale');
    final offsetY = ((visible < 0.0) ? -inset * index * -visible : 2 * inset * visible) * 0.5;
    final opacity = (visible < 0.0) ? 1.0 - (0.5 * -visible) : (1.0 - visible);

    return _ChildParams._(visible, scale, offsetY, opacity);
  }

  static double _getPageVisibleAmount(int index, double page) {
    if (page >= index && page < (index + 1.0)) {
      return (page % 1.0);
    } else if ((page + 1.0) >= index && (page + 1.0) < (index + 1.0)) {
      return -1.0 + (page % 1.0);
    } else if (index < page) {
      return 1.0;
    } else {
      return -1.0;
    }
  }

  const _ChildParams._(this.visible, this.scale, this.offsetY, this.opacity);

  final double visible;
  final double scale;
  final double offsetY;
  final double opacity;

  Matrix4 getTransform(Size size) {
    final Matrix4 transform = Matrix4.identity();
    Offset center = Alignment.topCenter.alongSize(size);
    transform.translate(center.dx, center.dy);
    transform.translate(0.0, offsetY);
    transform.scale(scale, scale);
    transform.translate(-center.dx, -center.dy);
    return transform;
  }
}
