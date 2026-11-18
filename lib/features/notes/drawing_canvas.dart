import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/db/database.dart';
import 'drawing_controller.dart';
import 'stroke.dart';

/// Ink and highlighter colours for light and dark paper.
class InkPalette {
  const InkPalette._(this.paper, this.rule, this.label, this.ink);

  final Color paper;
  final Color rule;
  final Color label;
  final List<Color> ink;

  static const highlighters = [
    Color(0x66FFEB3B),
    Color(0x5576FF03),
    Color(0x55FF4081),
    Color(0x5518FFFF),
  ];

  static const light = InkPalette._(
    Color(0xFFFCFBF5),
    Color(0xFFC9D3DE),
    Color(0xFF6B7785),
    [
      Color(0xFF15171A),
      Color(0xFF1E5BD8),
      Color(0xFFD32F2F),
      Color(0xFF2E7D32),
    ],
  );

  static const dark = InkPalette._(
    Color(0xFF1E1F22),
    Color(0xFF3A3F47),
    Color(0xFF8E98A4),
    [
      Color(0xFFEDEDED),
      Color(0xFF8AB4FF),
      Color(0xFFFF8A80),
      Color(0xFF81C784),
    ],
  );

  static InkPalette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}

/// Template labels drawn onto ATIS / CRAFT pages.
class PageTemplateLabels {
  const PageTemplateLabels({required this.atis, required this.craft});

  final List<String> atis;
  final List<String> craft;
}

/// A sheet of paper with background, strokes and pointer handling.
///
/// A stylus always draws (its inverted end or button erases). A finger
/// draws only when [fingerDraws] is set, and only one pointer at a time is
/// tracked so a resting palm can't scribble.
class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({
    super.key,
    required this.controller,
    required this.background,
    required this.labels,
    required this.fingerDraws,
  });

  final DrawingController controller;
  final PageBackground background;
  final PageTemplateLabels labels;
  final bool fingerDraws;

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  int? _pointer;
  PointerDeviceKind? _pointerKind;
  double _scale = 1;

  bool _accepts(PointerDownEvent e) => switch (e.kind) {
    PointerDeviceKind.stylus ||
    PointerDeviceKind.invertedStylus ||
    PointerDeviceKind.mouse => true,
    PointerDeviceKind.touch => widget.fingerDraws,
    _ => false,
  };

  double _pressure(PointerEvent e) {
    if (e.kind == PointerDeviceKind.touch ||
        e.kind == PointerDeviceKind.mouse) {
      return 0.5;
    }
    final range = e.pressureMax - e.pressureMin;
    if (range <= 0) return 0.5;
    return ((e.pressure - e.pressureMin) / range).clamp(0.05, 1.0);
  }

  void _down(PointerDownEvent e) {
    // A stylus takes over from a finger (palm) that touched first.
    final stylus =
        e.kind == PointerDeviceKind.stylus ||
        e.kind == PointerDeviceKind.invertedStylus;
    if (_pointer != null) {
      if (!stylus || _pointerKind == PointerDeviceKind.stylus) return;
      widget.controller.cancel();
    }
    if (!_accepts(e)) return;
    _pointer = e.pointer;
    _pointerKind = e.kind;
    final eraser =
        e.kind == PointerDeviceKind.invertedStylus ||
        e.buttons & kSecondaryStylusButton != 0 ||
        e.buttons & kSecondaryMouseButton != 0;
    widget.controller.begin(
      e.localPosition.dx / _scale,
      e.localPosition.dy / _scale,
      _pressure(e),
      eraser: eraser,
      simulatePressure: e.kind == PointerDeviceKind.touch,
    );
  }

  void _move(PointerMoveEvent e) {
    if (e.pointer != _pointer) return;
    widget.controller.extend(
      (e.localPosition.dx / _scale).clamp(0, pageWidth),
      (e.localPosition.dy / _scale).clamp(0, pageHeight),
      _pressure(e),
    );
  }

  void _up(PointerEvent e) {
    if (e.pointer != _pointer) return;
    _pointer = null;
    _pointerKind = null;
    if (e is PointerCancelEvent) {
      widget.controller.cancel();
    } else {
      widget.controller.end();
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = InkPalette.of(context);
    return Center(
      child: AspectRatio(
        aspectRatio: pageWidth / pageHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            _scale = constraints.maxWidth / pageWidth;
            return Material(
              elevation: 2,
              color: palette.paper,
              borderRadius: BorderRadius.circular(4),
              clipBehavior: Clip.antiAlias,
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: _down,
                onPointerMove: _move,
                onPointerUp: _up,
                onPointerCancel: _up,
                child: CustomPaint(
                  painter: _BackgroundPainter(
                    widget.background,
                    palette,
                    widget.labels,
                    _scale,
                    Theme.of(context).textTheme.labelLarge!,
                  ),
                  foregroundPainter: StrokesPainter(
                    widget.controller,
                    palette,
                    _scale,
                  ),
                  size: Size.infinite,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Paints the strokes of a [DrawingController], highlighters under ink.
class StrokesPainter extends CustomPainter {
  StrokesPainter(this.controller, this.palette, this.scale)
    : super(repaint: controller);

  final DrawingController controller;
  final InkPalette palette;
  final double scale;

  Color _color(Stroke s) => s.tool == StrokeTool.highlighter
      ? InkPalette.highlighters[s.color % InkPalette.highlighters.length]
      : palette.ink[s.color % palette.ink.length];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;
    // Highlighters underneath ink, like a marker on paper.
    for (final tool in StrokeTool.values.reversed) {
      for (final s in controller.strokes) {
        if (s.tool != tool) continue;
        canvas.drawPath(s.path(scale), paint..color = _color(s));
      }
    }
    final c = controller.current;
    if (c != null) {
      canvas.drawPath(c.path(scale, complete: false), paint..color = _color(c));
    }
  }

  @override
  bool shouldRepaint(StrokesPainter old) =>
      old.scale != scale || old.palette != palette;
}

class _BackgroundPainter extends CustomPainter {
  _BackgroundPainter(
    this.background,
    this.palette,
    this.labels,
    this.scale,
    this.labelStyle,
  );

  final PageBackground background;
  final InkPalette palette;
  final PageTemplateLabels labels;
  final double scale;
  final TextStyle labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final rule = Paint()
      ..color = palette.rule
      ..strokeWidth = 1;
    switch (background) {
      case PageBackground.blank:
        break;
      case PageBackground.grid:
        for (var x = 40.0; x < pageWidth; x += 40) {
          canvas.drawLine(
            Offset(x * scale, 0),
            Offset(x * scale, size.height),
            rule,
          );
        }
        for (var y = 40.0; y < pageHeight; y += 40) {
          canvas.drawLine(
            Offset(0, y * scale),
            Offset(size.width, y * scale),
            rule,
          );
        }
      case PageBackground.lined:
        for (var y = 90.0; y < pageHeight; y += 60) {
          canvas.drawLine(
            Offset(40 * scale, y * scale),
            Offset(size.width - 40 * scale, y * scale),
            rule,
          );
        }
      case PageBackground.atis:
        _rows(canvas, size, labels.atis, rowHeight: 118, top: 60, rule: rule);
      case PageBackground.craft:
        _rows(
          canvas,
          size,
          labels.craft,
          rowHeight: 230,
          top: 80,
          rule: rule,
          bigInitial: true,
        );
    }
  }

  void _rows(
    Canvas canvas,
    Size size,
    List<String> rows, {
    required double rowHeight,
    required double top,
    required Paint rule,
    bool bigInitial = false,
  }) {
    for (var i = 0; i < rows.length; i++) {
      final y = (top + i * rowHeight) * scale;
      final bottom = y + rowHeight * scale;
      canvas.drawLine(
        Offset(32 * scale, bottom),
        Offset(size.width - 32 * scale, bottom),
        rule..strokeWidth = 1.5,
      );
      var label = rows[i];
      var x = 40 * scale;
      if (bigInitial && label.isNotEmpty) {
        _text(
          canvas,
          label[0],
          Offset(x, y + 12 * scale),
          labelStyle.copyWith(
            fontSize: 72 * scale,
            fontWeight: FontWeight.w300,
            color: palette.rule,
          ),
        );
        label = label.substring(1).trim();
        x += 90 * scale;
      }
      _text(
        canvas,
        label,
        Offset(x, y + 14 * scale),
        labelStyle.copyWith(fontSize: 22 * scale, color: palette.label),
      );
    }
  }

  void _text(Canvas canvas, String text, Offset at, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, at);
  }

  @override
  bool shouldRepaint(_BackgroundPainter old) =>
      old.background != background ||
      old.palette != palette ||
      old.scale != scale ||
      old.labels != labels;
}
