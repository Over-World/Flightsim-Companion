import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../data/charts/chart_document.dart';
import '../../data/db/database.dart';
import '../../data/repositories/charts_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/empty_state.dart';
import '../notes/drawing_canvas.dart';
import '../notes/drawing_controller.dart';
import '../notes/ink_toolbar.dart';
import '../notes/stroke.dart';
import 'chart_ink_layer.dart';
import 'chart_labels.dart';

/// Inverts brightness but keeps hues, so red stays red on a night chart:
/// each channel becomes `c + 255 - 2·luma`.
const _nightMatrix = <double>[
  1 - 2 * 0.299, -2 * 0.587, -2 * 0.114, 0, 255, //
  -2 * 0.299, 1 - 2 * 0.587, -2 * 0.114, 0, 255, //
  -2 * 0.299, -2 * 0.587, 1 - 2 * 0.114, 0, 255, //
  0, 0, 0, 1, 0, //
];

/// A chart with zoom, night mode and stylus ink. Ink belongs to [flightId]
/// when opened from a flight, otherwise it is the chart's general ink.
class ChartViewerScreen extends StatefulWidget {
  const ChartViewerScreen({super.key, required this.chartId, this.flightId});

  final int chartId;
  final int? flightId;

  @override
  State<ChartViewerScreen> createState() => _ChartViewerScreenState();
}

enum _Failure { notFound, unreadable }

class _ChartViewerScreenState extends State<ChartViewerScreen> {
  late final ChartsRepository _repo = context.read<ChartsRepository>();
  late final DrawingController _drawing = DrawingController(onCommit: _save);
  final _transform = TransformationController();

  Chart? _chart;
  ChartDocument? _doc;
  _Failure? _failure;
  Map<int, String> _ink = {};
  int _page = 0;
  ui.Image? _image;
  bool? _night;
  bool _tools = false;

  @override
  void initState() {
    super.initState();
    _open();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _night ??= Theme.of(context).brightness == Brightness.dark;
  }

  @override
  void dispose() {
    _doc?.dispose();
    _image?.dispose();
    _drawing.dispose();
    _transform.dispose();
    super.dispose();
  }

  Future<void> _open() async {
    final files = context.read<ChartFileAccess>();
    final chart = await _repo.byId(widget.chartId);
    if (chart == null) {
      if (mounted) setState(() => _failure = _Failure.notFound);
      return;
    }
    try {
      final file = await _repo.file(chart);
      final doc = await files.open(file, chart.fileType);
      final ink = await _repo.annotations(chart.id, widget.flightId);
      if (!mounted) {
        await doc.dispose();
        return;
      }
      setState(() {
        _chart = chart;
        _doc = doc;
        _ink = ink;
      });
      await _showPage(0);
    } catch (_) {
      if (mounted) {
        setState(() {
          _chart = chart;
          _failure = _Failure.unreadable;
        });
      }
    }
  }

  Future<void> _showPage(int page) async {
    final doc = _doc;
    if (doc == null) return;
    final media = MediaQuery.of(context);
    final maxPixels = (media.size.longestSide * media.devicePixelRatio * 1.5)
        .clamp(1024, 3000)
        .round();
    setState(() {
      _page = page;
      _image?.dispose();
      _image = null;
      _transform.value = Matrix4.identity();
    });
    _drawing.load(Stroke.decodeAll(_ink[page] ?? '[]'));
    final image = await doc.render(page, maxPixels);
    if (!mounted || _page != page) {
      image.dispose();
      return;
    }
    setState(() => _image = image);
  }

  void _save(List<Stroke> strokes) {
    final chart = _chart;
    if (chart == null) return;
    final encoded = Stroke.encodeAll(strokes);
    _ink[_page] = encoded;
    _repo.saveAnnotations(chart.id, widget.flightId, _page, encoded);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chart = _chart;
    final doc = _doc;
    final night = _night ?? false;
    final palette = night ? InkPalette.dark : InkPalette.light;
    return Scaffold(
      appBar: AppBar(
        title: chart == null
            ? null
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(chart.name, overflow: TextOverflow.ellipsis),
                  Text(
                    '${chart.airportIdent} · '
                    '${chartCategoryLabel(l10n, chart.category)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
        actions: [
          if (doc != null) ...[
            ListenableBuilder(
              listenable: _drawing,
              builder: (context, _) => IconButton(
                tooltip: l10n.actionUndo,
                onPressed: _drawing.canUndo ? _drawing.undo : null,
                icon: const Icon(Icons.undo),
              ),
            ),
            IconButton(
              tooltip: l10n.chartInkTools,
              isSelected: _tools,
              onPressed: () => setState(() => _tools = !_tools),
              icon: const Icon(Icons.draw_outlined),
              selectedIcon: const Icon(Icons.draw),
            ),
            IconButton(
              tooltip: l10n.chartNightMode,
              isSelected: night,
              onPressed: () => setState(() => _night = !night),
              icon: const Icon(Icons.dark_mode_outlined),
              selectedIcon: const Icon(Icons.dark_mode),
            ),
            PopupMenuButton<String>(
              onSelected: (v) => switch (v) {
                'fit' => _transform.value = Matrix4.identity(),
                _ => _drawing.clear(),
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'fit', child: Text(l10n.chartFit)),
                PopupMenuItem(value: 'clear', child: Text(l10n.chartClearInk)),
              ],
            ),
          ],
        ],
      ),
      body: switch ((_failure, doc)) {
        (_Failure.notFound, _) => EmptyState(
          icon: Icons.map_outlined,
          title: l10n.chartNotFound,
        ),
        (_Failure.unreadable, _) => EmptyState(
          icon: Icons.broken_image_outlined,
          title: l10n.chartUnreadable,
        ),
        (_, null) => const Center(child: CircularProgressIndicator()),
        (_, final doc?) => Column(
          children: [
            if (_tools)
              Material(
                color: Theme.of(context).colorScheme.surfaceContainer,
                child: InkToolbar(drawing: _drawing, palette: palette),
              ),
            Expanded(child: _pageView(doc, night, palette)),
            if (doc.pageCount > 1) _pageBar(l10n, doc),
          ],
        ),
      },
    );
  }

  Widget _pageView(ChartDocument doc, bool night, InkPalette palette) {
    final size = doc.pageSize(_page);
    final pageHeight = pageWidth * size.height / size.width;
    final image = _image;
    return ColoredBox(
      color: night ? Colors.black : Theme.of(context).colorScheme.surfaceDim,
      child: InteractiveViewer(
        transformationController: _transform,
        maxScale: 10,
        child: Center(
          child: AspectRatio(
            aspectRatio: size.width / size.height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.matrix(
                    night
                        ? _nightMatrix
                        : const [
                            1, 0, 0, 0, 0, //
                            0, 1, 0, 0, 0, //
                            0, 0, 1, 0, 0, //
                            0, 0, 0, 1, 0, //
                          ],
                  ),
                  child: image == null
                      ? const ColoredBox(
                          color: Colors.white,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : RawImage(
                          image: image,
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.medium,
                        ),
                ),
                ChartInkLayer(
                  controller: _drawing,
                  pageHeight: pageHeight,
                  palette: palette,
                  zoom: () => _transform.value.getMaxScaleOnAxis(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pageBar(AppLocalizations l10n, ChartDocument doc) => Material(
    color: Theme.of(context).colorScheme.surfaceContainer,
    child: SafeArea(
      top: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            tooltip: l10n.chartPreviousPage,
            onPressed: _page > 0 ? () => _showPage(_page - 1) : null,
            icon: const Icon(Icons.chevron_left),
          ),
          Text(l10n.chartPage(_page + 1, doc.pageCount)),
          IconButton(
            tooltip: l10n.chartNextPage,
            onPressed: _page < doc.pageCount - 1
                ? () => _showPage(_page + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    ),
  );
}
