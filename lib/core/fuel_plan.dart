/// Fuel planning following the usual GA scheme (EASA Part-NCO style):
/// taxi + trip + contingency + alternate + final reserve + extra.
/// All quantities in litres.
class FuelPlan {
  const FuelPlan({
    required this.taxi,
    required this.trip,
    required this.contingency,
    required this.alternate,
    required this.finalReserve,
    required this.extra,
    required this.burnLph,
    required this.usable,
    this.onBoard,
  });

  /// Computes the plan; [trip] is `null` when the navlog is unsolvable.
  factory FuelPlan.compute({
    required bool ifr,
    required bool night,
    required double? trip,
    required double burnLph,
    required double usable,
    double? taxi,
    double? contingencyPercent,
    int? finalReserveMinutes,
    double alternate = 0,
    double? extra,
    double? onBoard,
  }) {
    final t = trip ?? double.nan;
    final percent = contingencyPercent ?? defaultContingencyPercent(ifr: ifr);
    final reserveMin =
        finalReserveMinutes ??
        defaultFinalReserveMinutes(ifr: ifr, night: night);
    return FuelPlan(
      taxi: taxi ?? 0,
      trip: t,
      contingency: t * percent / 100,
      // VFR flights carry no alternate fuel by rule.
      alternate: ifr ? alternate : 0,
      finalReserve: burnLph * reserveMin / 60,
      extra: extra ?? 0,
      burnLph: burnLph,
      usable: usable,
      onBoard: onBoard,
    );
  }

  static double defaultContingencyPercent({required bool ifr}) => ifr ? 5 : 0;

  static int defaultFinalReserveMinutes({
    required bool ifr,
    required bool night,
  }) => ifr || night ? 45 : 30;

  final double taxi;

  /// NaN when the trip can't be calculated.
  final double trip;
  final double contingency;
  final double alternate;
  final double finalReserve;
  final double extra;
  final double burnLph;
  final double usable;

  /// Planned fuel on board at engine start; `null` = not entered.
  final double? onBoard;

  bool get valid => trip.isFinite;

  /// Minimum fuel at engine start.
  double get required =>
      taxi + trip + contingency + alternate + finalReserve + extra;

  /// Fuel on board, defaulting to the required amount.
  double get plannedOnBoard => onBoard ?? required;

  /// Positive = more fuel than required.
  double get margin => plannedOnBoard - required;

  bool get belowRequired => valid && margin < -0.05;
  bool get exceedsUsable => plannedOnBoard > usable + 0.05;
  bool get requiredExceedsUsable => valid && required > usable + 0.05;

  /// Fuel at takeoff (after taxi).
  double get atTakeoff => plannedOnBoard - taxi;

  /// Expected fuel on landing at the destination.
  double get atLanding => atTakeoff - trip;

  /// Time from takeoff until the tanks are dry.
  Duration get endurance => burnLph <= 0
      ? Duration.zero
      : Duration(seconds: (atTakeoff / burnLph * 3600).round());
}
