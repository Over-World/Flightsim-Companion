// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flightsim Companion';

  @override
  String get navPlan => 'Plan';

  @override
  String get navFly => 'Fly';

  @override
  String get navAircraft => 'Aircraft';

  @override
  String get navLogbook => 'Logbook';

  @override
  String get navSettings => 'Settings';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get fieldRequired => 'Required';

  @override
  String get fieldInvalidNumber => 'Enter a positive number';

  @override
  String get navdataMissingTitle => 'No navigation data yet';

  @override
  String get navdataMissingMessage =>
      'Download airports, runways, frequencies and navaids once to use the app offline.';

  @override
  String get navdataMissingAction => 'Download';

  @override
  String get flightsEmptyTitle => 'No flights planned';

  @override
  String get flyNoActiveFlightTitle => 'No active flight';

  @override
  String get flyNoActiveFlightMessage =>
      'Start a planned flight to open the kneeboard with navlog, stopwatch and frequencies.';

  @override
  String get logbookEmptyTitle => 'Logbook is empty';

  @override
  String get logbookEmptyMessage =>
      'Completed flights are logged here with times and landing ratings.';

  @override
  String get airportSearchTitle => 'Find airport';

  @override
  String get airportSearchHint => 'ICAO, IATA, name or city';

  @override
  String airportSearchNoResults(String query) {
    return 'No airport found for \"$query\"';
  }

  @override
  String get airportTypeLarge => 'Large airport';

  @override
  String get airportTypeMedium => 'Medium airport';

  @override
  String get airportTypeSmall => 'Small airfield';

  @override
  String get airportTypeHeliport => 'Heliport';

  @override
  String get airportTypeSeaplane => 'Seaplane base';

  @override
  String elevationFt(int ft) {
    return '$ft ft';
  }

  @override
  String get frequencies => 'Frequencies';

  @override
  String get noFrequencies => 'No frequencies known';

  @override
  String get runways => 'Runways';

  @override
  String get noRunways => 'No runways known';

  @override
  String runwayDimensions(int lengthFt, int lengthM, int widthFt) {
    return '$lengthFt ft ($lengthM m) × $widthFt ft';
  }

  @override
  String get runwayLighted => 'lighted';

  @override
  String get navaidsNearby => 'Navaids nearby';

  @override
  String get noNavaids => 'No navaids within 40 NM';

  @override
  String radialDistance(String radial, String distance) {
    return 'Airport on R$radial · $distance NM';
  }

  @override
  String get aircraftAdd => 'Add aircraft';

  @override
  String get aircraftEdit => 'Edit aircraft';

  @override
  String get aircraftEmpty => 'No aircraft profiles';

  @override
  String aircraftSummary(int tas, String burn, String unit) {
    return '$tas kt TAS · $burn $unit/h';
  }

  @override
  String get aircraftDeleteTitle => 'Delete aircraft?';

  @override
  String aircraftDeleteMessage(String name) {
    return '\"$name\" will be removed permanently.';
  }

  @override
  String get aircraftSectionGeneral => 'General';

  @override
  String get aircraftName => 'Name';

  @override
  String get aircraftIcaoType => 'ICAO type';

  @override
  String get aircraftRegistration => 'Registration';

  @override
  String get aircraftSectionPerformance => 'Performance';

  @override
  String get aircraftCruiseTas => 'Cruise TAS';

  @override
  String get aircraftClimbTas => 'Climb TAS';

  @override
  String get aircraftClimbRate => 'Climb rate';

  @override
  String get aircraftDescentRate => 'Descent rate';

  @override
  String get aircraftSectionFuel => 'Fuel';

  @override
  String get aircraftFuelBurn => 'Fuel burn (cruise)';

  @override
  String get aircraftUsableFuel => 'Usable fuel';

  @override
  String get aircraftFuelType => 'Fuel type';

  @override
  String get aircraftSectionWeights => 'Weights';

  @override
  String get aircraftEmptyWeight => 'Empty weight';

  @override
  String get aircraftMtow => 'Max. takeoff weight';

  @override
  String get aircraftNotes => 'Notes';

  @override
  String get aircraftNotesHint => 'V-speeds, procedures, peculiarities…';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsAccent => 'Accent color';

  @override
  String get settingsUnits => 'Units';

  @override
  String get settingsFuelUnit => 'Fuel';

  @override
  String get unitLiters => 'Litres';

  @override
  String get unitUsGallons => 'US gallons';

  @override
  String get settingsWeightUnit => 'Weight';

  @override
  String get unitKilograms => 'Kilograms';

  @override
  String get unitPounds => 'Pounds';

  @override
  String get settingsSimulator => 'Simulator';

  @override
  String get settingsXplaneHint =>
      'X-Plane 12: enter the IP address of the PC running the simulator. The app connects to X-Plane\'s web API on your local network.';

  @override
  String get settingsSimHost => 'X-Plane PC (IP or hostname)';

  @override
  String get settingsSimPort => 'Port';

  @override
  String get settingsNavdata => 'Navigation data';

  @override
  String get navdataNeverImported => 'Not downloaded yet';

  @override
  String navdataImportedAt(String date) {
    return 'Last updated $date';
  }

  @override
  String navdataCounts(
    String airports,
    String runways,
    String frequencies,
    String navaids,
  ) {
    return '$airports airports · $runways runways · $frequencies frequencies · $navaids navaids';
  }

  @override
  String navdataImportFailed(String error) {
    return 'Download failed: $error';
  }

  @override
  String get navdataSource =>
      'Source: OurAirports (public domain), worldwide, about 20 MB.';

  @override
  String get navdataDownload => 'Download';

  @override
  String get navdataUpdate => 'Update';

  @override
  String navdataStageDownloading(String file) {
    return 'Downloading $file…';
  }

  @override
  String get navdataStageParsing => 'Processing data…';

  @override
  String get navdataStageWriting => 'Saving to database…';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get settingsHomeAirport => 'Home airport';

  @override
  String get settingsDefaultAircraft => 'Default aircraft';

  @override
  String get settingsAccounts => 'Accounts';

  @override
  String get settingsSimbriefUser => 'SimBrief username or pilot ID';

  @override
  String get settingsSimbriefHint =>
      'Used to import your latest OFP for IFR flights.';

  @override
  String get settingsNotes => 'Notes';

  @override
  String get settingsFingerDrawing => 'Draw with finger';

  @override
  String get settingsFingerDrawingHint =>
      'When off, only a stylus draws and a finger just scrolls.';

  @override
  String get settingsRestartOnboarding => 'Run setup again';

  @override
  String get xplaneTest => 'Test connection';

  @override
  String get xplaneTesting => 'Connecting…';

  @override
  String xplaneConnected(String version) {
    return 'Connected to X-Plane $version';
  }

  @override
  String xplaneConnectionFailed(String error) {
    return 'No connection: $error';
  }

  @override
  String onboardingStep(int current, int total) {
    return '$current / $total';
  }

  @override
  String get onboardingFinish => 'Let\'s fly';

  @override
  String get onboardingWelcomeTitle => 'Welcome aboard';

  @override
  String get onboardingWelcomeText =>
      'Flightsim Companion is your kneeboard for X-Plane and MSFS: plan VFR and IFR flights, fly them with navlog, stopwatch and frequencies, and keep notes like on real paper. A few quick steps and you\'re ready.';

  @override
  String get onboardingNavdataTitle => 'Navigation data';

  @override
  String get onboardingNavdataText =>
      'Airports, runways, frequencies and navaids worldwide. Downloaded once, then everything works offline.';

  @override
  String get onboardingSimTitle => 'Connect X-Plane';

  @override
  String get onboardingSimText =>
      'Optional. Enter the IP address of the PC running X-Plane 12 – both devices must be on the same network. You can skip this and fly without a live connection.';

  @override
  String get onboardingAccountsTitle => 'Accounts';

  @override
  String get onboardingAccountsText =>
      'Optional. With your SimBrief username the app can import your latest flight plan later.';

  @override
  String get onboardingHomeTitle => 'Home base';

  @override
  String get onboardingHomeText =>
      'Your home airport is suggested as departure for new flights, your default aircraft is preselected.';

  @override
  String get onboardingHomeNeedsNavdata =>
      'Download the navigation data first to pick a home airport – you can set it later in the settings.';

  @override
  String get flightsEmptyMessage =>
      'Plan your first VFR or IFR flight: departure, destination, waypoints – the navlog is calculated for you.';

  @override
  String get flightNew => 'New flight';

  @override
  String get flightCreate => 'Create';

  @override
  String get flightEdit => 'Flight data';

  @override
  String get flightTitle => 'Title';

  @override
  String get flightDeparture => 'Departure';

  @override
  String get flightDestination => 'Destination';

  @override
  String get flightAlternate => 'Alternate';

  @override
  String flightAlternateShort(String ident) {
    return 'Altn $ident';
  }

  @override
  String get flightAircraft => 'Aircraft';

  @override
  String get flightCruiseAltitude => 'Cruise altitude';

  @override
  String get flightPlannedDeparture => 'Planned departure (off-block)';

  @override
  String get flightWindHint =>
      'Wind for all legs without their own wind (true direction, from).';

  @override
  String get flightNoAircraft => 'No aircraft selected';

  @override
  String get flightChooseAircraft => 'Choose aircraft';

  @override
  String get flightFly => 'Fly';

  @override
  String get flightTabRoute => 'Route';

  @override
  String get flightTabNavlog => 'Navlog';

  @override
  String get flightStatusPlanned => 'Planned';

  @override
  String get flightStatusActive => 'In flight';

  @override
  String get flightStatusCompleted => 'Completed';

  @override
  String get flightDeleteTitle => 'Delete flight?';

  @override
  String flightDeleteMessage(String title) {
    return '\"$title\" and all its notes will be removed permanently.';
  }

  @override
  String get windDirection => 'Wind from';

  @override
  String get windSpeed => 'Wind speed';

  @override
  String legTo(String ident) {
    return 'Leg to $ident';
  }

  @override
  String get legEdit => 'Edit leg';

  @override
  String get legAltitude => 'Altitude';

  @override
  String get legWindHint => 'Leave empty to use the flight\'s wind.';

  @override
  String get legNotes => 'Notes for this leg';

  @override
  String get waypointAdd => 'Add waypoint';

  @override
  String get waypointTabSearch => 'Search';

  @override
  String get waypointTabRadial => 'Radial/DME';

  @override
  String get waypointTabCoordinates => 'Coordinates';

  @override
  String get waypointSearchHint => 'Navaid or airport: ident or name';

  @override
  String get waypointNavaidIdent => 'Navaid ident (e.g. FFM)';

  @override
  String get waypointRadial => 'Radial';

  @override
  String get waypointDistance => 'Distance';

  @override
  String get waypointName => 'Name';

  @override
  String get waypointNameHint =>
      'e.g. lake, motorway junction, reporting point';

  @override
  String get waypointLatitude => 'Latitude';

  @override
  String get waypointLongitude => 'Longitude';

  @override
  String get waypointCoordinatesHint =>
      'Decimal degrees, south and west negative.';

  @override
  String get navlogWaypoint => 'To';

  @override
  String get navlogWind => 'Wind';

  @override
  String get navlogCalm => 'calm';

  @override
  String get navlogTotal => 'Total';

  @override
  String get navlogDistance => 'Distance';

  @override
  String get navlogTime => 'Flight time';

  @override
  String get navlogFuel => 'Trip fuel';

  @override
  String get navlogNeedsAircraft =>
      'Choose an aircraft to calculate headings, times and fuel.';

  @override
  String get navlogUnsolvable =>
      '! The wind is too strong for at least one leg at this airspeed.';

  @override
  String get navlogFootnote =>
      'Constant cruise TAS, no climb or descent. MH = magnetic heading with WMM variation. Tap a leg to set its altitude and wind.';

  @override
  String get kneeboardCurrentLeg => 'Current leg';

  @override
  String get kneeboardTimes => 'Times';

  @override
  String get kneeboardEditPlan => 'Edit plan';

  @override
  String get kneeboardReset => 'Reset times';

  @override
  String get kneeboardResetMessage =>
      'All recorded times of this flight are cleared.';

  @override
  String get kneeboardClose => 'Close kneeboard';

  @override
  String get actionBlockOff => 'Off block';

  @override
  String get actionTakeoff => 'Takeoff';

  @override
  String actionPassed(String ident) {
    return 'Over $ident';
  }

  @override
  String get actionLanding => 'Landing';

  @override
  String get actionBlockOn => 'On block';

  @override
  String get actionCompleted => 'Flight completed';

  @override
  String get actionUndo => 'Undo';

  @override
  String legProgress(int current, int total) {
    return 'Leg $current of $total';
  }

  @override
  String get legElapsed => 'Leg time';

  @override
  String get legRemaining => 'Remaining';

  @override
  String get legOverdue => 'Overdue';

  @override
  String get phasePreflight =>
      'Ready. Tap \"Off block\" when you start taxiing – or directly \"Takeoff\" after it.';

  @override
  String get phaseTaxiOut =>
      'Taxiing. Tap \"Takeoff\" when the wheels leave the ground.';

  @override
  String get phaseArrived =>
      'All waypoints passed. Tap \"Landing\" at touchdown.';

  @override
  String get phaseLanded => 'Landed. Tap \"On block\" when parked.';

  @override
  String get phaseParked => 'Flight completed.';

  @override
  String get timeBlockOff => 'Off block';

  @override
  String get timeTakeoff => 'Takeoff';

  @override
  String get timeLanding => 'Landing';

  @override
  String get timeBlockOn => 'On block';

  @override
  String get timeFlight => 'Flight time';

  @override
  String get timeBlock => 'Block time';

  @override
  String get stopwatch => 'Stopwatch';

  @override
  String get stopwatchStart => 'Start';

  @override
  String get stopwatchStop => 'Stop';

  @override
  String get stopwatchReset => 'Reset';
}
