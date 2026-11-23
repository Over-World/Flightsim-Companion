import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../shell/adaptive_shell.dart';

/// Opens the notepad from an app bar. Phones only: on wider screens the
/// navigation rail has the notepad button.
class NotesButton extends StatelessWidget {
  const NotesButton({super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).width >= railBreakpoint) {
      return const SizedBox.shrink();
    }
    return IconButton(
      tooltip: AppLocalizations.of(context).notesOpen,
      icon: const Icon(Icons.draw_outlined),
      onPressed: () => context.push('/notes'),
    );
  }
}
