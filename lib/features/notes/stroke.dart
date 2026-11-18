import 'dart:convert';
import 'dart:ui';

import 'package:perfect_freehand/perfect_freehand.dart';

/// Pages use a virtual coordinate system: 1000 units wide, A-series ratio.
const double pageWidth = 1000;
const double pageHeight = 1414;

enum StrokeTool { pen, highlighter }

/// One freehand stroke. Colors are palette indices so ink adapts to light
/// and dark pages.
class Stroke {
  Stroke({
    required this.tool,
    required this.color,
    required this.size,
    required this.points,
    this.simulatePressure = false,
  });

  final StrokeTool tool;
  final int color;
  final double size;

  /// Flat list of x, y, pressure triples in page units.
  final List<double> points;

  /// Touch input has no real pressure; let the stroke fake it.
  final bool simulatePressure;

  Path? _path;
  double? _pathScale;

  int get pointCount => points.length ~/ 3;

  void addPoint(double x, double y, double pressure) {
    points.addAll([x, y, pressure]);
    _path = null;
  }

  /// Whether any point is within [radius] page units of ([x], [y]).
  bool hits(double x, double y, double radius) {
    final r2 = (radius + size / 2) * (radius + size / 2);
    for (var i = 0; i < points.length; i += 3) {
      final dx = points[i] - x;
      final dy = points[i + 1] - y;
      if (dx * dx + dy * dy <= r2) return true;
    }
    return false;
  }

  /// Outline path scaled to the canvas, cached per scale.
  Path path(double scale, {bool complete = true}) {
    if (_path != null && _pathScale == scale) return _path!;
    final input = [
      for (var i = 0; i < points.length; i += 3)
        PointVector(points[i] * scale, points[i + 1] * scale, points[i + 2]),
    ];
    final highlighter = tool == StrokeTool.highlighter;
    final outline = getStroke(
      input,
      options: StrokeOptions(
        size: size * scale,
        thinning: highlighter ? 0 : 0.6,
        smoothing: 0.5,
        streamline: 0.5,
        simulatePressure: simulatePressure && !highlighter,
        isComplete: complete,
      ),
    );
    final path = Path();
    if (outline.isEmpty) return path;
    if (outline.length < 2) {
      path.addOval(
        Rect.fromCircle(center: outline.first, radius: size * scale / 2),
      );
    } else {
      path.moveTo(outline.first.dx, outline.first.dy);
      for (var i = 1; i < outline.length - 1; i++) {
        final p0 = outline[i];
        final p1 = outline[i + 1];
        path.quadraticBezierTo(
          p0.dx,
          p0.dy,
          (p0.dx + p1.dx) / 2,
          (p0.dy + p1.dy) / 2,
        );
      }
      path.close();
    }
    if (complete) {
      _path = path;
      _pathScale = scale;
    }
    return path;
  }

  Map<String, Object> toJson() => {
    't': tool.index,
    'c': color,
    's': size,
    if (simulatePressure) 'sp': 1,
    // One decimal is plenty at 1000 units per page width.
    'p': [for (final v in points) (v * 10).round() / 10],
  };

  factory Stroke.fromJson(Map<String, dynamic> json) => Stroke(
    tool: StrokeTool.values[json['t'] as int],
    color: json['c'] as int,
    size: (json['s'] as num).toDouble(),
    simulatePressure: json['sp'] == 1,
    points: [for (final v in json['p'] as List) (v as num).toDouble()],
  );

  static String encodeAll(List<Stroke> strokes) =>
      jsonEncode([for (final s in strokes) s.toJson()]);

  static List<Stroke> decodeAll(String source) {
    final list = jsonDecode(source);
    if (list is! List) return [];
    return [for (final s in list) Stroke.fromJson(s as Map<String, dynamic>)];
  }
}
