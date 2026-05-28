import 'package:flutter/material.dart';

import 'ax_toolbar_style.dart';

/// [ThemeExtension] that holds the app-wide default [AxToolbarStyle].
///
/// Register it on your [ThemeData]:
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData.light().copyWith(
///     extensions: const [
///       AxToolbarTheme(
///         style: AxToolbarStyle(elevation: 2, centerTitle: true),
///       ),
///     ],
///   ),
/// );
/// ```
@immutable
class AxToolbarTheme extends ThemeExtension<AxToolbarTheme> {
  const AxToolbarTheme({this.style = const AxToolbarStyle()});

  final AxToolbarStyle style;

  /// Returns the resolved style by merging defaults, the theme extension,
  /// and an optional [override] (in that order).
  static AxToolbarStyle resolve(BuildContext context, [AxToolbarStyle? override]) {
    final defaults = AxToolbarStyle.defaults(context);
    final ext = Theme.of(context).extension<AxToolbarTheme>()?.style;
    return defaults.merge(ext).merge(override);
  }

  @override
  AxToolbarTheme copyWith({AxToolbarStyle? style}) =>
      AxToolbarTheme(style: style ?? this.style);

  @override
  AxToolbarTheme lerp(ThemeExtension<AxToolbarTheme>? other, double t) {
    if (other is! AxToolbarTheme) return this;
    return AxToolbarTheme(style: AxToolbarStyle.lerp(style, other.style, t));
  }
}
