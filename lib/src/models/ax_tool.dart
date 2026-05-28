import 'package:flutter/widgets.dart';

/// Describes a single item inside an [AxToolbar].
///
/// A tool is identified by its [id]. The toolbar tracks which `id` is the
/// currently selected tool and emits a callback when the user picks another.
///
/// Visual content is flexible: provide [icon] and/or [label] for the default
/// look, or pass a fully custom [child] (image, video thumbnail, gauge,
/// avatar — anything).
@immutable
class AxTool {
  const AxTool({
    required this.id,
    this.label,
    this.icon,
    this.child,
    this.tooltip,
    this.badge,
    this.enabled = true,
    this.onTap,
  });

  /// Stable identifier — used for selection and as the widget key.
  final String id;

  /// Optional text shown next to / below the icon.
  final String? label;

  /// Optional leading icon. Use any widget (Icon, Image, custom).
  final Widget? icon;

  /// When provided, fully replaces the default `[icon] + [label]` layout.
  /// Use this for media-rich tools (avatars, thumbnails, color swatches…).
  final Widget? child;

  final String? tooltip;

  /// Small badge widget shown at the top-right corner of the tool.
  final Widget? badge;

  final bool enabled;

  /// Fires in addition to selection when this tool is tapped. Useful for
  /// tools that also trigger an action (e.g. open a popover) the moment they
  /// become active.
  final VoidCallback? onTap;
}
