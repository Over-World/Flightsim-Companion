import 'package:flightsim_companion/core/fuel_plan.dart';
import 'package:flightsim_companion/core/weight_balance.dart';
import 'package:flightsim_companion/data/aircraft_defaults.dart';
import 'package:flutter_test/flutter_test.dart';

const lb = 0.45359237;

void main() {
  group('fuel plan', () {
    test('VFR day: trip + 30 min reserve, no contingency or alternate', () {
      final p = FuelPlan.compute(
        ifr: false,
        night: false,
        trip: 20,
        burnLph: 34,
        usable: 200,
        taxi: 4,
        alternate: 15,
      );
      expect(p.contingency, 0);
      expect(p.alternate, 0);
      expect(p.finalReserve, closeTo(17, 1e-9));
      expect(p.required, closeTo(41, 1e-9));
      // Without an entered FOB the required fuel is planned.
      expect(p.margin, closeTo(0, 1e-9));
      expect(p.atLanding, closeTo(17, 1e-9));
    });

    test('IFR: 5 % contingency, alternate and 45 min reserve', () {
      final p = FuelPlan.compute(
        ifr: true,
        night: false,
        trip: 100,
        burnLph: 60,
        usable: 300,
        taxi: 6,
        alternate: 20,
        onBoard: 150,
      );
      expect(p.contingency, closeTo(5, 1e-9));
      expect(p.finalReserve, closeTo(45, 1e-9));
      expect(p.required, closeTo(176, 1e-9));
      expect(p.belowRequired, isTrue);
      expect(p.endurance, const Duration(minutes: 144));
    });

    test('night VFR uses 45 min; overrides win', () {
      expect(FuelPlan.defaultFinalReserveMinutes(ifr: false, night: true), 45);
      final p = FuelPlan.compute(
        ifr: false,
        night: true,
        trip: 10,
        burnLph: 60,
        usable: 40,
        finalReserveMinutes: 60,
        contingencyPercent: 10,
        extra: 5,
      );
      expect(p.finalReserve, 60);
      expect(p.contingency, closeTo(1, 1e-9));
      expect(p.required, closeTo(76, 1e-9));
      expect(p.requiredExceedsUsable, isTrue);
    });

    test('unsolvable trip makes the plan invalid', () {
      final p = FuelPlan.compute(
        ifr: false,
        night: false,
        trip: null,
        burnLph: 30,
        usable: 100,
      );
      expect(p.valid, isFalse);
      expect(p.belowRequired, isFalse);
    });
  });

  group('weight & balance', () {
    final c172 = aircraftWbDefaults['C172']!;

    WbResult compute(Map<int, double> loads, double fuelKg, double landingKg) =>
        WbResult.compute(
          emptyKg: 1663 * lb,
          emptyArm: c172.emptyArm,
          stations: c172.stations,
          envelope: c172.envelope,
          loadsKg: loads,
          takeoffFuelKg: fuelKg,
          landingFuelKg: landingKg,
          maxTakeoffKg: 2550 * lb,
        );

    test('POH sample loading is within limits', () {
      // Two front seats 340 lb, 40 gal fuel (240 lb), 20 lb baggage.
      final r = compute({0: 340 * lb, 2: 20 * lb}, 240 * lb, 180 * lb);
      expect(r.takeoff.weightKg / lb, closeTo(2263, 0.5));
      expect(r.takeoff.cg, closeTo(40.59, 0.01));
      expect(r.ok, isTrue);
    });

    test('overweight, aft CG and overloaded baggage are flagged', () {
      final r = compute(
        {0: 400 * lb, 1: 340 * lb, 3: 80 * lb},
        318 * lb,
        250 * lb,
      );
      expect(r.overMaxTakeoff, isTrue);
      expect(r.overloadedStations, [3]);
      expect(r.takeoffInEnvelope, isFalse);
      expect(r.ok, isFalse);
    });

    test('point in envelope incl. edges', () {
      final env = c172.envelope;
      expect(pointInEnvelope(env, 40, 2000 * lb), isTrue);
      expect(pointInEnvelope(env, 34, 2000 * lb), isFalse);
      expect(pointInEnvelope(env, 47.3, 2000 * lb), isTrue);
      expect(pointInEnvelope(env, 36, 2500 * lb), isFalse);
    });

    test('stations and envelope survive JSON', () {
      final s = WbStation.decodeAll(WbStation.encodeAll(c172.stations));
      expect(s.map((x) => x.kind), c172.stations.map((x) => x.kind));
      expect(s[2].maxKg, closeTo(120 * lb, 1e-9));
      final e = EnvelopePoint.decodeAll(EnvelopePoint.encodeAll(c172.envelope));
      expect(e.last.arm, 47.3);
    });
  });
}
