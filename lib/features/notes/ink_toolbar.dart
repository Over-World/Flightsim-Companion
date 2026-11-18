import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import 'drawing_canvas.dart';
import 'drawing_controller.dart';

/// Pen, highlighter and eraser, colours and pen sizes for a
/// [DrawingController]; shared by the notepad and the chart viewer.
class InkToolbar extends StatelessWidget {
  const InkToolbar({
    super.key,
    required this.drawing,
    this.palette,
    this.fingerDrawing = false,
    this.onFingerDrawing,
  });

  final DrawingController drawing;

  /// Ink colours to offer; defaults to the paper palette of the theme.
  final InkPalette? palette;
  final bool fingerDrawing;

  /// Shows the finger-drawing toggle when set.
  final ValueChanged<bool>? onFingerDrawing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = this.palette ?? InkPalette.of(context);
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
              if (onFingerDrawing case final onFingerDrawing?) ...[
                const SizedBox(width: 16),
                IconButton(
                  tooltip: l10n.settingsFingerDrawing,
                  isSelected: fingerDrawing,
                  onPressed: () => onFingerDrawing(!fingerDrawing),
                  icon: const Icon(Icons.do_not_touch_outlined),
                  selectedIcon: const Icon(Icons.touch_app),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
