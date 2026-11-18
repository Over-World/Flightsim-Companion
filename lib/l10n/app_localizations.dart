import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Flightsim Companion'**
  String get appTitle;

  /// No description provided for @navPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get navPlan;

  /// No description provided for @navFly.
  ///
  /// In en, this message translates to:
  /// **'Fly'**
  String get navFly;

  /// No description provided for @navAircraft.
  ///
  /// In en, this message translates to:
  /// **'Aircraft'**
  String get navAircraft;

  /// No description provided for @navLogbook.
  ///
  /// In en, this message translates to:
  /// **'Logbook'**
  String get navLogbook;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get fieldRequired;

  /// No description provided for @fieldInvalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive number'**
  String get fieldInvalidNumber;

  /// No description provided for @navdataMissingTitle.
  ///
  /// In en, this message translates to:
  /// **'No navigation data yet'**
  String get navdataMissingTitle;

  /// No description provided for @navdataMissingMessage.
  ///
  /// In en, this message translates to:
  /// **'Download airports, runways, frequencies and navaids once to use the app offline.'**
  String get navdataMissingMessage;

  /// No description provided for @navdataMissingAction.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get navdataMissingAction;

  /// No description provided for @flightsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No flights planned'**
  String get flightsEmptyTitle;

  /// No description provided for @flyNoActiveFlightTitle.
  ///
  /// In en, this message translates to:
  /// **'No active flight'**
  String get flyNoActiveFlightTitle;

  /// No description provided for @flyNoActiveFlightMessage.
  ///
  /// In en, this message translates to:
  /// **'Start a planned flight to open the kneeboard with navlog, stopwatch and frequencies.'**
  String get flyNoActiveFlightMessage;

  /// No description provided for @logbookEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Logbook is empty'**
  String get logbookEmptyTitle;

  /// No description provided for @logbookEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Completed flights are logged here with times and landing ratings.'**
  String get logbookEmptyMessage;

  /// No description provided for @airportSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Find airport'**
  String get airportSearchTitle;

  /// No description provided for @airportSearchHint.
  ///
  /// In en, this message translates to:
  /// **'ICAO, IATA, name or city'**
  String get airportSearchHint;

  /// No description provided for @airportSearchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No airport found for \"{query}\"'**
  String airportSearchNoResults(String query);

  /// No description provided for @airportTypeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large airport'**
  String get airportTypeLarge;

  /// No description provided for @airportTypeMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium airport'**
  String get airportTypeMedium;

  /// No description provided for @airportTypeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small airfield'**
  String get airportTypeSmall;

  /// No description provided for @airportTypeHeliport.
  ///
  /// In en, this message translates to:
  /// **'Heliport'**
  String get airportTypeHeliport;

  /// No description provided for @airportTypeSeaplane.
  ///
  /// In en, this message translates to:
  /// **'Seaplane base'**
  String get airportTypeSeaplane;

  /// No description provided for @elevationFt.
  ///
  /// In en, this message translates to:
  /// **'{ft} ft'**
  String elevationFt(int ft);

  /// No description provided for @frequencies.
  ///
  /// In en, this message translates to:
  /// **'Frequencies'**
  String get frequencies;

  /// No description provided for @noFrequencies.
  ///
  /// In en, this message translates to:
  /// **'No frequencies known'**
  String get noFrequencies;

  /// No description provided for @runways.
  ///
  /// In en, this message translates to:
  /// **'Runways'**
  String get runways;

  /// No description provided for @noRunways.
  ///
  /// In en, this message translates to:
  /// **'No runways known'**
  String get noRunways;

  /// No description provided for @runwayDimensions.
  ///
  /// In en, this message translates to:
  /// **'{lengthFt} ft ({lengthM} m) × {widthFt} ft'**
  String runwayDimensions(int lengthFt, int lengthM, int widthFt);

  /// No description provided for @runwayLighted.
  ///
  /// In en, this message translates to:
  /// **'lighted'**
  String get runwayLighted;

  /// No description provided for @navaidsNearby.
  ///
  /// In en, this message translates to:
  /// **'Navaids nearby'**
  String get navaidsNearby;

  /// No description provided for @noNavaids.
  ///
  /// In en, this message translates to:
  /// **'No navaids within 40 NM'**
  String get noNavaids;

  /// No description provided for @radialDistance.
  ///
  /// In en, this message translates to:
  /// **'Airport on R{radial} · {distance} NM'**
  String radialDistance(String radial, String distance);

  /// No description provided for @aircraftAdd.
  ///
  /// In en, this message translates to:
  /// **'Add aircraft'**
  String get aircraftAdd;

  /// No description provided for @aircraftEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit aircraft'**
  String get aircraftEdit;

  /// No description provided for @aircraftEmpty.
  ///
  /// In en, this message translates to:
  /// **'No aircraft profiles'**
  String get aircraftEmpty;

  /// No description provided for @aircraftSummary.
  ///
  /// In en, this message translates to:
  /// **'{tas} kt TAS · {burn} {unit}/h'**
  String aircraftSummary(int tas, String burn, String unit);

  /// No description provided for @aircraftDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete aircraft?'**
  String get aircraftDeleteTitle;

  /// No description provided for @aircraftDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" will be removed permanently.'**
  String aircraftDeleteMessage(String name);

  /// No description provided for @aircraftSectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get aircraftSectionGeneral;

  /// No description provided for @aircraftName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get aircraftName;

  /// No description provided for @aircraftIcaoType.
  ///
  /// In en, this message translates to:
  /// **'ICAO type'**
  String get aircraftIcaoType;

  /// No description provided for @aircraftRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get aircraftRegistration;

  /// No description provided for @aircraftSectionPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get aircraftSectionPerformance;

  /// No description provided for @aircraftCruiseTas.
  ///
  /// In en, this message translates to:
  /// **'Cruise TAS'**
  String get aircraftCruiseTas;

  /// No description provided for @aircraftClimbTas.
  ///
  /// In en, this message translates to:
  /// **'Climb TAS'**
  String get aircraftClimbTas;

  /// No description provided for @aircraftClimbRate.
  ///
  /// In en, this message translates to:
  /// **'Climb rate'**
  String get aircraftClimbRate;

  /// No description provided for @aircraftDescentRate.
  ///
  /// In en, this message translates to:
  /// **'Descent rate'**
  String get aircraftDescentRate;

  /// No description provided for @aircraftSectionFuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get aircraftSectionFuel;

  /// No description provided for @aircraftFuelBurn.
  ///
  /// In en, this message translates to:
  /// **'Fuel burn (cruise)'**
  String get aircraftFuelBurn;

  /// No description provided for @aircraftUsableFuel.
  ///
  /// In en, this message translates to:
  /// **'Usable fuel'**
  String get aircraftUsableFuel;

  /// No description provided for @aircraftFuelType.
  ///
  /// In en, this message translates to:
  /// **'Fuel type'**
  String get aircraftFuelType;

  /// No description provided for @aircraftSectionWeights.
  ///
  /// In en, this message translates to:
  /// **'Weights'**
  String get aircraftSectionWeights;

  /// No description provided for @aircraftEmptyWeight.
  ///
  /// In en, this message translates to:
  /// **'Empty weight'**
  String get aircraftEmptyWeight;

  /// No description provided for @aircraftMtow.
  ///
  /// In en, this message translates to:
  /// **'Max. takeoff weight'**
  String get aircraftMtow;

  /// No description provided for @aircraftNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get aircraftNotes;

  /// No description provided for @aircraftNotesHint.
  ///
  /// In en, this message translates to:
  /// **'V-speeds, procedures, peculiarities…'**
  String get aircraftNotesHint;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @settingsAccent.
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get settingsAccent;

  /// No description provided for @settingsUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get settingsUnits;

  /// No description provided for @settingsFuelUnit.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get settingsFuelUnit;

  /// No description provided for @unitLiters.
  ///
  /// In en, this message translates to:
  /// **'Litres'**
  String get unitLiters;

  /// No description provided for @unitUsGallons.
  ///
  /// In en, this message translates to:
  /// **'US gallons'**
  String get unitUsGallons;

  /// No description provided for @settingsWeightUnit.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get settingsWeightUnit;

  /// No description provided for @unitKilograms.
  ///
  /// In en, this message translates to:
  /// **'Kilograms'**
  String get unitKilograms;

  /// No description provided for @unitPounds.
  ///
  /// In en, this message translates to:
  /// **'Pounds'**
  String get unitPounds;

  /// No description provided for @settingsSimulator.
  ///
  /// In en, this message translates to:
  /// **'Simulator'**
  String get settingsSimulator;

  /// No description provided for @settingsXplaneHint.
  ///
  /// In en, this message translates to:
  /// **'X-Plane 12: enter the IP address of the PC running the simulator. The app connects to X-Plane\'s web API on your local network.'**
  String get settingsXplaneHint;

  /// No description provided for @settingsSimHost.
  ///
  /// In en, this message translates to:
  /// **'X-Plane PC (IP or hostname)'**
  String get settingsSimHost;

  /// No description provided for @settingsSimPort.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get settingsSimPort;

  /// No description provided for @settingsNavdata.
  ///
  /// In en, this message translates to:
  /// **'Navigation data'**
  String get settingsNavdata;

  /// No description provided for @navdataNeverImported.
  ///
  /// In en, this message translates to:
  /// **'Not downloaded yet'**
  String get navdataNeverImported;

  /// No description provided for @navdataImportedAt.
  ///
  /// In en, this message translates to:
  /// **'Last updated {date}'**
  String navdataImportedAt(String date);

  /// No description provided for @navdataCounts.
  ///
  /// In en, this message translates to:
  /// **'{airports} airports · {runways} runways · {frequencies} frequencies · {navaids} navaids'**
  String navdataCounts(
    String airports,
    String runways,
    String frequencies,
    String navaids,
  );

  /// No description provided for @navdataImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed: {error}'**
  String navdataImportFailed(String error);

  /// No description provided for @navdataSource.
  ///
  /// In en, this message translates to:
  /// **'Source: OurAirports (public domain), worldwide, about 20 MB.'**
  String get navdataSource;

  /// No description provided for @navdataDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get navdataDownload;

  /// No description provided for @navdataUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get navdataUpdate;

  /// No description provided for @navdataStageDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading {file}…'**
  String navdataStageDownloading(String file);

  /// No description provided for @navdataStageParsing.
  ///
  /// In en, this message translates to:
  /// **'Processing data…'**
  String get navdataStageParsing;

  /// No description provided for @navdataStageWriting.
  ///
  /// In en, this message translates to:
  /// **'Saving to database…'**
  String get navdataStageWriting;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @settingsHomeAirport.
  ///
  /// In en, this message translates to:
  /// **'Home airport'**
  String get settingsHomeAirport;

  /// No description provided for @settingsDefaultAircraft.
  ///
  /// In en, this message translates to:
  /// **'Default aircraft'**
  String get settingsDefaultAircraft;

  /// No description provided for @settingsAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get settingsAccounts;

  /// No description provided for @settingsSimbriefUser.
  ///
  /// In en, this message translates to:
  /// **'SimBrief username or pilot ID'**
  String get settingsSimbriefUser;

  /// No description provided for @settingsSimbriefHint.
  ///
  /// In en, this message translates to:
  /// **'Used to import your latest OFP for IFR flights.'**
  String get settingsSimbriefHint;

  /// No description provided for @settingsNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get settingsNotes;

  /// No description provided for @settingsFingerDrawing.
  ///
  /// In en, this message translates to:
  /// **'Draw with finger'**
  String get settingsFingerDrawing;

  /// No description provided for @settingsFingerDrawingHint.
  ///
  /// In en, this message translates to:
  /// **'When off, only a stylus draws and a finger just scrolls.'**
  String get settingsFingerDrawingHint;

  /// No description provided for @settingsRestartOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Run setup again'**
  String get settingsRestartOnboarding;

  /// No description provided for @xplaneTest.
  ///
  /// In en, this message translates to:
  /// **'Test connection'**
  String get xplaneTest;

  /// No description provided for @xplaneTesting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get xplaneTesting;

  /// No description provided for @xplaneConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected to X-Plane {version}'**
  String xplaneConnected(String version);

  /// No description provided for @xplaneConnectionFailed.
  ///
  /// In en, this message translates to:
  /// **'No connection: {error}'**
  String xplaneConnectionFailed(String error);

  /// No description provided for @onboardingStep.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total}'**
  String onboardingStep(int current, int total);

  /// No description provided for @onboardingFinish.
  ///
  /// In en, this message translates to:
  /// **'Let\'s fly'**
  String get onboardingFinish;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome aboard'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeText.
  ///
  /// In en, this message translates to:
  /// **'Flightsim Companion is your kneeboard for X-Plane and MSFS: plan VFR and IFR flights, fly them with navlog, stopwatch and frequencies, and keep notes like on real paper. A few quick steps and you\'re ready.'**
  String get onboardingWelcomeText;

  /// No description provided for @onboardingNavdataTitle.
  ///
  /// In en, this message translates to:
  /// **'Navigation data'**
  String get onboardingNavdataTitle;

  /// No description provided for @onboardingNavdataText.
  ///
  /// In en, this message translates to:
  /// **'Airports, runways, frequencies and navaids worldwide. Downloaded once, then everything works offline.'**
  String get onboardingNavdataText;

  /// No description provided for @onboardingSimTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect X-Plane'**
  String get onboardingSimTitle;

  /// No description provided for @onboardingSimText.
  ///
  /// In en, this message translates to:
  /// **'Optional. Enter the IP address of the PC running X-Plane 12 – both devices must be on the same network. You can skip this and fly without a live connection.'**
  String get onboardingSimText;

  /// No description provided for @onboardingAccountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get onboardingAccountsTitle;

  /// No description provided for @onboardingAccountsText.
  ///
  /// In en, this message translates to:
  /// **'Optional. With your SimBrief username the app can import your latest flight plan later.'**
  String get onboardingAccountsText;

  /// No description provided for @onboardingHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home base'**
  String get onboardingHomeTitle;

  /// No description provided for @onboardingHomeText.
  ///
  /// In en, this message translates to:
  /// **'Your home airport is suggested as departure for new flights, your default aircraft is preselected.'**
  String get onboardingHomeText;

  /// No description provided for @onboardingHomeNeedsNavdata.
  ///
  /// In en, this message translates to:
  /// **'Download the navigation data first to pick a home airport – you can set it later in the settings.'**
  String get onboardingHomeNeedsNavdata;

  /// No description provided for @flightsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Plan your first VFR or IFR flight: departure, destination, waypoints – the navlog is calculated for you.'**
  String get flightsEmptyMessage;

  /// No description provided for @flightNew.
  ///
  /// In en, this message translates to:
  /// **'New flight'**
  String get flightNew;

  /// No description provided for @flightCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get flightCreate;

  /// No description provided for @flightEdit.
  ///
  /// In en, this message translates to:
  /// **'Flight data'**
  String get flightEdit;

  /// No description provided for @flightTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get flightTitle;

  /// No description provided for @flightDeparture.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get flightDeparture;

  /// No description provided for @flightDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get flightDestination;

  /// No description provided for @flightAlternate.
  ///
  /// In en, this message translates to:
  /// **'Alternate'**
  String get flightAlternate;

  /// No description provided for @flightAlternateShort.
  ///
  /// In en, this message translates to:
  /// **'Altn {ident}'**
  String flightAlternateShort(String ident);

  /// No description provided for @flightAircraft.
  ///
  /// In en, this message translates to:
  /// **'Aircraft'**
  String get flightAircraft;

  /// No description provided for @flightCruiseAltitude.
  ///
  /// In en, this message translates to:
  /// **'Cruise altitude'**
  String get flightCruiseAltitude;

  /// No description provided for @flightPlannedDeparture.
  ///
  /// In en, this message translates to:
  /// **'Planned departure (off-block)'**
  String get flightPlannedDeparture;

  /// No description provided for @flightWindHint.
  ///
  /// In en, this message translates to:
  /// **'Wind for all legs without their own wind (true direction, from).'**
  String get flightWindHint;

  /// No description provided for @flightNoAircraft.
  ///
  /// In en, this message translates to:
  /// **'No aircraft selected'**
  String get flightNoAircraft;

  /// No description provided for @flightChooseAircraft.
  ///
  /// In en, this message translates to:
  /// **'Choose aircraft'**
  String get flightChooseAircraft;

  /// No description provided for @flightFly.
  ///
  /// In en, this message translates to:
  /// **'Fly'**
  String get flightFly;

  /// No description provided for @flightTabRoute.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get flightTabRoute;

  /// No description provided for @flightTabNavlog.
  ///
  /// In en, this message translates to:
  /// **'Navlog'**
  String get flightTabNavlog;

  /// No description provided for @flightStatusPlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get flightStatusPlanned;

  /// No description provided for @flightStatusActive.
  ///
  /// In en, this message translates to:
  /// **'In flight'**
  String get flightStatusActive;

  /// No description provided for @flightStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get flightStatusCompleted;

  /// No description provided for @flightDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete flight?'**
  String get flightDeleteTitle;

  /// No description provided for @flightDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" and all its notes will be removed permanently.'**
  String flightDeleteMessage(String title);

  /// No description provided for @windDirection.
  ///
  /// In en, this message translates to:
  /// **'Wind from'**
  String get windDirection;

  /// No description provided for @windSpeed.
  ///
  /// In en, this message translates to:
  /// **'Wind speed'**
  String get windSpeed;

  /// No description provided for @legTo.
  ///
  /// In en, this message translates to:
  /// **'Leg to {ident}'**
  String legTo(String ident);

  /// No description provided for @legEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit leg'**
  String get legEdit;

  /// No description provided for @legAltitude.
  ///
  /// In en, this message translates to:
  /// **'Altitude'**
  String get legAltitude;

  /// No description provided for @legWindHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to use the flight\'s wind.'**
  String get legWindHint;

  /// No description provided for @legNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes for this leg'**
  String get legNotes;

  /// No description provided for @waypointAdd.
  ///
  /// In en, this message translates to:
  /// **'Add waypoint'**
  String get waypointAdd;

  /// No description provided for @waypointTabSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get waypointTabSearch;

  /// No description provided for @waypointTabRadial.
  ///
  /// In en, this message translates to:
  /// **'Radial/DME'**
  String get waypointTabRadial;

  /// No description provided for @waypointTabCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get waypointTabCoordinates;

  /// No description provided for @waypointSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Navaid or airport: ident or name'**
  String get waypointSearchHint;

  /// No description provided for @waypointNavaidIdent.
  ///
  /// In en, this message translates to:
  /// **'Navaid ident (e.g. FFM)'**
  String get waypointNavaidIdent;

  /// No description provided for @waypointRadial.
  ///
  /// In en, this message translates to:
  /// **'Radial'**
  String get waypointRadial;

  /// No description provided for @waypointDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get waypointDistance;

  /// No description provided for @waypointName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get waypointName;

  /// No description provided for @waypointNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. lake, motorway junction, reporting point'**
  String get waypointNameHint;

  /// No description provided for @waypointLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get waypointLatitude;

  /// No description provided for @waypointLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get waypointLongitude;

  /// No description provided for @waypointCoordinatesHint.
  ///
  /// In en, this message translates to:
  /// **'Decimal degrees, south and west negative.'**
  String get waypointCoordinatesHint;

  /// No description provided for @navlogWaypoint.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get navlogWaypoint;

  /// No description provided for @navlogWind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get navlogWind;

  /// No description provided for @navlogCalm.
  ///
  /// In en, this message translates to:
  /// **'calm'**
  String get navlogCalm;

  /// No description provided for @navlogTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get navlogTotal;

  /// No description provided for @navlogDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get navlogDistance;

  /// No description provided for @navlogTime.
  ///
  /// In en, this message translates to:
  /// **'Flight time'**
  String get navlogTime;

  /// No description provided for @navlogFuel.
  ///
  /// In en, this message translates to:
  /// **'Trip fuel'**
  String get navlogFuel;

  /// No description provided for @navlogNeedsAircraft.
  ///
  /// In en, this message translates to:
  /// **'Choose an aircraft to calculate headings, times and fuel.'**
  String get navlogNeedsAircraft;

  /// No description provided for @navlogUnsolvable.
  ///
  /// In en, this message translates to:
  /// **'! The wind is too strong for at least one leg at this airspeed.'**
  String get navlogUnsolvable;

  /// No description provided for @navlogFootnote.
  ///
  /// In en, this message translates to:
  /// **'Constant cruise TAS, no climb or descent. MH = magnetic heading with WMM variation. Tap a leg to set its altitude and wind.'**
  String get navlogFootnote;

  /// No description provided for @kneeboardCurrentLeg.
  ///
  /// In en, this message translates to:
  /// **'Current leg'**
  String get kneeboardCurrentLeg;

  /// No description provided for @kneeboardTimes.
  ///
  /// In en, this message translates to:
  /// **'Times'**
  String get kneeboardTimes;

  /// No description provided for @kneeboardEditPlan.
  ///
  /// In en, this message translates to:
  /// **'Edit plan'**
  String get kneeboardEditPlan;

  /// No description provided for @kneeboardReset.
  ///
  /// In en, this message translates to:
  /// **'Reset times'**
  String get kneeboardReset;

  /// No description provided for @kneeboardResetMessage.
  ///
  /// In en, this message translates to:
  /// **'All recorded times of this flight are cleared.'**
  String get kneeboardResetMessage;

  /// No description provided for @kneeboardClose.
  ///
  /// In en, this message translates to:
  /// **'Close kneeboard'**
  String get kneeboardClose;

  /// No description provided for @actionBlockOff.
  ///
  /// In en, this message translates to:
  /// **'Off block'**
  String get actionBlockOff;

  /// No description provided for @actionTakeoff.
  ///
  /// In en, this message translates to:
  /// **'Takeoff'**
  String get actionTakeoff;

  /// No description provided for @actionPassed.
  ///
  /// In en, this message translates to:
  /// **'Over {ident}'**
  String actionPassed(String ident);

  /// No description provided for @actionLanding.
  ///
  /// In en, this message translates to:
  /// **'Landing'**
  String get actionLanding;

  /// No description provided for @actionBlockOn.
  ///
  /// In en, this message translates to:
  /// **'On block'**
  String get actionBlockOn;

  /// No description provided for @actionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Flight completed'**
  String get actionCompleted;

  /// No description provided for @actionUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get actionUndo;

  /// No description provided for @legProgress.
  ///
  /// In en, this message translates to:
  /// **'Leg {current} of {total}'**
  String legProgress(int current, int total);

  /// No description provided for @legElapsed.
  ///
  /// In en, this message translates to:
  /// **'Leg time'**
  String get legElapsed;

  /// No description provided for @legRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get legRemaining;

  /// No description provided for @legOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get legOverdue;

  /// No description provided for @phasePreflight.
  ///
  /// In en, this message translates to:
  /// **'Ready. Tap \"Off block\" when you start taxiing – or directly \"Takeoff\" after it.'**
  String get phasePreflight;

  /// No description provided for @phaseTaxiOut.
  ///
  /// In en, this message translates to:
  /// **'Taxiing. Tap \"Takeoff\" when the wheels leave the ground.'**
  String get phaseTaxiOut;

  /// No description provided for @phaseArrived.
  ///
  /// In en, this message translates to:
  /// **'All waypoints passed. Tap \"Landing\" at touchdown.'**
  String get phaseArrived;

  /// No description provided for @phaseLanded.
  ///
  /// In en, this message translates to:
  /// **'Landed. Tap \"On block\" when parked.'**
  String get phaseLanded;

  /// No description provided for @phaseParked.
  ///
  /// In en, this message translates to:
  /// **'Flight completed.'**
  String get phaseParked;

  /// No description provided for @timeBlockOff.
  ///
  /// In en, this message translates to:
  /// **'Off block'**
  String get timeBlockOff;

  /// No description provided for @timeTakeoff.
  ///
  /// In en, this message translates to:
  /// **'Takeoff'**
  String get timeTakeoff;

  /// No description provided for @timeLanding.
  ///
  /// In en, this message translates to:
  /// **'Landing'**
  String get timeLanding;

  /// No description provided for @timeBlockOn.
  ///
  /// In en, this message translates to:
  /// **'On block'**
  String get timeBlockOn;

  /// No description provided for @timeFlight.
  ///
  /// In en, this message translates to:
  /// **'Flight time'**
  String get timeFlight;

  /// No description provided for @timeBlock.
  ///
  /// In en, this message translates to:
  /// **'Block time'**
  String get timeBlock;

  /// No description provided for @stopwatch.
  ///
  /// In en, this message translates to:
  /// **'Stopwatch'**
  String get stopwatch;

  /// No description provided for @stopwatchStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get stopwatchStart;

  /// No description provided for @stopwatchStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopwatchStop;

  /// No description provided for @stopwatchReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get stopwatchReset;

  /// No description provided for @notesOpen.
  ///
  /// In en, this message translates to:
  /// **'Notepad'**
  String get notesOpen;

  /// No description provided for @notesFlight.
  ///
  /// In en, this message translates to:
  /// **'This flight'**
  String get notesFlight;

  /// No description provided for @notesGeneral.
  ///
  /// In en, this message translates to:
  /// **'General notes'**
  String get notesGeneral;

  /// No description provided for @notesAddPage.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get notesAddPage;

  /// No description provided for @notesClearPage.
  ///
  /// In en, this message translates to:
  /// **'Clear page'**
  String get notesClearPage;

  /// No description provided for @notesDeletePage.
  ///
  /// In en, this message translates to:
  /// **'Delete page'**
  String get notesDeletePage;

  /// No description provided for @actionRedo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get actionRedo;

  /// No description provided for @pageBlank.
  ///
  /// In en, this message translates to:
  /// **'Blank'**
  String get pageBlank;

  /// No description provided for @pageGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get pageGrid;

  /// No description provided for @pageLined.
  ///
  /// In en, this message translates to:
  /// **'Lined'**
  String get pageLined;

  /// No description provided for @pageAtis.
  ///
  /// In en, this message translates to:
  /// **'ATIS'**
  String get pageAtis;

  /// No description provided for @pageCraft.
  ///
  /// In en, this message translates to:
  /// **'Clearance (CRAFT)'**
  String get pageCraft;

  /// No description provided for @toolPen.
  ///
  /// In en, this message translates to:
  /// **'Pen'**
  String get toolPen;

  /// No description provided for @toolHighlighter.
  ///
  /// In en, this message translates to:
  /// **'Highlighter'**
  String get toolHighlighter;

  /// No description provided for @toolEraser.
  ///
  /// In en, this message translates to:
  /// **'Eraser'**
  String get toolEraser;

  /// No description provided for @toolSize.
  ///
  /// In en, this message translates to:
  /// **'Line width'**
  String get toolSize;

  /// No description provided for @templateAtisInfo.
  ///
  /// In en, this message translates to:
  /// **'INFORMATION  ·  TIME'**
  String get templateAtisInfo;

  /// No description provided for @templateAtisRunway.
  ///
  /// In en, this message translates to:
  /// **'RWY IN USE'**
  String get templateAtisRunway;

  /// No description provided for @templateAtisWind.
  ///
  /// In en, this message translates to:
  /// **'WIND'**
  String get templateAtisWind;

  /// No description provided for @templateAtisVisibility.
  ///
  /// In en, this message translates to:
  /// **'VISIBILITY'**
  String get templateAtisVisibility;

  /// No description provided for @templateAtisWeather.
  ///
  /// In en, this message translates to:
  /// **'WEATHER'**
  String get templateAtisWeather;

  /// No description provided for @templateAtisClouds.
  ///
  /// In en, this message translates to:
  /// **'CLOUDS'**
  String get templateAtisClouds;

  /// No description provided for @templateAtisTemperature.
  ///
  /// In en, this message translates to:
  /// **'TEMP / DEW POINT'**
  String get templateAtisTemperature;

  /// No description provided for @templateAtisQnh.
  ///
  /// In en, this message translates to:
  /// **'QNH'**
  String get templateAtisQnh;

  /// No description provided for @templateAtisRemarks.
  ///
  /// In en, this message translates to:
  /// **'REMARKS / TREND'**
  String get templateAtisRemarks;

  /// No description provided for @templateCraftClearance.
  ///
  /// In en, this message translates to:
  /// **'C  Clearance limit'**
  String get templateCraftClearance;

  /// No description provided for @templateCraftRoute.
  ///
  /// In en, this message translates to:
  /// **'R  Route (SID)'**
  String get templateCraftRoute;

  /// No description provided for @templateCraftAltitude.
  ///
  /// In en, this message translates to:
  /// **'A  Altitude'**
  String get templateCraftAltitude;

  /// No description provided for @templateCraftFrequency.
  ///
  /// In en, this message translates to:
  /// **'F  Frequency'**
  String get templateCraftFrequency;

  /// No description provided for @templateCraftTransponder.
  ///
  /// In en, this message translates to:
  /// **'T  Transponder'**
  String get templateCraftTransponder;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
