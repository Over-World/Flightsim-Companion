import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

import '../notes/drawing_canvas.dart';
import '../notes/drawing_controller.dart';
import '../notes/stroke.dart';

const _stylusKinds = {
  PointerDeviceKind.stylus,
  PointerDeviceKind.invertedStylus,
};

/// Ink on top of a chart page inside an [InteractiveViewer].
///
/// Only a stylus draws (its inverted end or button erases). The stylus wins
/// the gesture arena at once, so it never pans the chart; fingers fall
/// through to the viewer and pan/zoom. Coordinates are page units, 1000
/// wide.
class ChartInkLayer extends StatefulWidget {
  const ChartInkLayer({
    super.key,
    required this.controller,
    required this.pageHeight,
    required this.palette,
    required this.zoom,
  });

  final DrawingController controller;

  /// Page height in page units (page width is [pageWidth]).
  final double pageHeight;
  final InkPalette palette;

  /// Current zoom of the viewer; lines stay the same width on screen.
  final double Function() zoom;

  @override
  State<ChartInkLayer> createState() => _ChartInkLayerState();
}

class _ChartInkLayerState extends State<ChartInkLayer> {
  int? _pointer;
  double _scale = 1;

  double _pressure(PointerEvent e) {
    final range = e.pressureMax - e.pressureMin;
    if (range <= 0) return 0.5;
    return ((e.pressure - e.pressureMin) / range).clamp(0.05, 1.0);
  }

  (double, double) _pos(PointerEvent e) => (
    (e.localPosition.dx / _scale).clamp(0, pageWidth),
    (e.localPosition.dy / _scale).clamp(0, widget.pageHeight),
  );

  void _down(PointerDownEvent e) {
    if (_pointer != null || !_stylusKinds.contains(e.kind)) return;
    _pointer = e.pointer;
    final (x, y) = _pos(e);
    widget.controller.begin(
      x,
      y,
      _pressure(e),
      eraser:
          e.kind == PointerDeviceKind.invertedStylus ||
          e.buttons & kSecondaryStylusButton != 0,
      sizeFactor: 1 / widget.zoom().clamp(1, 10),
    );
  }

  void _move(PointerMoveEvent e) {
    if (e.pointer != _pointer) return;
    final (x, y) = _pos(e);
    widget.controller.extend(x, y, _pressure(e));
  }

  void _up(PointerEvent e) {
    if (e.pointer != _pointer) return;
    _pointer = null;
    if (e is PointerCancelEvent) {
      widget.controller.cancel();
    } else {
      widget.controller.end();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _scale = constraints.maxWidth / pageWidth;
        return RawGestureDetector(
          gestures: {
            EagerGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<EagerGestureRecognizer>(
                  () => EagerGestureRecognizer(supportedDevices: _stylusKinds),
                  (_) {},
                ),
          },
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: _down,
            onPointerMove: _move,
            onPointerUp: _up,
            onPointerCancel: _up,
            child: CustomPaint(
              foregroundPainter: StrokesPainter(
                widget.controller,
                widget.palette,
                _scale,
              ),
              size: Size.infinite,
            ),
          ),
        );
      },
    );
  }
}
