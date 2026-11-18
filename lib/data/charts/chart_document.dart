import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:pdfrx/pdfrx.dart';

import '../db/tables.dart';
import 'chart_naming.dart';

/// An opened chart file: pages with their size and a renderer.
abstract class ChartDocument {
  int get pageCount;

  /// Page size in the document's own units; only the ratio matters.
  ui.Size pageSize(int page);

  /// Renders [page] with its longer side at most [maxPixels]. The caller
  /// owns (and disposes) the returned image.
  Future<ui.Image> render(int page, int maxPixels);

  Future<void> dispose();
}

/// A file chosen for import.
class PickedChartFile {
  const PickedChartFile(this.name, this.read);

  final String name;
  final Stream<List<int>> Function() read;
}

/// Picks and opens chart files; widget tests substitute one that needs
/// neither the platform picker nor PDFium.
class ChartFileAccess {
  const ChartFileAccess();

  /// Lets the user choose PDFs and images; empty when cancelled.
  Future<List<PickedChartFile>> pick() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: chartFileExtensions,
    );
    return [
      for (final f in files)
        if (chartFileType(f.name) != null)
          PickedChartFile(f.name, () => f.xFile.openRead()),
    ];
  }

  Future<ChartDocument> open(File file, ChartFileType type) => switch (type) {
    ChartFileType.pdf => _PdfChartDocument.open(file),
    ChartFileType.image => _ImageChartDocument.open(file),
  };
}

class _PdfChartDocument implements ChartDocument {
  _PdfChartDocument(this._doc);

  final PdfDocument _doc;

  static Future<ChartDocument> open(File file) async {
    await pdfrxFlutterInitialize();
    return _PdfChartDocument(await PdfDocument.openFile(file.path));
  }

  @override
  int get pageCount => _doc.pages.length;

  @override
  ui.Size pageSize(int page) {
    final p = _doc.pages[page];
    return ui.Size(p.width, p.height);
  }

  @override
  Future<ui.Image> render(int page, int maxPixels) async {
    final p = _doc.pages[page];
    final scale = maxPixels / math.max(p.width, p.height);
    final w = (p.width * scale).round();
    final h = (p.height * scale).round();
    final pdfImage = await p.render(
      width: w,
      height: h,
      fullWidth: w.toDouble(),
      fullHeight: h.toDouble(),
      backgroundColor: 0xFFFFFFFF,
    );
    if (pdfImage == null) throw StateError('Page $page could not be rendered');
    try {
      return await pdfImage.createImage();
    } finally {
      pdfImage.dispose();
    }
  }

  @override
  Future<void> dispose() => _doc.dispose();
}

class _ImageChartDocument implements ChartDocument {
  _ImageChartDocument(this._image);

  final ui.Image _image;

  static Future<ChartDocument> open(File file) async {
    final codec = await ui.instantiateImageCodec(await file.readAsBytes());
    final frame = await codec.getNextFrame();
    codec.dispose();
    return _ImageChartDocument(frame.image);
  }

  @override
  int get pageCount => 1;

  @override
  ui.Size pageSize(int page) =>
      ui.Size(_image.width.toDouble(), _image.height.toDouble());

  @override
  Future<ui.Image> render(int page, int maxPixels) async => _image.clone();

  @override
  Future<void> dispose() async => _image.dispose();
}
