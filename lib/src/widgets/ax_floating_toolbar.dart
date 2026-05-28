import 'package:flutter/material.dart';

/// Anchor used by [AxFloatingToolbar] when positioning the toolbar before
/// (or instead of) any user dragging.
enum AxFloatingAnchor {
  topLeft,
  topRight,
  topCenter,
  bottomLeft,
  bottomRight,
  bottomCenter,
}

/// A draggable floating wrapper around any widget (typically an [AxToolbar]).
///
/// Place it inside a [Stack] (e.g. `Scaffold(body: Stack(children: [content, AxFloatingToolbar(...)]))`).
/// The toolbar appears at [initialOffset] relative to [anchor], and — when
/// [draggable] is true — the user can pan it around. It is clamped to stay
/// within the parent constraints minus [margin].
///
/// ```dart
/// Stack(
///   children: [
///     MyCanvas(),
///     AxFloatingToolbar(
///       anchor: AxFloatingAnchor.topCenter,
///       initialOffset: Offset(0, 16),
///       child: AxToolbar(...),
///     ),
///   ],
/// );
/// ```
class AxFloatingToolbar extends StatefulWidget {
  const AxFloatingToolbar({
    super.key,
    required this.child,
    this.initialOffset = const Offset(16, 16),
    this.anchor = AxFloatingAnchor.topLeft,
    this.draggable = true,
    this.margin = const EdgeInsets.all(8),
    this.dragHandleBuilder,
  });

  final Widget child;

  /// Distance from the [anchor] used for the initial position. Interpreted
  /// as `(insetFromHorizontalEdge, insetFromVerticalEdge)` of the anchor.
  final Offset initialOffset;

  final AxFloatingAnchor anchor;
  final bool draggable;

  /// Minimum distance kept between the toolbar and the parent edges while
  /// dragging.
  final EdgeInsets margin;

  /// When provided, only the widget returned by this builder is draggable
  /// (a "handle"). Otherwise the entire [child] is the drag surface.
  final WidgetBuilder? dragHandleBuilder;

  @override
  State<AxFloatingToolbar> createState() => _AxFloatingToolbarState();
}

class _AxFloatingToolbarState extends State<AxFloatingToolbar> {
  Offset? _offset;
  Size _size = Size.zero;

  void _onPanUpdate(DragUpdateDetails details, Size parent) {
    setState(() {
      final current = _offset ?? _anchorOffset(parent, _size);
      var next = current + details.delta;
      final minX = widget.margin.left;
      final maxX = parent.width - _size.width - widget.margin.right;
      final minY = widget.margin.top;
      final maxY = parent.height - _size.height - widget.margin.bottom;
      next = Offset(
        maxX > minX ? next.dx.clamp(minX, maxX) : minX,
        maxY > minY ? next.dy.clamp(minY, maxY) : minY,
      );
      _offset = next;
    });
  }

  Offset _anchorOffset(Size parent, Size self) {
    final dx = switch (widget.anchor) {
      AxFloatingAnchor.topLeft ||
      AxFloatingAnchor.bottomLeft =>
        widget.initialOffset.dx,
      AxFloatingAnchor.topRight ||
      AxFloatingAnchor.bottomRight =>
        parent.width - self.width - widget.initialOffset.dx,
      AxFloatingAnchor.topCenter ||
      AxFloatingAnchor.bottomCenter =>
        (parent.width - self.width) / 2,
    };
    final dy = switch (widget.anchor) {
      AxFloatingAnchor.topLeft ||
      AxFloatingAnchor.topRight ||
      AxFloatingAnchor.topCenter =>
        widget.initialOffset.dy,
      AxFloatingAnchor.bottomLeft ||
      AxFloatingAnchor.bottomRight ||
      AxFloatingAnchor.bottomCenter =>
        parent.height - self.height - widget.initialOffset.dy,
    };
    return Offset(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    // Positioned.fill lets us occupy the whole ancestor Stack so we can read
    // its size via LayoutBuilder; the inner Stack then hosts the actual
    // (movable) Positioned toolbar.
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final parent = Size(
            constraints.hasBoundedWidth ? constraints.maxWidth : 0,
            constraints.hasBoundedHeight ? constraints.maxHeight : 0,
          );
          final pos = _offset ?? _anchorOffset(parent, _size);

          Widget toolbar = _SizeReporter(
            onSize: (s) {
              if (s != _size) {
                setState(() => _size = s);
              }
            },
            child: widget.child,
          );

          if (widget.draggable && widget.dragHandleBuilder == null) {
            toolbar = GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanUpdate: (d) => _onPanUpdate(d, parent),
              child: toolbar,
            );
          } else if (widget.draggable && widget.dragHandleBuilder != null) {
            toolbar = Stack(
              children: [
                toolbar,
                Positioned(
                  top: 0,
                  left: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanUpdate: (d) => _onPanUpdate(d, parent),
                    child: widget.dragHandleBuilder!(context),
                  ),
                ),
              ],
            );
          }

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(left: pos.dx, top: pos.dy, child: toolbar),
            ],
          );
        },
      ),
    );
  }
}

/// Reports the rendered size of [child] via [onSize] after each frame.
class _SizeReporter extends StatefulWidget {
  const _SizeReporter({required this.child, required this.onSize});

  final Widget child;
  final ValueChanged<Size> onSize;

  @override
  State<_SizeReporter> createState() => _SizeReporterState();
}

class _SizeReporterState extends State<_SizeReporter> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final box = context.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        widget.onSize(box.size);
      }
    });
    return widget.child;
  }
}
