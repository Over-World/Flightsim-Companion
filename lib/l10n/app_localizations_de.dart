// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Flightsim Companion';

  @override
  String get navPlan => 'Planen';

  @override
  String get navFly => 'Fliegen';

  @override
  String get navAircraft => 'Flugzeuge';

  @override
  String get navLogbook => 'Flugbuch';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get fieldRequired => 'Pflichtfeld';

  @override
  String get fieldInvalidNumber => 'Positive Zahl eingeben';

  @override
  String get navdataMissingTitle => 'Noch keine Navigationsdaten';

  @override
  String get navdataMissingMessage =>
      'Lade Flugplätze, Pisten, Frequenzen und Funknavigationsanlagen einmalig herunter, um die App offline zu nutzen.';

  @override
  String get navdataMissingAction => 'Herunterladen';

  @override
  String get flightsEmptyTitle => 'Keine Flüge geplant';

  @override
  String get flightsEmptyMessage =>
      'Hier erscheinen deine geplanten VFR- und IFR-Flüge. Bis dahin kannst du Flugplätze, Frequenzen und Navaids nachschlagen.';

  @override
  String get flyNoActiveFlightTitle => 'Kein aktiver Flug';

  @override
  String get flyNoActiveFlightMessage =>
      'Starte einen geplanten Flug, um das Kneeboard mit Navlog, Stoppuhr und Frequenzen zu öffnen.';

  @override
  String get logbookEmptyTitle => 'Flugbuch ist leer';

  @override
  String get logbookEmptyMessage =>
      'Abgeschlossene Flüge werden hier mit Zeiten und Landungsbewertung eingetragen.';

  @override
  String get airportSearchTitle => 'Flugplatz suchen';

  @override
  String get airportSearchHint => 'ICAO, IATA, Name oder Ort';

  @override
  String airportSearchNoResults(String query) {
    return 'Kein Flugplatz für „$query“ gefunden';
  }

  @override
  String get airportTypeLarge => 'Großer Flughafen';

  @override
  String get airportTypeMedium => 'Mittlerer Flughafen';

  @override
  String get airportTypeSmall => 'Flugplatz';

  @override
  String get airportTypeHeliport => 'Hubschrauberlandeplatz';

  @override
  String get airportTypeSeaplane => 'Wasserflugplatz';

  @override
  String elevationFt(int ft) {
    return '$ft ft';
  }

  @override
  String get frequencies => 'Frequenzen';

  @override
  String get noFrequencies => 'Keine Frequenzen bekannt';

  @override
  String get runways => 'Pisten';

  @override
  String get noRunways => 'Keine Pisten bekannt';

  @override
  String runwayDimensions(int lengthFt, int lengthM, int widthFt) {
    return '$lengthFt ft ($lengthM m) × $widthFt ft';
  }

  @override
  String get runwayLighted => 'befeuert';

  @override
  String get navaidsNearby => 'Navaids in der Nähe';

  @override
  String get noNavaids => 'Keine Navaids im Umkreis von 40 NM';

  @override
  String radialDistance(String radial, String distance) {
    return 'Platz auf R$radial · $distance NM';
  }

  @override
  String get aircraftAdd => 'Flugzeug hinzufügen';

  @override
  String get aircraftEdit => 'Flugzeug bearbeiten';

  @override
  String get aircraftEmpty => 'Keine Flugzeugprofile';

  @override
  String aircraftSummary(int tas, String burn, String unit) {
    return '$tas kt TAS · $burn $unit/h';
  }

  @override
  String get aircraftDeleteTitle => 'Flugzeug löschen?';

  @override
  String aircraftDeleteMessage(String name) {
    return '„$name“ wird endgültig entfernt.';
  }

  @override
  String get aircraftSectionGeneral => 'Allgemein';

  @override
  String get aircraftName => 'Name';

  @override
  String get aircraftIcaoType => 'ICAO-Typ';

  @override
  String get aircraftRegistration => 'Kennzeichen';

  @override
  String get aircraftSectionPerformance => 'Leistung';

  @override
  String get aircraftCruiseTas => 'Reise-TAS';

  @override
  String get aircraftClimbTas => 'Steig-TAS';

  @override
  String get aircraftClimbRate => 'Steigrate';

  @override
  String get aircraftDescentRate => 'Sinkrate';

  @override
  String get aircraftSectionFuel => 'Kraftstoff';

  @override
  String get aircraftFuelBurn => 'Verbrauch (Reise)';

  @override
  String get aircraftUsableFuel => 'Ausfliegbarer Kraftstoff';

  @override
  String get aircraftFuelType => 'Kraftstoffart';

  @override
  String get aircraftSectionWeights => 'Massen';

  @override
  String get aircraftEmptyWeight => 'Leermasse';

  @override
  String get aircraftMtow => 'Max. Abflugmasse';

  @override
  String get aircraftNotes => 'Notizen';

  @override
  String get aircraftNotesHint =>
      'V-Geschwindigkeiten, Verfahren, Besonderheiten…';

  @override
  String get settingsAppearance => 'Darstellung';

  @override
  String get settingsTheme => 'Design';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get settingsAccent => 'Akzentfarbe';

  @override
  String get settingsUnits => 'Einheiten';

  @override
  String get settingsFuelUnit => 'Kraftstoff';

  @override
  String get unitLiters => 'Liter';

  @override
  String get unitUsGallons => 'US-Gallonen';

  @override
  String get settingsWeightUnit => 'Masse';

  @override
  String get unitKilograms => 'Kilogramm';

  @override
  String get unitPounds => 'Pfund';

  @override
  String get settingsSimulator => 'Simulator';

  @override
  String get settingsXplaneHint =>
      'X-Plane 12: Gib die IP-Adresse des PCs ein, auf dem der Simulator läuft. Die App verbindet sich im lokalen Netz mit der Web-API von X-Plane.';

  @override
  String get settingsSimHost => 'X-Plane-PC (IP oder Hostname)';

  @override
  String get settingsSimPort => 'Port';

  @override
  String get settingsNavdata => 'Navigationsdaten';

  @override
  String get navdataNeverImported => 'Noch nicht heruntergeladen';

  @override
  String navdataImportedAt(String date) {
    return 'Zuletzt aktualisiert am $date';
  }

  @override
  String navdataCounts(
    String airports,
    String runways,
    String frequencies,
    String navaids,
  ) {
    return '$airports Flugplätze · $runways Pisten · $frequencies Frequenzen · $navaids Navaids';
  }

  @override
  String navdataImportFailed(String error) {
    return 'Download fehlgeschlagen: $error';
  }

  @override
  String get navdataSource =>
      'Quelle: OurAirports (Public Domain), weltweit, ca. 20 MB.';

  @override
  String get navdataDownload => 'Herunterladen';

  @override
  String get navdataUpdate => 'Aktualisieren';

  @override
  String navdataStageDownloading(String file) {
    return 'Lade $file…';
  }

  @override
  String get navdataStageParsing => 'Verarbeite Daten…';

  @override
  String get navdataStageWriting => 'Speichere in Datenbank…';

  @override
  String get back => 'Zurück';

  @override
  String get next => 'Weiter';

  @override
  String get settingsGeneral => 'Allgemein';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get languageSystem => 'System';

  @override
  String get settingsHomeAirport => 'Heimatflugplatz';

  @override
  String get settingsDefaultAircraft => 'Standardflugzeug';

  @override
  String get settingsAccounts => 'Konten';

  @override
  String get settingsSimbriefUser => 'SimBrief-Benutzername oder Pilot-ID';

  @override
  String get settingsSimbriefHint =>
      'Damit wird für IFR-Flüge dein neuester OFP importiert.';

  @override
  String get settingsNotes => 'Notizen';

  @override
  String get settingsFingerDrawing => 'Mit dem Finger zeichnen';

  @override
  String get settingsFingerDrawingHint =>
      'Wenn aus, zeichnet nur der Stift und der Finger scrollt nur.';

  @override
  String get settingsRestartOnboarding => 'Einrichtung erneut starten';

  @override
  String get xplaneTest => 'Verbindung testen';

  @override
  String get xplaneTesting => 'Verbinde…';

  @override
  String xplaneConnected(String version) {
    return 'Verbunden mit X-Plane $version';
  }

  @override
  String xplaneConnectionFailed(String error) {
    return 'Keine Verbindung: $error';
  }

  @override
  String onboardingStep(int current, int total) {
    return '$current / $total';
  }

  @override
  String get onboardingFinish => 'Los geht\'s';

  @override
  String get onboardingWelcomeTitle => 'Willkommen an Bord';

  @override
  String get onboardingWelcomeText =>
      'Flightsim Companion ist dein Kneeboard für X-Plane und MSFS: VFR- und IFR-Flüge planen, mit Navlog, Stoppuhr und Frequenzen fliegen und Notizen machen wie auf echtem Papier. Ein paar kurze Schritte, dann geht\'s los.';

  @override
  String get onboardingNavdataTitle => 'Navigationsdaten';

  @override
  String get onboardingNavdataText =>
      'Flugplätze, Pisten, Frequenzen und Funknavigationsanlagen weltweit. Einmal herunterladen, danach funktioniert alles offline.';

  @override
  String get onboardingSimTitle => 'X-Plane verbinden';

  @override
  String get onboardingSimText =>
      'Optional. Gib die IP-Adresse des PCs ein, auf dem X-Plane 12 läuft – beide Geräte müssen im selben Netzwerk sein. Du kannst den Schritt überspringen und ohne Live-Verbindung fliegen.';

  @override
  String get onboardingAccountsTitle => 'Konten';

  @override
  String get onboardingAccountsText =>
      'Optional. Mit deinem SimBrief-Benutzernamen kann die App später deinen neuesten Flugplan importieren.';

  @override
  String get onboardingHomeTitle => 'Heimatbasis';

  @override
  String get onboardingHomeText =>
      'Dein Heimatflugplatz wird bei neuen Flügen als Startflugplatz vorgeschlagen, dein Standardflugzeug ist vorausgewählt.';

  @override
  String get onboardingHomeNeedsNavdata =>
      'Lade zuerst die Navigationsdaten herunter, um einen Heimatflugplatz zu wählen – du kannst ihn später in den Einstellungen setzen.';
}
