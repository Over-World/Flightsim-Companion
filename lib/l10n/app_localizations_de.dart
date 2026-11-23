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

  @override
  String get flightsEmptyMessage =>
      'Plane deinen ersten VFR- oder IFR-Flug: Start, Ziel, Wegpunkte – das Navlog wird für dich berechnet.';

  @override
  String get flightNew => 'Neuer Flug';

  @override
  String get flightCreate => 'Anlegen';

  @override
  String get flightEdit => 'Flugdaten';

  @override
  String get flightTitle => 'Titel';

  @override
  String get flightDeparture => 'Start';

  @override
  String get flightDestination => 'Ziel';

  @override
  String get flightAlternate => 'Ausweichflugplatz';

  @override
  String flightAlternateShort(String ident) {
    return 'Altn $ident';
  }

  @override
  String get flightAircraft => 'Flugzeug';

  @override
  String get flightCruiseAltitude => 'Reiseflughöhe';

  @override
  String get flightPlannedDeparture => 'Geplanter Abflug (Off-Block)';

  @override
  String get flightWindHint =>
      'Wind für alle Legs ohne eigenen Wind (rechtweisend, woher).';

  @override
  String get flightNoAircraft => 'Kein Flugzeug gewählt';

  @override
  String get flightChooseAircraft => 'Flugzeug wählen';

  @override
  String get flightFly => 'Fliegen';

  @override
  String get flightTabRoute => 'Route';

  @override
  String get flightTabNavlog => 'Navlog';

  @override
  String get flightStatusPlanned => 'Geplant';

  @override
  String get flightStatusActive => 'Im Flug';

  @override
  String get flightStatusCompleted => 'Abgeschlossen';

  @override
  String get flightDeleteTitle => 'Flug löschen?';

  @override
  String flightDeleteMessage(String title) {
    return '„$title“ und alle zugehörigen Notizen werden endgültig entfernt.';
  }

  @override
  String get windDirection => 'Wind aus';

  @override
  String get windSpeed => 'Windstärke';

  @override
  String legTo(String ident) {
    return 'Leg nach $ident';
  }

  @override
  String get legEdit => 'Leg bearbeiten';

  @override
  String get legAltitude => 'Höhe';

  @override
  String get legWindHint => 'Leer lassen, um den Wind des Flugs zu verwenden.';

  @override
  String get legNotes => 'Notizen zu diesem Leg';

  @override
  String get waypointAdd => 'Wegpunkt hinzufügen';

  @override
  String get waypointTabSearch => 'Suche';

  @override
  String get waypointTabRadial => 'Radial/DME';

  @override
  String get waypointTabCoordinates => 'Koordinaten';

  @override
  String get waypointSearchHint => 'Navaid oder Flugplatz: Kennung oder Name';

  @override
  String get waypointNavaidIdent => 'Navaid-Kennung (z. B. FFM)';

  @override
  String get waypointRadial => 'Radial';

  @override
  String get waypointDistance => 'Entfernung';

  @override
  String get waypointName => 'Name';

  @override
  String get waypointNameHint => 'z. B. See, Autobahnkreuz, Pflichtmeldepunkt';

  @override
  String get waypointLatitude => 'Breite';

  @override
  String get waypointLongitude => 'Länge';

  @override
  String get waypointCoordinatesHint => 'Dezimalgrad, Süd und West negativ.';

  @override
  String get navlogWaypoint => 'Nach';

  @override
  String get navlogWind => 'Wind';

  @override
  String get navlogCalm => 'still';

  @override
  String get navlogTotal => 'Gesamt';

  @override
  String get navlogDistance => 'Strecke';

  @override
  String get navlogTime => 'Flugzeit';

  @override
  String get navlogFuel => 'Streckenkraftstoff';

  @override
  String get navlogNeedsAircraft =>
      'Wähle ein Flugzeug, um Steuerkurse, Zeiten und Kraftstoff zu berechnen.';

  @override
  String get navlogUnsolvable =>
      '! Der Wind ist für mindestens ein Leg bei dieser Fahrt zu stark.';

  @override
  String get navlogFootnote =>
      'Konstante Reise-TAS, ohne Steig- und Sinkflug. MH = mw. Steuerkurs mit WMM-Missweisung. Tippe auf ein Leg, um Höhe und Wind zu setzen.';

  @override
  String get kneeboardCurrentLeg => 'Aktuelles Leg';

  @override
  String get kneeboardTimes => 'Zeiten';

  @override
  String get kneeboardEditPlan => 'Planung bearbeiten';

  @override
  String get kneeboardReset => 'Zeiten zurücksetzen';

  @override
  String get kneeboardResetMessage =>
      'Alle erfassten Zeiten dieses Flugs werden gelöscht.';

  @override
  String get kneeboardClose => 'Kneeboard schließen';

  @override
  String get actionBlockOff => 'Off-Block';

  @override
  String get actionTakeoff => 'Start';

  @override
  String actionPassed(String ident) {
    return 'Über $ident';
  }

  @override
  String get actionLanding => 'Landung';

  @override
  String get actionBlockOn => 'On-Block';

  @override
  String get actionCompleted => 'Flug abgeschlossen';

  @override
  String get actionUndo => 'Rückgängig';

  @override
  String legProgress(int current, int total) {
    return 'Leg $current von $total';
  }

  @override
  String get legElapsed => 'Leg-Zeit';

  @override
  String get legRemaining => 'Verbleibend';

  @override
  String get legOverdue => 'Überfällig';

  @override
  String get phasePreflight =>
      'Bereit. Tippe „Off-Block“, wenn du losrollst – oder danach direkt „Start“.';

  @override
  String get phaseTaxiOut => 'Rollen. Tippe „Start“, wenn die Räder abheben.';

  @override
  String get phaseArrived =>
      'Alle Wegpunkte überflogen. Tippe „Landung“ beim Aufsetzen.';

  @override
  String get phaseLanded => 'Gelandet. Tippe „On-Block“, wenn du stehst.';

  @override
  String get phaseParked => 'Flug abgeschlossen.';

  @override
  String get timeBlockOff => 'Off-Block';

  @override
  String get timeTakeoff => 'Start';

  @override
  String get timeLanding => 'Landung';

  @override
  String get timeBlockOn => 'On-Block';

  @override
  String get timeFlight => 'Flugzeit';

  @override
  String get timeBlock => 'Blockzeit';

  @override
  String get stopwatch => 'Stoppuhr';

  @override
  String get stopwatchStart => 'Start';

  @override
  String get stopwatchStop => 'Stopp';

  @override
  String get stopwatchReset => 'Zurücksetzen';

  @override
  String get notesOpen => 'Notizblock';

  @override
  String get notesFlight => 'Dieser Flug';

  @override
  String get notesGeneral => 'Allgemeine Notizen';

  @override
  String get notesAddPage => 'Seite';

  @override
  String get notesClearPage => 'Seite leeren';

  @override
  String get notesDeletePage => 'Seite löschen';

  @override
  String get actionRedo => 'Wiederholen';

  @override
  String get pageBlank => 'Leer';

  @override
  String get pageGrid => 'Kariert';

  @override
  String get pageLined => 'Liniert';

  @override
  String get pageAtis => 'ATIS';

  @override
  String get pageCraft => 'Freigabe (CRAFT)';

  @override
  String get toolPen => 'Stift';

  @override
  String get toolHighlighter => 'Textmarker';

  @override
  String get toolEraser => 'Radierer';

  @override
  String get toolSize => 'Strichstärke';

  @override
  String get templateAtisInfo => 'INFORMATION  ·  ZEIT';

  @override
  String get templateAtisRunway => 'PISTE IN BETRIEB';

  @override
  String get templateAtisWind => 'WIND';

  @override
  String get templateAtisVisibility => 'SICHT';

  @override
  String get templateAtisWeather => 'WETTER';

  @override
  String get templateAtisClouds => 'WOLKEN';

  @override
  String get templateAtisTemperature => 'TEMP / TAUPUNKT';

  @override
  String get templateAtisQnh => 'QNH';

  @override
  String get templateAtisRemarks => 'BEMERKUNGEN / TREND';

  @override
  String get templateCraftClearance => 'C  Clearance limit (Freigabegrenze)';

  @override
  String get templateCraftRoute => 'R  Route (SID)';

  @override
  String get templateCraftAltitude => 'A  Altitude (Höhe)';

  @override
  String get templateCraftFrequency => 'F  Frequency (Frequenz)';

  @override
  String get templateCraftTransponder => 'T  Transponder';

  @override
  String get navE6b => 'E6B';

  @override
  String get aircraftManage => 'Flugzeuge verwalten';

  @override
  String get e6bFromFlight => 'Aus Flug';

  @override
  String get e6bClearAll => 'Alles leeren';

  @override
  String get e6bWindTriangle => 'Winddreieck';

  @override
  String get e6bFindHeading => 'Steuerkurs';

  @override
  String get e6bFindWind => 'Wind ermitteln';

  @override
  String get e6bVariation => 'Missweisung (E +)';

  @override
  String get e6bWind => 'Wind';

  @override
  String get e6bWindTooStrong => 'Wind zu stark für diese TAS';

  @override
  String get e6bWindComponents => 'Gegen- & Seitenwind';

  @override
  String get e6bRunwayOrHeading => 'Piste oder Kurs';

  @override
  String get e6bGust => 'Böen (optional)';

  @override
  String get e6bLongitudinal => 'Längs zur Piste';

  @override
  String get e6bHeadwind => 'Gegenwind';

  @override
  String get e6bTailwind => 'Rückenwind';

  @override
  String get e6bCrosswind => 'Seitenwind';

  @override
  String get e6bFromLeft => 'von links';

  @override
  String get e6bFromRight => 'von rechts';

  @override
  String get e6bSpeedTimeDistance => 'Geschwindigkeit · Zeit · Strecke';

  @override
  String get e6bTime => 'Zeit';

  @override
  String get e6bDistance => 'Strecke';

  @override
  String get e6bFuel => 'Kraftstoff';

  @override
  String get e6bFuelAmount => 'Menge';

  @override
  String get e6bEndurance => 'Flugdauer';

  @override
  String get e6bBurn => 'Verbrauch';

  @override
  String get e6bBurnPerHour => 'Verbrauch pro Stunde';

  @override
  String get e6bFuelMass => 'Masse';

  @override
  String get e6bAltitude => 'Druck- & Dichtehöhe';

  @override
  String get e6bIndicatedAltitude => 'Höhe / Platzhöhe';

  @override
  String get e6bPressureAltitude => 'Druckhöhe';

  @override
  String get e6bIsaTemp => 'ISA-Temperatur';

  @override
  String get e6bIsaDeviation => 'ISA-Abweichung';

  @override
  String get e6bDensityAltitude => 'Dichtehöhe';

  @override
  String get e6bAirspeed => 'Wahre Fahrt & Mach';

  @override
  String get e6bOatOptional => 'OAT (leer = ISA)';

  @override
  String get e6bDescent => 'Sinkflugplanung';

  @override
  String get e6bCurrentAltitude => 'Aktuelle Höhe';

  @override
  String get e6bTargetAltitude => 'Zielhöhe';

  @override
  String get e6bPathAngle => 'Sinkwinkel (leer = 3°)';

  @override
  String get e6bDistanceAvailable => 'Verfügbare Strecke (optional)';

  @override
  String get e6bTodDistance => 'Sinkflugbeginn vorher';

  @override
  String get e6bVerticalSpeed => 'Sinkrate / Steigrate';

  @override
  String get e6bRequiredVs => 'Nötig für Strecke';

  @override
  String get e6bClimbGradient => 'Steiggradient';

  @override
  String get e6bGradient => 'Gradient';

  @override
  String get e6bTurn => 'Kurven';

  @override
  String get e6bBankOptional => 'Querneigung (leer = Standardkurve)';

  @override
  String get e6bStandardRateBank => 'Querneigung Standardkurve';

  @override
  String get e6bTurnRadius => 'Radius';

  @override
  String get e6bTurnTime => '360° dauert';

  @override
  String get e6bColdTemperature => 'Kältekorrektur';

  @override
  String get e6bPublishedAltitude => 'Veröffentlichte Höhe';

  @override
  String get e6bAerodromeElevation => 'Platzhöhe';

  @override
  String get e6bAerodromeTemp => 'Temperatur am Platz';

  @override
  String get e6bCorrection => 'Korrektur';

  @override
  String get e6bCorrectedAltitude => 'Fliegen auf';

  @override
  String get e6bConverter => 'Einheitenumrechner';

  @override
  String get e6bQuantity => 'Größe';

  @override
  String get e6bValue => 'Wert';

  @override
  String get quantitySpeed => 'Geschwindigkeit';

  @override
  String get quantityDistance => 'Strecke';

  @override
  String get quantityAltitude => 'Höhe / Länge';

  @override
  String get quantityTemperature => 'Temperatur';

  @override
  String get quantityPressure => 'Druck';

  @override
  String get quantityVolume => 'Volumen';

  @override
  String get quantityMass => 'Masse';

  @override
  String get runwaysTitle => 'Erwartete Pisten';

  @override
  String get runwaysNone => 'Keine Pistendaten';

  @override
  String get runwaySuggested => 'Meister Gegenwind';

  @override
  String runwaySuggestion(String ident) {
    return 'Meister Gegenwind: $ident';
  }

  @override
  String runwayThreshold(int ft) {
    return 'Schwelle $ft ft';
  }

  @override
  String runwayPattern(int ft) {
    return 'Platzrunde $ft ft';
  }

  @override
  String get runwayTailwindWarning => 'Rückenwind – Gegenrichtung prüfen';

  @override
  String runwayCrosswindWarning(int kt) {
    return 'Seitenwind über den demonstrierten $kt kt';
  }

  @override
  String get aircraftMaxCrosswind => 'Max. demonstrierter Seitenwind';

  @override
  String get e6bSearchHint => 'Suchen: z. B. TOD, Dichte, Seitenwind';

  @override
  String get e6bNoMatch => 'Kein Rechner gefunden';

  @override
  String get e6bRecent => 'Zuletzt verwendet';

  @override
  String get e6bGroupNavigation => 'Navigation & Wind';

  @override
  String get e6bGroupFuel => 'Kraftstoff';

  @override
  String get e6bGroupAtmosphere => 'Höhe & Atmosphäre';

  @override
  String get e6bGroupClimbDescent => 'Steig- & Sinkflug';

  @override
  String get e6bGroupConversion => 'Umrechnen';

  @override
  String get e6bWindTriangleHint =>
      'Steuerkurs, Luvwinkel und Grundgeschwindigkeit – oder Wind aus Kurs und GS';

  @override
  String get e6bWindComponentsHint =>
      'Gegen-/Rückenwind und Seitenwind für eine Piste';

  @override
  String get e6bSpeedTimeDistanceHint =>
      'Zwei Werte gegeben, der dritte wird berechnet';

  @override
  String get e6bTurnHint =>
      'Querneigung für Standardkurve, Radius, Zeit für 360°';

  @override
  String get e6bFuelHint =>
      'Menge, Flugdauer oder Verbrauch – mit Masse in kg und lb';

  @override
  String get e6bAltitudeHint => 'Druck- und Dichtehöhe aus QNH und OAT';

  @override
  String get e6bAirspeedHint => 'TAS und Mach aus CAS, Höhe und Temperatur';

  @override
  String get e6bColdTemperatureHint =>
      'Höhenkorrektur bei tiefen Temperaturen (ICAO)';

  @override
  String get e6bDescentHint =>
      'Sinkflugbeginn, Sinkrate für 3° oder eine Strecke';

  @override
  String get e6bClimbHint => 'Steiggradient in ft/NM, % und Grad';

  @override
  String get e6bConverterHint =>
      'Geschwindigkeit, Strecke, Höhe, Temperatur, Druck, Volumen, Masse';

  @override
  String get flightTabWeather => 'Wetter';

  @override
  String get weatherTitle => 'Wetter';

  @override
  String get weatherRefresh => 'Aktualisieren';

  @override
  String get weatherLoading => 'Lade Wetter…';

  @override
  String weatherError(String error) {
    return 'Kein Wetter: $error';
  }

  @override
  String get weatherNone => 'Kein METAR oder TAF im Umkreis von 40 NM';

  @override
  String weatherNearby(String station, int nm) {
    return 'Nächste Meldung $station ($nm NM)';
  }

  @override
  String weatherObserved(String time, String age) {
    return 'Beobachtet $time, $age';
  }

  @override
  String weatherAgeMinutes(int minutes) {
    return 'vor $minutes min';
  }

  @override
  String weatherAgeHours(int hours) {
    return 'vor $hours h';
  }

  @override
  String weatherUseWind(String direction, int speed) {
    return 'Wind übernehmen $direction° / $speed kt';
  }

  @override
  String get weatherUseWindHint =>
      '„Wind übernehmen“ setzt den Planungswind des Flugs (rechtweisend, wie im METAR).';

  @override
  String get weatherShowTaf => 'TAF anzeigen';

  @override
  String get weatherHideTaf => 'TAF ausblenden';

  @override
  String get weatherVisibility => 'Sicht';

  @override
  String get weatherClouds => 'Wolken';

  @override
  String get weatherTemperature => 'Temp. / Taupunkt';

  @override
  String get weatherPhenomena => 'Wetter';

  @override
  String runwayWindMetar(String station) {
    return 'Wind METAR $station';
  }

  @override
  String get runwayWindPlanned => 'Planungswind';

  @override
  String get flightTabFuel => 'Kraftstoff';

  @override
  String get flightTabWb => 'Masse & Schwerpunkt';

  @override
  String get fuelPlanTitle => 'Kraftstoffplanung';

  @override
  String get fuelOnBoard => 'Kraftstoff an Bord (geplant)';

  @override
  String get fuelTaxi => 'Rollkraftstoff';

  @override
  String get fuelTrip => 'Strecke';

  @override
  String get fuelContingency => 'Zuschlag';

  @override
  String fuelContingencyRow(String percent) {
    return 'Zuschlag $percent %';
  }

  @override
  String fuelAlternateRow(String ident) {
    return 'Ausweichen nach $ident';
  }

  @override
  String get fuelAlternateNone => 'Ausweichen (keiner gewählt)';

  @override
  String get fuelFinalReserve => 'Endreserve';

  @override
  String fuelFinalReserveRow(int minutes) {
    return 'Endreserve $minutes min';
  }

  @override
  String get fuelExtra => 'Zusatzkraftstoff';

  @override
  String get fuelRequired => 'Mindestens bei Anlassen';

  @override
  String get fuelMargin => 'Überschuss';

  @override
  String get fuelAtLanding => 'Erwartet bei Landung';

  @override
  String get fuelEndurance => 'Flugdauer ab Start';

  @override
  String get fuelEnduranceLeft => 'Restflugdauer';

  @override
  String get fuelNightVfr => 'Nacht-VFR';

  @override
  String get fuelNightVfrHint => '45 min Endreserve statt 30';

  @override
  String get fuelDefaultsHint =>
      'Leere Felder nutzen die angezeigten Standardwerte: VFR 30 min Reserve (nachts 45), IFR 5 % Zuschlag, Ausweichkraftstoff und 45 min Reserve. Der Streckenkraftstoff kommt aus dem Navlog.';

  @override
  String get fuelBelowRequired =>
      'Geplanter Kraftstoff liegt unter dem Mindestbedarf.';

  @override
  String get fuelRequiredExceedsUsable =>
      'Der Mindestbedarf übersteigt den ausfliegbaren Tankinhalt – Tankstopp einplanen.';

  @override
  String get fuelOnBoardExceedsUsable =>
      'Geplanter Kraftstoff übersteigt den ausfliegbaren Tankinhalt.';

  @override
  String get wbTitle => 'Masse & Schwerpunkt';

  @override
  String get wbArmUnit => 'Einheit Hebelarm (wie im Handbuch)';

  @override
  String get wbArmInches => 'Zoll';

  @override
  String get wbArmMeters => 'Meter';

  @override
  String get wbArmMillimeters => 'Millimeter';

  @override
  String get wbEmptyArm => 'Leermassenschwerpunkt (Hebelarm)';

  @override
  String get wbStations => 'Beladestationen';

  @override
  String get wbStationName => 'Station';

  @override
  String get wbArm => 'Hebelarm';

  @override
  String get wbMaxLoad => 'Max.';

  @override
  String get wbStationKind => 'Art';

  @override
  String get wbWeight => 'Masse';

  @override
  String get wbKindSeat => 'Sitz';

  @override
  String get wbKindBaggage => 'Gepäck';

  @override
  String get wbKindFuel => 'Kraftstoff';

  @override
  String get wbKindOther => 'Sonstiges';

  @override
  String get wbAddStation => 'Station hinzufügen';

  @override
  String get wbEnvelope => 'Schwerpunktbereich';

  @override
  String get wbEnvelopeHint =>
      'Eckpunkte des Bereichs (Normalkategorie) der Reihe nach (Hebelarm, Masse).';

  @override
  String get wbAddEnvelopePoint => 'Eckpunkt hinzufügen';

  @override
  String get wbMissingData =>
      'Für Masse & Schwerpunkt braucht das Flugzeugprofil Leermasse, Leermassenschwerpunkt und Beladestationen.';

  @override
  String get wbLoading => 'Beladung';

  @override
  String get wbFuelFromPlan => 'Beim Start, aus der Kraftstoffplanung';

  @override
  String wbMax(int max, String unit) {
    return 'max. $max $unit';
  }

  @override
  String get wbResult => 'Masse und Schwerpunkt';

  @override
  String get wbZeroFuel => 'Ohne Kraftstoff';

  @override
  String get wbTakeoff => 'Start';

  @override
  String get wbLanding => 'Landung';

  @override
  String wbMtow(String weight) {
    return 'Max. Abflugmasse $weight';
  }

  @override
  String wbOverMtow(String weight) {
    return 'Über der max. Abflugmasse von $weight';
  }

  @override
  String get wbTakeoffOutside => 'Startschwerpunkt außerhalb des Bereichs';

  @override
  String get wbLandingOutside => 'Landeschwerpunkt außerhalb des Bereichs';

  @override
  String wbStationOverloaded(String station) {
    return '$station: über der Maximalzuladung';
  }

  @override
  String get wbNoEnvelope => 'Kein Schwerpunktbereich im Flugzeugprofil.';

  @override
  String get chartsTitle => 'Karten';

  @override
  String get chartsImport => 'Importieren';

  @override
  String get chartsNone => 'Keine Karten';

  @override
  String get chartsNoneHint =>
      'Noch keine Karten. Importiere PDFs oder Bilder, z. B. aus dem AIP.';

  @override
  String chartsImported(int count, int total) {
    return '$count von $total Karten importiert';
  }

  @override
  String chartsImportTitle(int count) {
    return 'Karten importieren ($count)';
  }

  @override
  String get chartAirport => 'Flugplatz';

  @override
  String get chartCategory => 'Kategorie';

  @override
  String get chartCategoryAirport => 'Flugplatzkarte';

  @override
  String get chartCategoryGround => 'Rollen & Parken';

  @override
  String get chartCategoryDeparture => 'Abflug (SID)';

  @override
  String get chartCategoryArrival => 'Anflugstrecke (STAR)';

  @override
  String get chartCategoryApproach => 'Anflug';

  @override
  String get chartCategoryVfr => 'Sichtanflugkarte';

  @override
  String get chartCategoryOther => 'Sonstige';

  @override
  String get chartName => 'Name';

  @override
  String get chartImage => 'Bild';

  @override
  String get chartEdit => 'Karte bearbeiten';

  @override
  String get chartDeleteTitle => 'Karte löschen?';

  @override
  String chartDeleteMessage(String name) {
    return '„$name“ und die Notizen darauf werden gelöscht.';
  }

  @override
  String get chartFit => 'An Bildschirm anpassen';

  @override
  String get chartClearInk => 'Notizen auf dieser Seite löschen';

  @override
  String get chartInkTools => 'Stiftwerkzeuge';

  @override
  String get chartNightMode => 'Nachtmodus';

  @override
  String get chartNotFound => 'Diese Karte gibt es nicht mehr.';

  @override
  String get chartUnreadable => 'Die Kartendatei lässt sich nicht öffnen.';

  @override
  String chartPage(int page, int count) {
    return 'Seite $page von $count';
  }

  @override
  String get chartPreviousPage => 'Vorherige Seite';

  @override
  String get chartNextPage => 'Nächste Seite';

  @override
  String get simStatusOff => 'Nicht verbunden';

  @override
  String get simStatusConnecting => 'Verbinde …';

  @override
  String get simStatusWaitingForFlight => 'Warte auf einen Flug in X-Plane';

  @override
  String get simStatusConnected => 'Verbunden';

  @override
  String get simStatusUnreachable => 'Nicht erreichbar, neuer Versuch läuft';

  @override
  String get simUnreachableHint =>
      'X-Plane nimmt Verbindungen bisher nur vom eigenen PC an. Damit das Tablet es erreicht, muss auf dem PC eine Weiterleitung laufen (z. B. socat von Port 8087 auf 127.0.0.1:8086) und die Firewall diesen Port im Heimnetz freigeben. Prüfe außerdem, ob X-Plane läuft und IP-Adresse und Port stimmen.';

  @override
  String get simNoHostHint =>
      'Trage in den Einstellungen die IP-Adresse des X-Plane-PCs ein.';

  @override
  String get simLive => 'Live-Verbindung';

  @override
  String get simLiveHint =>
      'Automatisch mit X-Plane verbinden und nach einem Neustart neu verbinden.';

  @override
  String get simAutomation => 'Zeiten und Wegpunkte automatisch';

  @override
  String get simAutomationHint =>
      'X-Plane erfasst Block- und Flugzeiten, schaltet Wegpunkte weiter und misst das Aufsetzen.';

  @override
  String get simAutomationActive => 'X-Plane erfasst das automatisch';

  @override
  String get simRetry => 'Jetzt neu versuchen';

  @override
  String get simOpenSettings => 'Einstellungen';

  @override
  String get simRadios => 'Funkgeräte';

  @override
  String simSwap(String radio) {
    return '$radio tauschen';
  }

  @override
  String simStandby(String radio) {
    return '$radio Standby';
  }

  @override
  String simActive(String radio) {
    return '$radio aktiv';
  }

  @override
  String simTuneTooltip(String frequency) {
    return '$frequency rasten';
  }

  @override
  String simTunedStandby(String radio, String frequency) {
    return '$radio Standby auf $frequency';
  }

  @override
  String simTunedActive(String radio, String frequency) {
    return '$radio auf $frequency';
  }

  @override
  String get simLeft => 'L';

  @override
  String get simRight => 'R';

  @override
  String get logbookFlights => 'Flüge';

  @override
  String get logbookLandings => 'Landungen';

  @override
  String get logbookDistance => 'Strecke';

  @override
  String get logbookTouchdownG => 'Last beim Aufsetzen';

  @override
  String get logbookRemarks => 'Bemerkungen';

  @override
  String logbookBlockShort(String time) {
    return 'Block $time';
  }

  @override
  String get logbookDeleteTitle => 'Flugbucheintrag löschen?';

  @override
  String get logbookDeleteMessage =>
      'Der Flugplan bleibt erhalten, nur diese Zeile im Flugbuch wird gelöscht.';

  @override
  String get touchdownButter => 'Butterweich';

  @override
  String get touchdownSmooth => 'Sanft';

  @override
  String get touchdownFirm => 'Fest';

  @override
  String get touchdownHard => 'Hart';

  @override
  String get touchdownInspect => 'Fahrwerk prüfen';

  @override
  String get wbArmHint =>
      'Der Hebelarm ist der Abstand von der Bezugsebene des Flughandbuchs (englisch „Datum“, meist am Brandschott oder an der Propellernabe) bis zum Schwerpunkt einer Last. Gewicht × Hebelarm = Moment; alle Momente geteilt durch das Gesamtgewicht ergeben den Schwerpunkt. Die Werte stehen im Abschnitt Masse und Schwerpunkt (Weight & Balance) des Handbuchs, in dessen Einheit: US-Handbücher (Cessna, Piper, Cirrus) nutzen Zoll, europäische Meter oder Millimeter.';
}
