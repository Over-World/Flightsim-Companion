import 'package:flutter/foundation.dart';

import '../../data/repositories/navdata_repository.dart';
import '../../data/weather/weather_models.dart';
import '../../data/weather/weather_repository.dart';

/// Shares weather reports between screens (weather cards, runway choice,
/// kneeboard) so a report fetched once is visible everywhere.
class WeatherController extends ChangeNotifier {
  WeatherController({required this.repository, required this.navdata});

  final WeatherRepository repository;
  final NavdataRepository navdata;

  final _reports = <String, WeatherReport>{};
  final _loading = <String>{};
  final _errors = <String, Object>{};
  final _cacheChecked = <String>{};

  WeatherReport? report(String ident) => _reports[ident];
  bool isLoading(String ident) => _loading.contains(ident);
  Object? error(String ident) => _errors[ident];

  /// Loads the offline cache only, without network (e.g. for the runway
  /// suggestion before anyone opened a weather card).
  Future<void> loadCached(String ident) async {
    if (_reports.containsKey(ident) || !_cacheChecked.add(ident)) return;
    final cached = await repository.cached(ident);
    if (cached != null && !_reports.containsKey(ident)) {
      _reports[ident] = cached;
      notifyListeners();
    }
  }

  Future<void> refresh(String ident, {bool force = false}) async {
    if (_loading.contains(ident)) return;
    final airport = await navdata.airportByIdent(ident);
    if (airport == null) return;
    _loading.add(ident);
    _errors.remove(ident);
    notifyListeners();
    try {
      _reports[ident] = await repository.weatherFor(airport, force: force);
    } on Exception catch (e) {
      _errors[ident] = e;
    } finally {
      _loading.remove(ident);
      notifyListeners();
    }
  }
}
