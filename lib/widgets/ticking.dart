import 'dart:async';

import 'package:material_ui/material_ui.dart';

/// Rebuilds [builder] every [interval] with the current time. Keeps clock
/// updates local instead of rebuilding whole screens.
class Ticking extends StatefulWidget {
  const Ticking({
    super.key,
    required this.builder,
    this.interval = const Duration(seconds: 1),
  });

  final Widget Function(BuildContext context, DateTime now) builder;
  final Duration interval;

  @override
  State<Ticking> createState() => _TickingState();
}

class _TickingState extends State<Ticking> {
  late final Timer _timer = Timer.periodic(
    widget.interval,
    (_) => setState(() {}),
  );

  @override
  void initState() {
    super.initState();
    _timer;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, DateTime.now());
}

/// `12:34` (mm:ss) below an hour, `1:02:03` above.
String formatClock(Duration d) {
  final negative = d.isNegative;
  final s = d.inSeconds.abs();
  final h = s ~/ 3600;
  final m = (s % 3600) ~/ 60;
  final sec = (s % 60).toString().padLeft(2, '0');
  final body = h > 0
      ? '$h:${m.toString().padLeft(2, '0')}:$sec'
      : '${m.toString().padLeft(2, '0')}:$sec';
  return negative ? '-$body' : body;
}
