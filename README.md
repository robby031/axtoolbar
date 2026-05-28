# axtoolbar

Modern, flexible & lightweight **selectable toolbar** widgets for Flutter — built for **web, iOS, and Android**.

> A toolbar in `axtoolbar` is a strip of *tools* (icons, labels, or any custom widget) where one is active at a time — think Figma / Photoshop tool palette, an iOS segmented control, or a tab switcher.

- **Selection-based**: pass `selectedId` and react via `onSelected` (controlled widget).
- **Horizontal & vertical** layouts.
- **Floating & draggable** variant (`AxFloatingToolbar`) for overlay/canvas UIs.
- **Indicator styles** out of the box: `background`, `underline`, `pill`, `none`.
- **Theme-able** via `ThemeExtension` (`AxToolbarTheme`) — set defaults once for your app, override per-instance.
- **Flexible items**: icon, label, badge, tooltip, or fully custom `child` (image, color swatch, avatar…).
- **Zero extra dependencies** — pure Flutter / Material.

## Install

```yaml
dependencies:
  axtoolbar:
    path: ../axtoolbar 
```

## Quick start

```dart
import 'package:axtoolbar/axtoolbar.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  @override State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String _tool = 'pen';

  @override
  Widget build(BuildContext context) {
    return AxToolbar(
      selectedId: _tool,
      onSelected: (id) => setState(() => _tool = id),
      tools: const [
        AxTool(id: 'pen',   icon: Icon(Icons.edit),            label: 'Pen'),
        AxTool(id: 'shape', icon: Icon(Icons.square_outlined), label: 'Shape'),
        AxTool(id: 'text',  icon: Icon(Icons.text_fields),     label: 'Text'),
        AxTool(id: 'zoom',  icon: Icon(Icons.zoom_in),         label: 'Zoom'),
      ],
    );
  }
}
```

## Indicator styles

```dart
// Default: filled rounded background.
AxToolbar(style: AxToolbarStyle(indicator: AxToolbarIndicator.background), …);

// Underline (great for tabs).
AxToolbar(style: AxToolbarStyle(
  backgroundColor: Colors.transparent,
  indicator: AxToolbarIndicator.underline,
  itemBorderRadius: BorderRadius.zero,
), …);

// Pill.
AxToolbar(style: AxToolbarStyle(indicator: AxToolbarIndicator.pill), …);
```

## Vertical toolbar

```dart
AxToolbar(
  axis: Axis.vertical,
  tools: tools,
  selectedId: _tool,
  onSelected: (id) => setState(() => _tool = id),
);
```

## Floating / draggable

`AxFloatingToolbar` wraps any toolbar and places it inside a `Stack` as a draggable overlay (clamped to its parent):

```dart
Stack(
  children: [
    MyCanvas(),
    AxFloatingToolbar(
      anchor: AxFloatingAnchor.topCenter,
      initialOffset: const Offset(0, 16),
      child: AxToolbar(
        axis: Axis.vertical,
        tools: sideTools,
        selectedId: _sideTool,
        onSelected: (id) => setState(() => _sideTool = id),
      ),
    ),
  ],
);
```

## Custom tool content

A tool isn’t limited to icon + label — pass any widget via `AxTool.child` (color swatch, avatar, thumbnail…):

```dart
AxTool(
  id: 'violet',
  tooltip: 'Violet',
  child: Container(
    width: 22, height: 22,
    decoration: const BoxDecoration(
      color: Color(0xFF8B5CF6),
      shape: BoxShape.circle,
    ),
  ),
);
```

## Theming

Register defaults once on your `ThemeData`:

```dart
MaterialApp(
  theme: ThemeData.light().copyWith(
    extensions: const [
      AxToolbarTheme(
        style: AxToolbarStyle(
          indicator: AxToolbarIndicator.pill,
          itemSpacing: 6,
          elevation: 2,
        ),
      ),
    ],
  ),
);
```

Per-widget overrides merge on top of the theme:

```dart
AxToolbar(
  style: const AxToolbarStyle(
    backgroundColor: Color(0xFF111827),
    selectedBackgroundColor: Color(0xFF8B5CF6),
    foregroundColor: Colors.white70,
  ),
  …,
);
```

## Demo

```bash
cd example
flutter run -d chrome   # or any device
```

The demo showcases: edit-tool toolbar (background), tabs (underline), color picker (pill, custom child), and a draggable vertical floating toolbar.

## Roadmap (post v0.1)

- Scrollable / overflow handling for many tools
- Multi-select mode
- Animated indicator that slides between tools
- Drag-to-reorder tools
