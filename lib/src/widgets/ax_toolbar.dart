import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../models/ax_tool.dart';
import '../theme/ax_toolbar_style.dart';
import '../theme/ax_toolbar_theme.dart';

/// A horizontal or vertical strip of selectable [AxTool] items.
///
/// `AxToolbar` is a *controlled* widget: pass [selectedId] from your state and
/// react to changes via [onSelected]. Pass `null` for [selectedId] if no tool
/// is initially active (allowed).
///
/// ```dart
/// AxToolbar(
///   selectedId: _tool,
///   onSelected: (id) => setState(() => _tool = id),
///   tools: const [
///     AxTool(id: 'pen', icon: Icon(Icons.edit), label: 'Pen'),
///     AxTool(id: 'shape', icon: Icon(Icons.square_outlined), label: 'Shape'),
///     AxTool(id: 'text', icon: Icon(Icons.text_fields), label: 'Text'),
///   ],
/// );
/// ```
class AxToolbar extends StatelessWidget {
  const AxToolbar({
    super.key,
    required this.tools,
    this.selectedId,
    this.onSelected,
    this.axis = Axis.horizontal,
    this.mainAxisSize = MainAxisSize.min,
    this.style,
  });

  final List<AxTool> tools;
  final String? selectedId;
  final ValueChanged<String>? onSelected;
  final Axis axis;

  /// Whether the toolbar should hug its content (default) or expand to fill
  /// its parent.
  final MainAxisSize mainAxisSize;

  /// Style overrides merged on top of [AxToolbarTheme] / defaults.
  final AxToolbarStyle? style;

  @override
  Widget build(BuildContext context) {
    final s = AxToolbarTheme.resolve(context, style);
    final spacing = s.itemSpacing ?? 0;

    final items = <Widget>[];
    for (var i = 0; i < tools.length; i++) {
      final tool = tools[i];
      if (i > 0 && spacing > 0) {
        items.add(
          axis == Axis.horizontal
              ? SizedBox(width: spacing)
              : SizedBox(height: spacing),
        );
      }
      items.add(
        _AxToolItem(
          key: ValueKey(tool.id),
          tool: tool,
          selected: tool.id == selectedId,
          axis: axis,
          style: s,
          onTap: () {
            tool.onTap?.call();
            if (tool.id != selectedId) onSelected?.call(tool.id);
          },
        ),
      );
    }

    final row = axis == Axis.horizontal
        ? Row(mainAxisSize: mainAxisSize, children: items)
        : Column(mainAxisSize: mainAxisSize, children: items);

    final content = Padding(
      padding: s.padding ?? EdgeInsets.zero,
      child: row,
    );

    return Material(
      type: MaterialType.canvas,
      color: Colors.transparent,
      elevation: s.elevation ?? 0,
      shadowColor: s.shadowColor,
      surfaceTintColor: s.surfaceTintColor,
      shape: s.shape ?? const RoundedRectangleBorder(),
      clipBehavior: Clip.antiAlias,
      child: _ToolbarBackground(style: s, child: content),
    );
  }
}

class _ToolbarBackground extends StatelessWidget {
  const _ToolbarBackground({required this.style, required this.child});

  final AxToolbarStyle style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final opacity = (style.opacity ?? 1).clamp(0.0, 1.0);
    final bg = style.gradient == null
        ? (style.backgroundColor ?? Colors.transparent)
            .withValues(alpha: opacity)
        : null;

    final decoration = BoxDecoration(
      color: bg,
      gradient: style.gradient,
      border: style.border,
    );

    final blur = style.blurSigma ?? 0;

    Widget layer = DecoratedBox(decoration: decoration, child: child);

    if (blur > 0) {
      layer = ClipRect(
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: const SizedBox.expand(),
              ),
            ),
            layer,
          ],
        ),
      );
    }
    return layer;
  }
}

class _AxToolItem extends StatefulWidget {
  const _AxToolItem({
    super.key,
    required this.tool,
    required this.selected,
    required this.axis,
    required this.style,
    required this.onTap,
  });

  final AxTool tool;
  final bool selected;
  final Axis axis;
  final AxToolbarStyle style;
  final VoidCallback onTap;

  @override
  State<_AxToolItem> createState() => _AxToolItemState();
}

class _AxToolItemState extends State<_AxToolItem> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.style;
    final enabled = widget.tool.enabled;
    final selected = widget.selected;
    final indicator = s.indicator ?? AxToolbarIndicator.background;

    final baseFg = s.foregroundColor;
    final selectedFg = s.selectedForegroundColor ?? baseFg;
    final fg = enabled
        ? (selected ? selectedFg : baseFg)
        : baseFg?.withValues(alpha: 0.38);

    // Resolve background based on indicator type + state.
    Color? bgColor;
    BorderRadiusGeometry? itemRadius =
        s.itemBorderRadius ?? const BorderRadius.all(Radius.circular(10));
    Border? itemBorder;

    switch (indicator) {
      case AxToolbarIndicator.background:
        bgColor = selected
            ? s.selectedBackgroundColor
            : (_hovered && enabled ? s.hoverColor : null);
        break;
      case AxToolbarIndicator.pill:
        bgColor = selected
            ? s.selectedBackgroundColor
            : (_hovered && enabled ? s.hoverColor : null);
        itemRadius = const BorderRadius.all(Radius.circular(999));
        break;
      case AxToolbarIndicator.underline:
        bgColor = _hovered && enabled ? s.hoverColor : null;
        if (selected) {
          final color = s.indicatorColor ?? Theme.of(context).colorScheme.primary;
          final width = s.indicatorThickness ?? 2;
          itemBorder = widget.axis == Axis.horizontal
              ? Border(bottom: BorderSide(color: color, width: width))
              : Border(right: BorderSide(color: color, width: width));
        }
        break;
      case AxToolbarIndicator.none:
        bgColor = _hovered && enabled ? s.hoverColor : null;
        break;
    }

    // Inner content
    Widget content = widget.tool.child ?? _buildIconLabel(s);

    content = IconTheme.merge(
      data: (s.iconTheme ?? const IconThemeData()).copyWith(color: fg),
      child: DefaultTextStyle.merge(
        style:
            (selected ? s.selectedLabelStyle : s.labelStyle)
                    ?.copyWith(color: fg) ??
                TextStyle(color: fg),
        child: content,
      ),
    );

    if (widget.tool.badge != null) {
      content = Stack(
        clipBehavior: Clip.none,
        children: [
          content,
          Positioned(top: -4, right: -4, child: widget.tool.badge!),
        ],
      );
    }

    final minSize = s.itemMinSize ?? 0;

    Widget item = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      constraints: BoxConstraints(minWidth: minSize, minHeight: minSize),
      padding: s.itemPadding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: itemRadius,
        border: itemBorder,
      ),
      child: Center(child: content),
    );

    item = AnimatedScale(
      scale: _pressed && enabled ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 80),
      child: item,
    );

    item = MouseRegion(
      onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: enabled ? (_) => setState(() => _hovered = false) : null,
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: enabled ? widget.onTap : null,
        child: item,
      ),
    );

    if (widget.tool.tooltip != null && widget.tool.tooltip!.isNotEmpty) {
      item = Tooltip(message: widget.tool.tooltip!, child: item);
    }

    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      label: widget.tool.label ?? widget.tool.tooltip,
      child: item,
    );
  }

  Widget _buildIconLabel(AxToolbarStyle s) {
    final tool = widget.tool;
    final hasIcon = tool.icon != null;
    final hasLabel = tool.label != null && tool.label!.isNotEmpty;
    final placement = s.labelPlacement ?? AxToolLabelPlacement.end;

    if (!hasIcon && !hasLabel) return const SizedBox.shrink();
    if (!hasIcon) return Text(tool.label!);
    if (!hasLabel || placement == AxToolLabelPlacement.none) return tool.icon!;

    final gap = s.iconLabelGap ?? 6;
    final iconWidget = tool.icon!;
    final labelWidget = Text(tool.label!);

    switch (placement) {
      case AxToolLabelPlacement.end:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [iconWidget, SizedBox(width: gap), labelWidget],
        );
      case AxToolLabelPlacement.start:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [labelWidget, SizedBox(width: gap), iconWidget],
        );
      case AxToolLabelPlacement.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [iconWidget, SizedBox(height: gap), labelWidget],
        );
      case AxToolLabelPlacement.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [labelWidget, SizedBox(height: gap), iconWidget],
        );
      case AxToolLabelPlacement.none:
        return iconWidget;
    }
  }
}
