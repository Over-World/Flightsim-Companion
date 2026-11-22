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

  @override
  String get notesOpen => 'Notepad';

  @override
  String get notesFlight => 'This flight';

  @override
  String get notesGeneral => 'General notes';

  @override
  String get notesAddPage => 'Page';

  @override
  String get notesClearPage => 'Clear page';

  @override
  String get notesDeletePage => 'Delete page';

  @override
  String get actionRedo => 'Redo';

  @override
  String get pageBlank => 'Blank';

  @override
  String get pageGrid => 'Grid';

  @override
  String get pageLined => 'Lined';

  @override
  String get pageAtis => 'ATIS';

  @override
  String get pageCraft => 'Clearance (CRAFT)';

  @override
  String get toolPen => 'Pen';

  @override
  String get toolHighlighter => 'Highlighter';

  @override
  String get toolEraser => 'Eraser';

  @override
  String get toolSize => 'Line width';

  @override
  String get templateAtisInfo => 'INFORMATION  ·  TIME';

  @override
  String get templateAtisRunway => 'RWY IN USE';

  @override
  String get templateAtisWind => 'WIND';

  @override
  String get templateAtisVisibility => 'VISIBILITY';

  @override
  String get templateAtisWeather => 'WEATHER';

  @override
  String get templateAtisClouds => 'CLOUDS';

  @override
  String get templateAtisTemperature => 'TEMP / DEW POINT';

  @override
  String get templateAtisQnh => 'QNH';

  @override
  String get templateAtisRemarks => 'REMARKS / TREND';

  @override
  String get templateCraftClearance => 'C  Clearance limit';

  @override
  String get templateCraftRoute => 'R  Route (SID)';

  @override
  String get templateCraftAltitude => 'A  Altitude';

  @override
  String get templateCraftFrequency => 'F  Frequency';

  @override
  String get templateCraftTransponder => 'T  Transponder';

  @override
  String get navE6b => 'E6B';

  @override
  String get aircraftManage => 'Manage aircraft';

  @override
  String get e6bFromFlight => 'From flight';

  @override
  String get e6bClearAll => 'Clear all';

  @override
  String get e6bWindTriangle => 'Wind triangle';

  @override
  String get e6bFindHeading => 'Find heading';

  @override
  String get e6bFindWind => 'Find wind';

  @override
  String get e6bVariation => 'Variation (E +)';

  @override
  String get e6bWind => 'Wind';

  @override
  String get e6bWindTooStrong => 'Wind too strong for this TAS';

  @override
  String get e6bWindComponents => 'Headwind & crosswind';

  @override
  String get e6bRunwayOrHeading => 'Runway or heading';

  @override
  String get e6bGust => 'Gusts (optional)';

  @override
  String get e6bLongitudinal => 'Along the runway';

  @override
  String get e6bHeadwind => 'headwind';

  @override
  String get e6bTailwind => 'tailwind';

  @override
  String get e6bCrosswind => 'Crosswind';

  @override
  String get e6bFromLeft => 'from left';

  @override
  String get e6bFromRight => 'from right';

  @override
  String get e6bSpeedTimeDistance => 'Speed · time · distance';

  @override
  String get e6bTime => 'Time';

  @override
  String get e6bDistance => 'Distance';

  @override
  String get e6bFuel => 'Fuel';

  @override
  String get e6bFuelAmount => 'Amount';

  @override
  String get e6bEndurance => 'Endurance';

  @override
  String get e6bBurn => 'Burn';

  @override
  String get e6bBurnPerHour => 'Burn per hour';

  @override
  String get e6bFuelMass => 'Mass';

  @override
  String get e6bAltitude => 'Pressure & density altitude';

  @override
  String get e6bIndicatedAltitude => 'Altitude / elevation';

  @override
  String get e6bPressureAltitude => 'Pressure altitude';

  @override
  String get e6bIsaTemp => 'ISA temperature';

  @override
  String get e6bIsaDeviation => 'ISA deviation';

  @override
  String get e6bDensityAltitude => 'Density altitude';

  @override
  String get e6bAirspeed => 'True airspeed & Mach';

  @override
  String get e6bOatOptional => 'OAT (empty = ISA)';

  @override
  String get e6bDescent => 'Descent planning';

  @override
  String get e6bCurrentAltitude => 'Current altitude';

  @override
  String get e6bTargetAltitude => 'Target altitude';

  @override
  String get e6bPathAngle => 'Descent angle (3° if empty)';

  @override
  String get e6bDistanceAvailable => 'Distance available (optional)';

  @override
  String get e6bTodDistance => 'Top of descent before';

  @override
  String get e6bVerticalSpeed => 'Vertical speed';

  @override
  String get e6bRequiredVs => 'Required for distance';

  @override
  String get e6bClimbGradient => 'Climb gradient';

  @override
  String get e6bGradient => 'Gradient';

  @override
  String get e6bTurn => 'Turns';

  @override
  String get e6bBankOptional => 'Bank (empty = standard rate)';

  @override
  String get e6bStandardRateBank => 'Bank for rate one';

  @override
  String get e6bTurnRadius => 'Radius';

  @override
  String get e6bTurnTime => '360° takes';

  @override
  String get e6bColdTemperature => 'Cold temperature correction';

  @override
  String get e6bPublishedAltitude => 'Published altitude';

  @override
  String get e6bAerodromeElevation => 'Aerodrome elevation';

  @override
  String get e6bAerodromeTemp => 'Aerodrome temperature';

  @override
  String get e6bCorrection => 'Correction';

  @override
  String get e6bCorrectedAltitude => 'Fly at';

  @override
  String get e6bConverter => 'Unit converter';

  @override
  String get e6bQuantity => 'Quantity';

  @override
  String get e6bValue => 'Value';

  @override
  String get quantitySpeed => 'Speed';

  @override
  String get quantityDistance => 'Distance';

  @override
  String get quantityAltitude => 'Altitude / length';

  @override
  String get quantityTemperature => 'Temperature';

  @override
  String get quantityPressure => 'Pressure';

  @override
  String get quantityVolume => 'Volume';

  @override
  String get quantityMass => 'Mass';

  @override
  String get runwaysTitle => 'Expected runways';

  @override
  String get runwaysNone => 'No runway data';

  @override
  String get runwaySuggested => 'Most headwind';

  @override
  String runwaySuggestion(String ident) {
    return 'Most headwind: $ident';
  }

  @override
  String runwayThreshold(int ft) {
    return 'Threshold $ft ft';
  }

  @override
  String runwayPattern(int ft) {
    return 'Pattern $ft ft';
  }

  @override
  String get runwayTailwindWarning => 'Tailwind – check the other direction';

  @override
  String runwayCrosswindWarning(int kt) {
    return 'Crosswind above the demonstrated $kt kt';
  }

  @override
  String get aircraftMaxCrosswind => 'Max. demonstrated crosswind';

  @override
  String get e6bSearchHint => 'Search: e.g. TOD, density, crosswind';

  @override
  String get e6bNoMatch => 'No calculator found';

  @override
  String get e6bRecent => 'Recently used';

  @override
  String get e6bGroupNavigation => 'Navigation & wind';

  @override
  String get e6bGroupFuel => 'Fuel';

  @override
  String get e6bGroupAtmosphere => 'Altitude & atmosphere';

  @override
  String get e6bGroupClimbDescent => 'Climb & descent';

  @override
  String get e6bGroupConversion => 'Conversions';

  @override
  String get e6bWindTriangleHint =>
      'Heading, WCA and ground speed – or the wind from heading and GS';

  @override
  String get e6bWindComponentsHint =>
      'Headwind/tailwind and crosswind for a runway';

  @override
  String get e6bSpeedTimeDistanceHint => 'Two given, the third calculated';

  @override
  String get e6bTurnHint =>
      'Bank for a standard rate turn, radius, time for 360°';

  @override
  String get e6bFuelHint =>
      'Amount, endurance or burn – with mass in kg and lb';

  @override
  String get e6bAltitudeHint =>
      'Pressure and density altitude from QNH and OAT';

  @override
  String get e6bAirspeedHint =>
      'TAS and Mach from CAS, altitude and temperature';

  @override
  String get e6bColdTemperatureHint =>
      'Altitude correction at low temperatures (ICAO)';

  @override
  String get e6bDescentHint =>
      'Top of descent, vertical speed for 3° or a distance';

  @override
  String get e6bClimbHint => 'Climb gradient in ft/NM, % and degrees';

  @override
  String get e6bConverterHint =>
      'Speed, distance, altitude, temperature, pressure, volume, mass';

  @override
  String get flightTabWeather => 'Weather';

  @override
  String get weatherTitle => 'Weather';

  @override
  String get weatherRefresh => 'Refresh';

  @override
  String get weatherLoading => 'Loading weather…';

  @override
  String weatherError(String error) {
    return 'No weather: $error';
  }

  @override
  String get weatherNone => 'No METAR or TAF within 40 NM';

  @override
  String weatherNearby(String station, int nm) {
    return 'Nearest report $station ($nm NM)';
  }

  @override
  String weatherObserved(String time, String age) {
    return 'Observed $time, $age';
  }

  @override
  String weatherAgeMinutes(int minutes) {
    return '$minutes min ago';
  }

  @override
  String weatherAgeHours(int hours) {
    return '$hours h ago';
  }

  @override
  String weatherUseWind(String direction, int speed) {
    return 'Use wind $direction° / $speed kt';
  }

  @override
  String get weatherUseWindHint =>
      '\"Use wind\" sets the flight\'s planning wind (true direction, as in the METAR).';

  @override
  String get weatherShowTaf => 'Show TAF';

  @override
  String get weatherHideTaf => 'Hide TAF';

  @override
  String get weatherVisibility => 'Visibility';

  @override
  String get weatherClouds => 'Clouds';

  @override
  String get weatherTemperature => 'Temp / dew point';

  @override
  String get weatherPhenomena => 'Weather';

  @override
  String runwayWindMetar(String station) {
    return 'Wind METAR $station';
  }

  @override
  String get runwayWindPlanned => 'Planning wind';

  @override
  String get flightTabFuel => 'Fuel';

  @override
  String get flightTabWb => 'W&B';

  @override
  String get fuelPlanTitle => 'Fuel plan';

  @override
  String get fuelOnBoard => 'Fuel on board (planned)';

  @override
  String get fuelTaxi => 'Taxi fuel';

  @override
  String get fuelTrip => 'Trip';

  @override
  String get fuelContingency => 'Contingency';

  @override
  String fuelContingencyRow(String percent) {
    return 'Contingency $percent %';
  }

  @override
  String fuelAlternateRow(String ident) {
    return 'Alternate to $ident';
  }

  @override
  String get fuelAlternateNone => 'Alternate (none set)';

  @override
  String get fuelFinalReserve => 'Final reserve';

  @override
  String fuelFinalReserveRow(int minutes) {
    return 'Final reserve $minutes min';
  }

  @override
  String get fuelExtra => 'Extra fuel';

  @override
  String get fuelRequired => 'Required at engine start';

  @override
  String get fuelMargin => 'Margin';

  @override
  String get fuelAtLanding => 'Expected on landing';

  @override
  String get fuelEndurance => 'Endurance from takeoff';

  @override
  String get fuelEnduranceLeft => 'Endurance';

  @override
  String get fuelNightVfr => 'Night VFR';

  @override
  String get fuelNightVfrHint => '45 min final reserve instead of 30';

  @override
  String get fuelDefaultsHint =>
      'Empty fields use the defaults shown: VFR 30 min reserve (night 45), IFR 5 % contingency, alternate fuel and 45 min reserve. Trip fuel comes from the navlog.';

  @override
  String get fuelBelowRequired => 'Planned fuel is below the required minimum.';

  @override
  String get fuelRequiredExceedsUsable =>
      'The required fuel exceeds the usable tank capacity – plan a fuel stop.';

  @override
  String get fuelOnBoardExceedsUsable =>
      'Planned fuel exceeds the usable tank capacity.';

  @override
  String get wbTitle => 'Weight & balance';

  @override
  String get wbArmUnit => 'Arm unit (as in the POH)';

  @override
  String get wbArmInches => 'Inches';

  @override
  String get wbArmMeters => 'Metres';

  @override
  String get wbArmMillimeters => 'Millimetres';

  @override
  String get wbEmptyArm => 'Empty weight CG (arm)';

  @override
  String get wbStations => 'Loading stations';

  @override
  String get wbStationName => 'Station';

  @override
  String get wbArm => 'Arm';

  @override
  String get wbMaxLoad => 'Max.';

  @override
  String get wbStationKind => 'Type';

  @override
  String get wbWeight => 'Weight';

  @override
  String get wbKindSeat => 'Seat';

  @override
  String get wbKindBaggage => 'Baggage';

  @override
  String get wbKindFuel => 'Fuel';

  @override
  String get wbKindOther => 'Other';

  @override
  String get wbAddStation => 'Add station';

  @override
  String get wbEnvelope => 'CG envelope';

  @override
  String get wbEnvelopeHint =>
      'Corners of the normal category envelope in order (arm, weight).';

  @override
  String get wbAddEnvelopePoint => 'Add corner';

  @override
  String get wbMissingData =>
      'Weight & balance needs the empty weight, empty CG and loading stations in the aircraft profile.';

  @override
  String get wbLoading => 'Loading';

  @override
  String get wbFuelFromPlan => 'At takeoff, from the fuel plan';

  @override
  String wbMax(int max, String unit) {
    return 'max. $max $unit';
  }

  @override
  String get wbResult => 'Mass and CG';

  @override
  String get wbZeroFuel => 'Zero fuel';

  @override
  String get wbTakeoff => 'Takeoff';

  @override
  String get wbLanding => 'Landing';

  @override
  String wbMtow(String weight) {
    return 'Max. takeoff weight $weight';
  }

  @override
  String wbOverMtow(String weight) {
    return 'Above the max. takeoff weight of $weight';
  }

  @override
  String get wbTakeoffOutside => 'Takeoff CG outside the envelope';

  @override
  String get wbLandingOutside => 'Landing CG outside the envelope';

  @override
  String wbStationOverloaded(String station) {
    return '$station: above the maximum load';
  }

  @override
  String get wbNoEnvelope => 'No envelope in the aircraft profile.';

  @override
  String get chartsTitle => 'Charts';

  @override
  String get chartsImport => 'Import';

  @override
  String get chartsNone => 'No charts';

  @override
  String get chartsNoneHint =>
      'No charts yet. Import PDFs or images, e.g. from the AIP.';

  @override
  String chartsImported(int count, int total) {
    return '$count of $total charts imported';
  }

  @override
  String chartsImportTitle(int count) {
    return 'Import charts ($count)';
  }

  @override
  String get chartAirport => 'Airport';

  @override
  String get chartCategory => 'Category';

  @override
  String get chartCategoryAirport => 'Aerodrome chart';

  @override
  String get chartCategoryGround => 'Ground & parking';

  @override
  String get chartCategoryDeparture => 'Departure (SID)';

  @override
  String get chartCategoryArrival => 'Arrival (STAR)';

  @override
  String get chartCategoryApproach => 'Approach';

  @override
  String get chartCategoryVfr => 'VFR chart';

  @override
  String get chartCategoryOther => 'Other';

  @override
  String get chartName => 'Name';

  @override
  String get chartImage => 'Image';

  @override
  String get chartEdit => 'Edit chart';

  @override
  String get chartDeleteTitle => 'Delete chart?';

  @override
  String chartDeleteMessage(String name) {
    return '\"$name\" and the ink drawn on it will be deleted.';
  }

  @override
  String get chartFit => 'Fit to screen';

  @override
  String get chartClearInk => 'Clear ink on this page';

  @override
  String get chartInkTools => 'Pen tools';

  @override
  String get chartNightMode => 'Night mode';

  @override
  String get chartNotFound => 'This chart no longer exists.';

  @override
  String get chartUnreadable => 'The chart file can\'t be opened.';

  @override
  String chartPage(int page, int count) {
    return 'Page $page of $count';
  }

  @override
  String get chartPreviousPage => 'Previous page';

  @override
  String get chartNextPage => 'Next page';

  @override
  String get simStatusOff => 'Not connected';

  @override
  String get simStatusConnecting => 'Connecting…';

  @override
  String get simStatusWaitingForFlight => 'Waiting for a flight in X-Plane';

  @override
  String get simStatusConnected => 'Connected';

  @override
  String get simStatusUnreachable => 'Not reachable, retrying';

  @override
  String get simUnreachableHint =>
      'Check that X-Plane is running, the IP address and port are right, and that the X-Plane web server accepts connections from the network.';

  @override
  String get simNoHostHint =>
      'Enter the IP address of the X-Plane PC in the settings.';

  @override
  String get simLive => 'Live connection';

  @override
  String get simLiveHint =>
      'Connect to X-Plane automatically and reconnect when it restarts.';

  @override
  String get simAutomation => 'Automatic times and waypoints';

  @override
  String get simAutomationHint =>
      'X-Plane records block and flight times, passes waypoints and measures the touchdown.';

  @override
  String get simAutomationActive => 'X-Plane records this automatically';

  @override
  String get simRetry => 'Retry now';

  @override
  String get simOpenSettings => 'Settings';

  @override
  String get simRadios => 'Radios';

  @override
  String simSwap(String radio) {
    return 'Swap $radio';
  }

  @override
  String simStandby(String radio) {
    return '$radio standby';
  }

  @override
  String simActive(String radio) {
    return '$radio active';
  }

  @override
  String simTuneTooltip(String frequency) {
    return 'Tune $frequency';
  }

  @override
  String simTunedStandby(String radio, String frequency) {
    return '$radio standby set to $frequency';
  }

  @override
  String simTunedActive(String radio, String frequency) {
    return '$radio set to $frequency';
  }

  @override
  String get simLeft => 'L';

  @override
  String get simRight => 'R';

  @override
  String get logbookFlights => 'Flights';

  @override
  String get logbookLandings => 'Landings';

  @override
  String get logbookDistance => 'Distance';

  @override
  String get logbookTouchdownG => 'Touchdown load';

  @override
  String get logbookRemarks => 'Remarks';

  @override
  String logbookBlockShort(String time) {
    return 'Block $time';
  }

  @override
  String get logbookDeleteTitle => 'Delete logbook entry?';

  @override
  String get logbookDeleteMessage =>
      'The flight plan stays; only this logbook line is removed.';

  @override
  String get touchdownButter => 'Butter';

  @override
  String get touchdownSmooth => 'Smooth';

  @override
  String get touchdownFirm => 'Firm';

  @override
  String get touchdownHard => 'Hard';

  @override
  String get touchdownInspect => 'Check the gear';
}
