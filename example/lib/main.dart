import 'package:axtoolbar/axtoolbar.dart';
import 'package:flutter/material.dart';

void main() => runApp(const AxToolbarDemoApp());

class AxToolbarDemoApp extends StatelessWidget {
  const AxToolbarDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'axtoolbar demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const _Showcase(),
    );
  }
}

class _Showcase extends StatefulWidget {
  const _Showcase();

  @override
  State<_Showcase> createState() => _ShowcaseState();
}

class _ShowcaseState extends State<_Showcase> {
  String _tool = 'pen';
  String _view = 'design';
  String _color = 'violet';
  String _sideTool = 'move';

  static const _editTools = [
    AxTool(id: 'pen', icon: Icon(Icons.edit), label: 'Pen', tooltip: 'Pen (P)'),
    AxTool(
      id: 'shape',
      icon: Icon(Icons.square_outlined),
      label: 'Shape',
      tooltip: 'Shape (S)',
    ),
    AxTool(
      id: 'text',
      icon: Icon(Icons.text_fields),
      label: 'Text',
      tooltip: 'Text (T)',
    ),
    AxTool(
      id: 'zoom',
      icon: Icon(Icons.zoom_in),
      label: 'Zoom',
      tooltip: 'Zoom (Z)',
    ),
  ];

  static const _viewTools = [
    AxTool(id: 'design', label: 'Design'),
    AxTool(id: 'prototype', label: 'Prototype'),
    AxTool(id: 'inspect', label: 'Inspect'),
  ];

  static const _sideTools = [
    AxTool(id: 'move', icon: Icon(Icons.open_with), tooltip: 'Move'),
    AxTool(id: 'select', icon: Icon(Icons.crop_square), tooltip: 'Select'),
    AxTool(id: 'frame', icon: Icon(Icons.crop_din), tooltip: 'Frame'),
    AxTool(id: 'comment', icon: Icon(Icons.chat_bubble_outline), tooltip: 'Comment'),
  ];

  static const _colorPalette = {
    'violet': Color(0xFF8B5CF6),
    'pink': Color(0xFFEC4899),
    'amber': Color(0xFFF59E0B),
    'emerald': Color(0xFF10B981),
    'sky': Color(0xFF0EA5E9),
  };

  @override
  Widget build(BuildContext context) {
    final colorTools = _colorPalette.entries
        .map(
          (e) => AxTool(
            id: e.key,
            tooltip: e.key,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: e.value,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.6),
                  width: 2,
                ),
              ),
            ),
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('axtoolbar demo')),
      body: Stack(
        children: [
          // The "canvas" area.
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFEEF2FF), Color(0xFFFFF1F2)],
                ),
              ),
              child: Center(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Active state',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        _kv('Edit tool', _tool),
                        _kv('View', _view),
                        _kv('Color', _color),
                        _kv('Side tool', _sideTool),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── 1. Inline horizontal toolbar (default: background indicator).
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Center(
              child: AxToolbar(
                tools: _editTools,
                selectedId: _tool,
                onSelected: (id) => setState(() => _tool = id),
              ),
            ),
          ),

          // ── 2. Underline indicator, label-only tabs (view switcher).
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: AxToolbar(
                tools: _viewTools,
                selectedId: _view,
                onSelected: (id) => setState(() => _view = id),
                style: const AxToolbarStyle(
                  backgroundColor: Colors.transparent,
                  indicator: AxToolbarIndicator.underline,
                  itemPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  itemBorderRadius: BorderRadius.zero,
                  shape: RoundedRectangleBorder(),
                ),
              ),
            ),
          ),

          // ── 3. Color picker (custom child = swatch), pill indicator.
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: AxToolbar(
                tools: colorTools,
                selectedId: _color,
                onSelected: (id) => setState(() => _color = id),
                style: AxToolbarStyle(
                  backgroundColor: Colors.black.withValues(alpha: 0.85),
                  indicator: AxToolbarIndicator.pill,
                  selectedBackgroundColor: Colors.white.withValues(alpha: 0.18),
                  itemPadding: const EdgeInsets.all(6),
                  itemSpacing: 4,
                  padding: const EdgeInsets.all(6),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(999)),
                  ),
                  elevation: 8,
                ),
              ),
            ),
          ),

          // ── 4. Vertical floating toolbar, draggable.
          AxFloatingToolbar(
            anchor: AxFloatingAnchor.topLeft,
            initialOffset: const Offset(16, 140),
            child: AxToolbar(
              axis: Axis.vertical,
              tools: _sideTools,
              selectedId: _sideTool,
              onSelected: (id) => setState(() => _sideTool = id),
              style: const AxToolbarStyle(
                indicator: AxToolbarIndicator.background,
                itemPadding: EdgeInsets.all(10),
                elevation: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            SizedBox(
              width: 88,
              child: Text(
                k,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      );
}
