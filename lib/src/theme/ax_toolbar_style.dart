import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// How the active tool is visually emphasized.
enum AxToolbarIndicator {
  /// Filled rounded background behind the selected tool. *(default)*
  background,

  /// Bottom (or trailing, when vertical) line under the selected tool.
  underline,

  /// Pill-shaped background with high border radius.
  pill,

  /// No visual indicator (rely on color change only).
  none,
}

/// Where the label sits relative to the icon inside one tool item.
enum AxToolLabelPlacement { end, bottom, start, top, none }

/// Immutable visual configuration for an [AxToolbar].
///
/// Combine with [AxToolbarTheme] for app-wide defaults; pass on a single
/// [AxToolbar] to override per instance. Use [copyWith] / [merge] for
/// composition and [lerp] for animation.
@immutable
class AxToolbarStyle {
  const AxToolbarStyle({
    // Container
    this.backgroundColor,
    this.gradient,
    this.foregroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.border,
    this.padding,
    this.blurSigma,
    this.opacity,
    // Items
    this.itemPadding,
    this.itemSpacing,
    this.itemBorderRadius,
    this.itemMinSize,
    this.labelStyle,
    this.iconTheme,
    this.labelPlacement,
    this.iconLabelGap,
    // Selection
    this.indicator,
    this.indicatorColor,
    this.indicatorThickness,
    this.selectedBackgroundColor,
    this.selectedForegroundColor,
    this.selectedLabelStyle,
    this.hoverColor,
  });

  // ───── container ─────
  final Color? backgroundColor;
  final Gradient? gradient;

  /// Default color applied to icons and labels of *unselected* tools.
  final Color? foregroundColor;

  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final BoxBorder? border;

  /// Padding inside the toolbar (between the outer shape and the items).
  final EdgeInsetsGeometry? padding;

  /// Backdrop blur sigma. `0` (default) disables it.
  final double? blurSigma;

  /// Multiplier applied to [backgroundColor] alpha (or to the whole content
  /// when [blurSigma] > 0).
  final double? opacity;

  // ───── items ─────
  final EdgeInsetsGeometry? itemPadding;
  final double? itemSpacing;
  final BorderRadiusGeometry? itemBorderRadius;

  /// Minimum tap target per tool item (applied to width *and* height).
  final double? itemMinSize;

  final TextStyle? labelStyle;
  final IconThemeData? iconTheme;
  final AxToolLabelPlacement? labelPlacement;
  final double? iconLabelGap;

  // ───── selection ─────
  final AxToolbarIndicator? indicator;
  final Color? indicatorColor;
  final double? indicatorThickness;
  final Color? selectedBackgroundColor;
  final Color? selectedForegroundColor;
  final TextStyle? selectedLabelStyle;
  final Color? hoverColor;

  AxToolbarStyle copyWith({
    Color? backgroundColor,
    Gradient? gradient,
    Color? foregroundColor,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    ShapeBorder? shape,
    BoxBorder? border,
    EdgeInsetsGeometry? padding,
    double? blurSigma,
    double? opacity,
    EdgeInsetsGeometry? itemPadding,
    double? itemSpacing,
    BorderRadiusGeometry? itemBorderRadius,
    double? itemMinSize,
    TextStyle? labelStyle,
    IconThemeData? iconTheme,
    AxToolLabelPlacement? labelPlacement,
    double? iconLabelGap,
    AxToolbarIndicator? indicator,
    Color? indicatorColor,
    double? indicatorThickness,
    Color? selectedBackgroundColor,
    Color? selectedForegroundColor,
    TextStyle? selectedLabelStyle,
    Color? hoverColor,
  }) {
    return AxToolbarStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      gradient: gradient ?? this.gradient,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      shape: shape ?? this.shape,
      border: border ?? this.border,
      padding: padding ?? this.padding,
      blurSigma: blurSigma ?? this.blurSigma,
      opacity: opacity ?? this.opacity,
      itemPadding: itemPadding ?? this.itemPadding,
      itemSpacing: itemSpacing ?? this.itemSpacing,
      itemBorderRadius: itemBorderRadius ?? this.itemBorderRadius,
      itemMinSize: itemMinSize ?? this.itemMinSize,
      labelStyle: labelStyle ?? this.labelStyle,
      iconTheme: iconTheme ?? this.iconTheme,
      labelPlacement: labelPlacement ?? this.labelPlacement,
      iconLabelGap: iconLabelGap ?? this.iconLabelGap,
      indicator: indicator ?? this.indicator,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      indicatorThickness: indicatorThickness ?? this.indicatorThickness,
      selectedBackgroundColor:
          selectedBackgroundColor ?? this.selectedBackgroundColor,
      selectedForegroundColor:
          selectedForegroundColor ?? this.selectedForegroundColor,
      selectedLabelStyle: selectedLabelStyle ?? this.selectedLabelStyle,
      hoverColor: hoverColor ?? this.hoverColor,
    );
  }

  /// Returns a new style where any non-null field of [other] overrides this.
  AxToolbarStyle merge(AxToolbarStyle? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      gradient: other.gradient,
      foregroundColor: other.foregroundColor,
      elevation: other.elevation,
      shadowColor: other.shadowColor,
      surfaceTintColor: other.surfaceTintColor,
      shape: other.shape,
      border: other.border,
      padding: other.padding,
      blurSigma: other.blurSigma,
      opacity: other.opacity,
      itemPadding: other.itemPadding,
      itemSpacing: other.itemSpacing,
      itemBorderRadius: other.itemBorderRadius,
      itemMinSize: other.itemMinSize,
      labelStyle: other.labelStyle,
      iconTheme: other.iconTheme,
      labelPlacement: other.labelPlacement,
      iconLabelGap: other.iconLabelGap,
      indicator: other.indicator,
      indicatorColor: other.indicatorColor,
      indicatorThickness: other.indicatorThickness,
      selectedBackgroundColor: other.selectedBackgroundColor,
      selectedForegroundColor: other.selectedForegroundColor,
      selectedLabelStyle: other.selectedLabelStyle,
      hoverColor: other.hoverColor,
    );
  }

  static AxToolbarStyle lerp(AxToolbarStyle? a, AxToolbarStyle? b, double t) {
    if (identical(a, b) && a != null) return a;
    return AxToolbarStyle(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      gradient: Gradient.lerp(a?.gradient, b?.gradient, t),
      foregroundColor: Color.lerp(a?.foregroundColor, b?.foregroundColor, t),
      elevation: lerpDouble(a?.elevation, b?.elevation, t),
      shadowColor: Color.lerp(a?.shadowColor, b?.shadowColor, t),
      surfaceTintColor:
          Color.lerp(a?.surfaceTintColor, b?.surfaceTintColor, t),
      shape: ShapeBorder.lerp(a?.shape, b?.shape, t),
      border: BoxBorder.lerp(a?.border, b?.border, t),
      padding: EdgeInsetsGeometry.lerp(a?.padding, b?.padding, t),
      blurSigma: lerpDouble(a?.blurSigma, b?.blurSigma, t),
      opacity: lerpDouble(a?.opacity, b?.opacity, t),
      itemPadding: EdgeInsetsGeometry.lerp(a?.itemPadding, b?.itemPadding, t),
      itemSpacing: lerpDouble(a?.itemSpacing, b?.itemSpacing, t),
      itemBorderRadius: BorderRadiusGeometry.lerp(
        a?.itemBorderRadius,
        b?.itemBorderRadius,
        t,
      ),
      itemMinSize: lerpDouble(a?.itemMinSize, b?.itemMinSize, t),
      labelStyle: TextStyle.lerp(a?.labelStyle, b?.labelStyle, t),
      iconTheme: IconThemeData.lerp(a?.iconTheme, b?.iconTheme, t),
      labelPlacement: t < 0.5 ? a?.labelPlacement : b?.labelPlacement,
      iconLabelGap: lerpDouble(a?.iconLabelGap, b?.iconLabelGap, t),
      indicator: t < 0.5 ? a?.indicator : b?.indicator,
      indicatorColor: Color.lerp(a?.indicatorColor, b?.indicatorColor, t),
      indicatorThickness:
          lerpDouble(a?.indicatorThickness, b?.indicatorThickness, t),
      selectedBackgroundColor: Color.lerp(
        a?.selectedBackgroundColor,
        b?.selectedBackgroundColor,
        t,
      ),
      selectedForegroundColor: Color.lerp(
        a?.selectedForegroundColor,
        b?.selectedForegroundColor,
        t,
      ),
      selectedLabelStyle:
          TextStyle.lerp(a?.selectedLabelStyle, b?.selectedLabelStyle, t),
      hoverColor: Color.lerp(a?.hoverColor, b?.hoverColor, t),
    );
  }

  /// Sensible defaults derived from the ambient [Theme].
  static AxToolbarStyle defaults(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return AxToolbarStyle(
      backgroundColor: colors.surfaceContainerHighest,
      foregroundColor: colors.onSurfaceVariant,
      elevation: 0,
      shadowColor: colors.shadow,
      surfaceTintColor: colors.surfaceTint,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      padding: const EdgeInsets.all(4),
      blurSigma: 0,
      opacity: 1,
      itemPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemSpacing: 4,
      itemBorderRadius: const BorderRadius.all(Radius.circular(10)),
      itemMinSize: 36,
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: colors.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
      iconTheme: IconThemeData(color: colors.onSurfaceVariant, size: 20),
      labelPlacement: AxToolLabelPlacement.end,
      iconLabelGap: 6,
      indicator: AxToolbarIndicator.background,
      indicatorColor: colors.primary,
      indicatorThickness: 2,
      selectedBackgroundColor: colors.primary,
      selectedForegroundColor: colors.onPrimary,
      selectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
        color: colors.onPrimary,
        fontWeight: FontWeight.w600,
      ),
      hoverColor: colors.primary.withValues(alpha: 0.08),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AxToolbarStyle &&
          other.backgroundColor == backgroundColor &&
          other.gradient == gradient &&
          other.foregroundColor == foregroundColor &&
          other.elevation == elevation &&
          other.shadowColor == shadowColor &&
          other.surfaceTintColor == surfaceTintColor &&
          other.shape == shape &&
          other.border == border &&
          other.padding == padding &&
          other.blurSigma == blurSigma &&
          other.opacity == opacity &&
          other.itemPadding == itemPadding &&
          other.itemSpacing == itemSpacing &&
          other.itemBorderRadius == itemBorderRadius &&
          other.itemMinSize == itemMinSize &&
          other.labelStyle == labelStyle &&
          other.iconTheme == iconTheme &&
          other.labelPlacement == labelPlacement &&
          other.iconLabelGap == iconLabelGap &&
          other.indicator == indicator &&
          other.indicatorColor == indicatorColor &&
          other.indicatorThickness == indicatorThickness &&
          other.selectedBackgroundColor == selectedBackgroundColor &&
          other.selectedForegroundColor == selectedForegroundColor &&
          other.selectedLabelStyle == selectedLabelStyle &&
          other.hoverColor == hoverColor;

  @override
  int get hashCode => Object.hashAll([
        backgroundColor,
        gradient,
        foregroundColor,
        elevation,
        shadowColor,
        surfaceTintColor,
        shape,
        border,
        padding,
        blurSigma,
        opacity,
        itemPadding,
        itemSpacing,
        itemBorderRadius,
        itemMinSize,
        labelStyle,
        iconTheme,
        labelPlacement,
        iconLabelGap,
        indicator,
        indicatorColor,
        indicatorThickness,
        selectedBackgroundColor,
        selectedForegroundColor,
        selectedLabelStyle,
        hoverColor,
      ]);
}
