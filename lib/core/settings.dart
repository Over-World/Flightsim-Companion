import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AccentColor {
  blue(FlexScheme.blue),
  indigo(FlexScheme.indigo),
  green(FlexScheme.green),
  amber(FlexScheme.amber),
  red(FlexScheme.red),
  deepPurple(FlexScheme.deepPurple);

  const AccentColor(this.scheme);
  final FlexScheme scheme;
}

/// `system` follows the device language.
enum AppLanguage { system, de, en }

enum FuelUnit { liters, usGallons }

enum WeightUnit { kilograms, pounds }

class SettingsController extends ChangeNotifier {
  SettingsController(this._prefs);

  static const defaultSimPort = 8086;

  final SharedPreferences _prefs;

  static Future<SettingsController> load() async =>
      SettingsController(await SharedPreferences.getInstance());

  T _enum<T extends Enum>(String key, List<T> values, T fallback) {
    final name = _prefs.getString(key);
    return values.where((v) => v.name == name).firstOrNull ?? fallback;
  }

  AppLanguage get language =>
      _enum('language', AppLanguage.values, AppLanguage.system);

  Locale? get locale =>
      language == AppLanguage.system ? null : Locale(language.name);

  bool get onboardingCompleted =>
      _prefs.getBool('onboardingCompleted') ?? false;

  /// Ident of the home airport, preselected as departure.
  String? get homeAirportIdent => _prefs.getString('homeAirportIdent');
  int? get defaultAircraftId => _prefs.getInt('defaultAircraftId');
  String get simbriefUsername => _prefs.getString('simbriefUsername') ?? '';

  /// Lets a finger draw on notes; otherwise only a stylus draws.
  bool get fingerDrawing => _prefs.getBool('fingerDrawing') ?? true;

  /// Most recently used E6B calculators, newest first.
  List<String> get e6bRecent => _prefs.getStringList('e6bRecent') ?? const [];

  Future<void> markE6bUsed(String id) async {
    final list = [id, ...e6bRecent.where((e) => e != id)].take(4).toList();
    await _prefs.setStringList('e6bRecent', list);
    notifyListeners();
  }

  ThemeMode get themeMode =>
      _enum('themeMode', ThemeMode.values, ThemeMode.system);
  AccentColor get accent =>
      _enum('accent', AccentColor.values, AccentColor.blue);
  FuelUnit get fuelUnit => _enum('fuelUnit', FuelUnit.values, FuelUnit.liters);
  WeightUnit get weightUnit =>
      _enum('weightUnit', WeightUnit.values, WeightUnit.kilograms);

  /// IP or hostname of the PC running X-Plane.
  String get simHost => _prefs.getString('simHost') ?? '';
  int get simPort => _prefs.getInt('simPort') ?? defaultSimPort;

  DateTime? get navdataImportedAt {
    final ms = _prefs.getInt('navdataImportedAt');
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> _setEnum(String key, Enum value) async {
    await _prefs.setString(key, value.name);
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage v) => _setEnum('language', v);
  Future<void> setThemeMode(ThemeMode v) => _setEnum('themeMode', v);
  Future<void> setAccent(AccentColor v) => _setEnum('accent', v);
  Future<void> setFuelUnit(FuelUnit v) => _setEnum('fuelUnit', v);
  Future<void> setWeightUnit(WeightUnit v) => _setEnum('weightUnit', v);

  Future<void> setSimConnection(String host, int port) async {
    await _prefs.setString('simHost', host.trim());
    await _prefs.setInt('simPort', port);
    notifyListeners();
  }

  Future<void> setOnboardingCompleted(bool v) async {
    await _prefs.setBool('onboardingCompleted', v);
    notifyListeners();
  }

  Future<void> _setOptionalString(String key, String? value) async {
    final v = value?.trim();
    if (v == null || v.isEmpty) {
      await _prefs.remove(key);
    } else {
      await _prefs.setString(key, v);
    }
    notifyListeners();
  }

  Future<void> setHomeAirportIdent(String? ident) =>
      _setOptionalString('homeAirportIdent', ident?.toUpperCase());

  Future<void> setSimbriefUsername(String? name) =>
      _setOptionalString('simbriefUsername', name);

  Future<void> setDefaultAircraftId(int? id) async {
    if (id == null) {
      await _prefs.remove('defaultAircraftId');
    } else {
      await _prefs.setInt('defaultAircraftId', id);
    }
    notifyListeners();
  }

  Future<void> setFingerDrawing(bool v) async {
    await _prefs.setBool('fingerDrawing', v);
    notifyListeners();
  }

  Future<void> setNavdataImportedAt(DateTime time) async {
    await _prefs.setInt('navdataImportedAt', time.millisecondsSinceEpoch);
    notifyListeners();
  }
}
