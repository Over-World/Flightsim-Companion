import 'package:drift/drift.dart';

import '../../core/weight_balance.dart';
import '../aircraft_defaults.dart';
import '../db/database.dart';

class AircraftRepository {
  AircraftRepository(this._db);

  final AppDatabase _db;

  Stream<List<AircraftProfile>> watchAll() => (_db.select(
    _db.aircraftProfiles,
  )..orderBy([(a) => OrderingTerm.asc(a.name)])).watch();

  Future<AircraftProfile?> byId(int id) => (_db.select(
    _db.aircraftProfiles,
  )..where((a) => a.id.equals(id))).getSingleOrNull();

  Future<int> save(AircraftProfilesCompanion profile) =>
      _db.into(_db.aircraftProfiles).insertOnConflictUpdate(profile);

  Future<void> delete(int id) =>
      (_db.delete(_db.aircraftProfiles)..where((a) => a.id.equals(id))).go();

  /// Adds profiles for some X-Plane 12 default aircraft on first start.
  Future<void> seedDefaults() async {
    final existing = await _db.select(_db.aircraftProfiles).get();
    if (existing.isNotEmpty) return;
    await _db.batch(
      (b) => b.insertAll(_db.aircraftProfiles, [
        for (final a in defaultAircraft)
          a.copyWith(
            taxiFuelL: Value(
              aircraftWbDefaults[a.icaoType.value]?.taxiFuelL ??
                  defaultTaxiFuelL[a.icaoType.value],
            ),
          ),
      ]),
    );
    for (final entry in aircraftWbDefaults.entries) {
      await applyWbDefaults(_db, entry.key, entry.value);
    }
  }

  /// Fills W&B data of a default aircraft type (used by seeding and the
  /// schema 5 migration).
  static Future<void> applyWbDefaults(
    AppDatabase db,
    String icaoType,
    AircraftWbDefaults d,
  ) =>
      (db.update(
        db.aircraftProfiles,
      )..where((a) => a.icaoType.equals(icaoType) & a.emptyArm.isNull())).write(
        AircraftProfilesCompanion(
          armUnit: const Value('in'),
          emptyArm: Value(d.emptyArm),
          taxiFuelL: Value(d.taxiFuelL),
          stations: Value(WbStation.encodeAll(d.stations)),
          envelope: Value(EnvelopePoint.encodeAll(d.envelope)),
        ),
      );

  static final defaultAircraft = [
    AircraftProfilesCompanion.insert(
      name: 'Cessna 172 SP',
      icaoType: 'C172',
      maxCrosswindKt: const Value(15),
      cruiseTas: 115,
      climbTas: const Value(74),
      climbRateFpm: const Value(700),
      descentRateFpm: const Value(500),
      fuelBurnLph: 34,
      usableFuelL: 200,
      emptyWeightKg: const Value(767),
      maxTakeoffWeightKg: const Value(1111),
    ),
    AircraftProfilesCompanion.insert(
      name: 'Cirrus SR22',
      icaoType: 'SR22',
      maxCrosswindKt: const Value(21),
      cruiseTas: 170,
      climbTas: const Value(110),
      climbRateFpm: const Value(1000),
      descentRateFpm: const Value(700),
      fuelBurnLph: 57,
      usableFuelL: 348,
      emptyWeightKg: const Value(1050),
      maxTakeoffWeightKg: const Value(1633),
    ),
    AircraftProfilesCompanion.insert(
      name: 'Piper PA-18 Super Cub',
      icaoType: 'PA18',
      maxCrosswindKt: const Value(10),
      cruiseTas: 95,
      climbTas: const Value(65),
      climbRateFpm: const Value(900),
      descentRateFpm: const Value(500),
      fuelBurnLph: 30,
      usableFuelL: 136,
      emptyWeightKg: const Value(422),
      maxTakeoffWeightKg: const Value(794),
    ),
    AircraftProfilesCompanion.insert(
      name: 'Beechcraft Baron 58',
      icaoType: 'BE58',
      maxCrosswindKt: const Value(22),
      cruiseTas: 195,
      climbTas: const Value(120),
      climbRateFpm: const Value(1500),
      descentRateFpm: const Value(1000),
      fuelBurnLph: 114,
      usableFuelL: 734,
      emptyWeightKg: const Value(1580),
      maxTakeoffWeightKg: const Value(2495),
    ),
  ];
}
