import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/settings.dart';
import '../../data/db/database.dart';
import '../../data/repositories/notes_repository.dart';
import '../../l10n/app_localizations.dart';
import '../kneeboard/kneeboard_controller.dart';
import 'drawing_canvas.dart';
import 'drawing_controller.dart';
import 'stroke.dart';

/// Handwritten notepad, reachable from everywhere. Pages belong to the
/// active flight or to the general notebook.
class NotepadScreen extends StatefulWidget {
  const NotepadScreen({super.key});

  @override
  State<NotepadScreen> createState() => _NotepadScreenState();
}

class _NotepadScreenState extends State<NotepadScreen> {
  late final NotesRepository _notes = context.read<NotesRepository>();
  late final int? _activeFlightId = context
      .read<KneeboardController>()
      .flightId;
  late int? _scope = _activeFlightId;
  late final DrawingController _drawing = DrawingController(
    onCommit: _scheduleSave,
  );

  StreamSubscription<List<ScratchPage>>? _subscription;
  List<ScratchPage> _pages = const [];
  int? _pageId;
  Timer? _saveTimer;
  bool _creatingFirstPage = false;

  @override
  void initState() {
    super.initState();
    _watch();
  }

  void _watch() {
    _subscription?.cancel();
    _subscription = _notes.watchPages(_scope).listen((pages) async {
      if (pages.isEmpty) {
        if (_creatingFirstPage) return;
        _creatingFirstPage = true;
        await _notes.addPage(_scope, PageBackground.blank);
        _creatingFirstPage = false;
        return;
      }
      if (!mounted) return;
      final keep = pages.any((p) => p.id == _pageId);
      setState(() => _pages = pages);
      if (!keep) _select(pages.last);
    });
  }

  void _select(ScratchPage page) {
    _flushSave();
    setState(() => _pageId = page.id);
    _drawing.load(Stroke.decodeAll(page.strokes));
  }

  void _scheduleSave(List<Stroke> strokes) {
    final pageId = _pageId;
    if (pageId == null) return;
    _saveTimer?.cancel();
    final json = Stroke.encodeAll(strokes);
    _saveTimer = Timer(
      const Duration(milliseconds: 400),
      () => _notes.saveStrokes(pageId, json),
    );
    _pendingSave = () => _notes.saveStrokes(pageId, json);
  }

  Future<void> Function()? _pendingSave;

  void _flushSave() {
    if (_saveTimer?.isActive ?? false) {
      _saveTimer!.cancel();
      _pendingSave?.call();
    }
    _pendingSave = null;
  }

  void _switchScope(int? scope) {
    if (scope == _scope) return;
    _flushSave();
    setState(() {
      _scope = scope;
      _pages = const [];
      _pageId = null;
    });
    _drawing.load(const []);
    _watch();
  }

  ScratchPage? get _page => _pages.where((p) => p.id == _pageId).firstOrNull;

  Future<void> _addPage(PageBackground background) async {
    _flushSave();
    final id = await _notes.addPage(_scope, background);
    _pageId = id;
    _drawing.load(const []);
    if (mounted) setState(() {});
  }

  Future<void> _deletePage() async {
    final page = _page;
    if (page == null) return;
    _saveTimer?.cancel();
    _pendingSave = null;
    _pageId = null;
    await _notes.deletePage(page.id);
  }

  @override
  void dispose() {
    _flushSave();
    _subscription?.cancel();
    _drawing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsController>();
    final page = _page;
    final labels = PageTemplateLabels(
      atis: [
        l10n.templateAtisInfo,
        l10n.templateAtisRunway,
        l10n.templateAtisWind,
        l10n.templateAtisVisibility,
        l10n.templateAtisWeather,
        l10n.templateAtisClouds,
        l10n.templateAtisTemperature,
        l10n.templateAtisQnh,
        l10n.templateAtisRemarks,
      ],
      craft: [
        l10n.templateCraftClearance,
        l10n.templateCraftRoute,
        l10n.templateCraftAltitude,
        l10n.templateCraftFrequency,
        l10n.templateCraftTransponder,
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: _activeFlightId == null
            ? Text(l10n.notesGeneral)
            : SegmentedButton<int?>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: _activeFlightId,
                    label: Text(l10n.notesFlight),
                  ),
                  ButtonSegment(value: null, label: Text(l10n.notesGeneral)),
                ],
                selected: {_scope},
                onSelectionChanged: (s) => _switchScope(s.single),
              ),
        actions: [
          ListenableBuilder(
            listenable: _drawing,
            builder: (context, _) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: l10n.actionUndo,
                  onPressed: _drawing.canUndo ? _drawing.undo : null,
                  icon: const Icon(Icons.undo),
                ),
                IconButton(
                  tooltip: l10n.actionRedo,
                  onPressed: _drawing.canRedo ? _drawing.redo : null,
                  icon: const Icon(Icons.redo),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (v) => switch (v) {
              'clear' => _drawing.clear(),
              'delete' => _deletePage(),
              _ => _notes.setBackground(
                page!.id,
                PageBackground.values.byName(v),
              ),
            },
            itemBuilder: (context) => [
              for (final b in PageBackground.values)
                CheckedPopupMenuItem(
                  value: b.name,
                  checked: page?.background == b,
                  child: Text(_backgroundLabel(l10n, b)),
                ),
              const PopupMenuDivider(),
              PopupMenuItem(value: 'clear', child: Text(l10n.notesClearPage)),
              if (_pages.length > 1)
                PopupMenuItem(
                  value: 'delete',
                  child: Text(l10n.notesDeletePage),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _Toolbar(
              drawing: _drawing,
              fingerDrawing: settings.fingerDrawing,
              onFingerDrawing: settings.setFingerDrawing,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: page == null
                    ? const SizedBox.shrink()
                    : DrawingCanvas(
                        key: ValueKey(page.id),
                        controller: _drawing,
                        background: page.background,
                        labels: labels,
                        fingerDraws: settings.fingerDrawing,
                      ),
              ),
            ),
            _PageStrip(
              pages: _pages,
              selectedId: _pageId,
              onSelect: _select,
              onAdd: _addPage,
              backgroundLabel: (b) => _backgroundLabel(l10n, b),
            ),
          ],
        ),
      ),
    );
  }

  static String _backgroundLabel(AppLocalizations l10n, PageBackground b) =>
      switch (b) {
        PageBackground.blank => l10n.pageBlank,
        PageBackground.grid => l10n.pageGrid,
        PageBackground.lined => l10n.pageLined,
        PageBackground.atis => l10n.pageAtis,
        PageBackground.craft => l10n.pageCraft,
      };
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.drawing,
    required this.fingerDrawing,
    required this.onFingerDrawing,
  });

  final DrawingController drawing;
  final bool fingerDrawing;
  final ValueChanged<bool> onFingerDrawing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = InkPalette.of(context);
    final scheme = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: drawing,
      builder: (context, _) {
        final highlighter = drawing.tool == DrawTool.highlighter;
        final colors = highlighter
            ? [for (final c in InkPalette.highlighters) c.withValues(alpha: 1)]
            : palette.ink;
        final selectedColor = highlighter
            ? drawing.highlighterColor
            : drawing.penColor;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              SegmentedButton<DrawTool>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: DrawTool.pen,
                    icon: const Icon(Icons.edit),
                    tooltip: l10n.toolPen,
                  ),
                  ButtonSegment(
                    value: DrawTool.highlighter,
                    icon: const Icon(Icons.border_color),
                    tooltip: l10n.toolHighlighter,
                  ),
                  ButtonSegment(
                    value: DrawTool.eraser,
                    icon: const Icon(Icons.auto_fix_normal),
                    tooltip: l10n.toolEraser,
                  ),
                ],
                selected: {drawing.tool},
                onSelectionChanged: (s) => drawing.setTool(s.single),
              ),
              const SizedBox(width: 16),
              for (var i = 0; i < colors.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => drawing.setColor(i),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: colors[i],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              i == selectedColor &&
                                  drawing.tool != DrawTool.eraser
                              ? scheme.primary
                              : scheme.outlineVariant,
                          width: i == selectedColor ? 3 : 1,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 16),
              for (final size in DrawingController.penSizes)
                IconButton(
                  tooltip: l10n.toolSize,
                  isSelected:
                      drawing.tool == DrawTool.pen && drawing.penSize == size,
                  onPressed: () => drawing.setPenSize(size),
                  icon: Container(
                    width: size * 2 + 2,
                    height: size * 2 + 2,
                    decoration: BoxDecoration(
                      color: scheme.onSurface,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              const SizedBox(width: 16),
              IconButton(
                tooltip: l10n.settingsFingerDrawing,
                isSelected: fingerDrawing,
                onPressed: () => onFingerDrawing(!fingerDrawing),
                icon: const Icon(Icons.do_not_touch_outlined),
                selectedIcon: const Icon(Icons.touch_app),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PageStrip extends StatelessWidget {
  const _PageStrip({
    required this.pages,
    required this.selectedId,
    required this.onSelect,
    required this.onAdd,
    required this.backgroundLabel,
  });

  final List<ScratchPage> pages;
  final int? selectedId;
  final ValueChanged<ScratchPage> onSelect;
  final ValueChanged<PageBackground> onAdd;
  final String Function(PageBackground) backgroundLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          for (var i = 0; i < pages.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text('${i + 1}'),
                selected: pages[i].id == selectedId,
                onSelected: (_) => onSelect(pages[i]),
              ),
            ),
          PopupMenuButton<PageBackground>(
            tooltip: l10n.notesAddPage,
            onSelected: onAdd,
            itemBuilder: (context) => [
              for (final b in PageBackground.values)
                PopupMenuItem(value: b, child: Text(backgroundLabel(b))),
            ],
            child: Chip(
              avatar: const Icon(Icons.add, size: 18),
              label: Text(l10n.notesAddPage),
            ),
          ),
        ],
      ),
    );
  }
}
