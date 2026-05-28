/// axtoolbar — modern, flexible & lightweight selectable toolbar widgets
/// for Flutter (web, iOS, Android).
///
/// Quick start:
///
/// ```dart
/// import 'package:axtoolbar/axtoolbar.dart';
///
/// AxToolbar(
///   selectedId: _tool,
///   onSelected: (id) => setState(() => _tool = id),
///   tools: const [
///     AxTool(id: 'pen',   icon: Icon(Icons.edit),  label: 'Pen'),
///     AxTool(id: 'shape', icon: Icon(Icons.square_outlined), label: 'Shape'),
///     AxTool(id: 'text',  icon: Icon(Icons.text_fields), label: 'Text'),
///   ],
/// );
/// ```
library;

export 'src/models/ax_tool.dart';
export 'src/theme/ax_toolbar_style.dart';
export 'src/theme/ax_toolbar_theme.dart';
export 'src/widgets/ax_toolbar.dart';
export 'src/widgets/ax_floating_toolbar.dart';
