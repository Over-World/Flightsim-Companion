import 'package:flutter/foundation.dart';

import 'stroke.dart';

enum DrawTool { pen, highlighter, eraser }

/// Strokes of the open page plus tool state and undo/redo.
class DrawingController extends ChangeNotifier {
  DrawingController({this.onCommit});

  /// Called after every finished change with the full stroke list.
  final void Function(List<Stroke> strokes)? onCommit;

  static const penSizes = [3.0, 5.0, 9.0];
  static const highlighterSize = 26.0;
  static const eraserRadius = 14.0;

  List<Stroke> _strokes = [];
  final List<List<Stroke>> _undo = [];
  final List<List<Stroke>> _redo = [];
  Stroke? _current;
  bool _erasing = false;
  bool _erasedInGesture = false;

  DrawTool tool = DrawTool.pen;
  int penColor = 0;
  int highlighterColor = 0;
  double penSize = penSizes[1];

  List<Stroke> get strokes => _strokes;
  Stroke? get current => _current;
  bool get canUndo => _undo.isNotEmpty;
  bool get canRedo => _redo.isNotEmpty;
  bool get isEmpty => _strokes.isEmpty;

  void load(List<Stroke> strokes) {
    _strokes = List.of(strokes);
    _undo.clear();
    _redo.clear();
    _current = null;
    notifyListeners();
  }

  void setTool(DrawTool t) {
    tool = t;
    notifyListeners();
  }

  void setColor(int index) {
    if (tool == DrawTool.highlighter) {
      highlighterColor = index;
    } else {
      penColor = index;
      if (tool == DrawTool.eraser) tool = DrawTool.pen;
    }
    notifyListeners();
  }

  void setPenSize(double size) {
    penSize = size;
    if (tool == DrawTool.eraser) tool = DrawTool.pen;
    notifyListeners();
  }

  void _snapshot() {
    _undo.add(List.of(_strokes));
    if (_undo.length > 100) _undo.removeAt(0);
    _redo.clear();
  }

  /// Starts a gesture at ([x], [y]) in page units. [eraser] forces erasing
  /// (inverted stylus or stylus button).
  void begin(
    double x,
    double y,
    double pressure, {
    bool eraser = false,
    bool simulatePressure = false,
  }) {
    _erasing = eraser || tool == DrawTool.eraser;
    _erasedInGesture = false;
    if (_erasing) {
      _eraseAt(x, y);
      return;
    }
    final highlighter = tool == DrawTool.highlighter;
    _current = Stroke(
      tool: highlighter ? StrokeTool.highlighter : StrokeTool.pen,
      color: highlighter ? highlighterColor : penColor,
      size: highlighter ? highlighterSize : penSize,
      simulatePressure: simulatePressure,
      points: [x, y, pressure],
    );
    notifyListeners();
  }

  void extend(double x, double y, double pressure) {
    if (_erasing) {
      _eraseAt(x, y);
      return;
    }
    final c = _current;
    if (c == null) return;
    c.addPoint(x, y, pressure);
    notifyListeners();
  }

  void end() {
    if (_erasing) {
      _erasing = false;
      if (_erasedInGesture) onCommit?.call(_strokes);
      return;
    }
    final c = _current;
    if (c == null) return;
    _current = null;
    _snapshot();
    _strokes = [..._strokes, c];
    notifyListeners();
    onCommit?.call(_strokes);
  }

  void cancel() {
    _current = null;
    _erasing = false;
    notifyListeners();
  }

  void _eraseAt(double x, double y) {
    final remaining = [
      for (final s in _strokes)
        if (!s.hits(x, y, eraserRadius)) s,
    ];
    if (remaining.length == _strokes.length) return;
    if (!_erasedInGesture) _snapshot();
    _erasedInGesture = true;
    _strokes = remaining;
    notifyListeners();
  }

  void undo() {
    if (_undo.isEmpty) return;
    _redo.add(_strokes);
    _strokes = _undo.removeLast();
    notifyListeners();
    onCommit?.call(_strokes);
  }

  void redo() {
    if (_redo.isEmpty) return;
    _undo.add(_strokes);
    _strokes = _redo.removeLast();
    notifyListeners();
    onCommit?.call(_strokes);
  }

  void clear() {
    if (_strokes.isEmpty) return;
    _snapshot();
    _strokes = [];
    notifyListeners();
    onCommit?.call(_strokes);
  }
}
