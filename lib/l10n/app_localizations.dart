import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_az.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('az'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'YHealth'**
  String get appName;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to YHealth'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your minimalist, mindful companion for daily health, walking routes, and mindful activity tracking.'**
  String get welcomeSubtitle;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get chooseLanguage;

  /// No description provided for @chooseLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language to continue'**
  String get chooseLanguageSubtitle;

  /// No description provided for @azerbaijani.
  ///
  /// In en, this message translates to:
  /// **'Azərbaycan dili'**
  String get azerbaijani;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get navActivity;

  /// No description provided for @navHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get navHealth;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @dailySummary.
  ///
  /// In en, this message translates to:
  /// **'Daily Overview'**
  String get dailySummary;

  /// No description provided for @todayProgress.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Progress'**
  String get todayProgress;

  /// No description provided for @stepsLabel.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get stepsLabel;

  /// No description provided for @distanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distanceLabel;

  /// No description provided for @caloriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get caloriesLabel;

  /// No description provided for @activeTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Active Time'**
  String get activeTimeLabel;

  /// No description provided for @goalTarget.
  ///
  /// In en, this message translates to:
  /// **'Goal: {target}'**
  String goalTarget(Object target);

  /// No description provided for @goalReached.
  ///
  /// In en, this message translates to:
  /// **'Goal achieved! Excellent work!'**
  String get goalReached;

  /// No description provided for @stepsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} steps to reach your goal'**
  String stepsRemaining(Object count);

  /// No description provided for @dailyGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Goals'**
  String get dailyGoalsTitle;

  /// No description provided for @kmUnit.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get kmUnit;

  /// No description provided for @kcalUnit.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get kcalUnit;

  /// No description provided for @minUnit.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minUnit;

  /// No description provided for @stepsUnit.
  ///
  /// In en, this message translates to:
  /// **'steps'**
  String get stepsUnit;

  /// No description provided for @weeklyOverview.
  ///
  /// In en, this message translates to:
  /// **'Weekly Activity'**
  String get weeklyOverview;

  /// No description provided for @quickStartWalk.
  ///
  /// In en, this message translates to:
  /// **'Start Walking'**
  String get quickStartWalk;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @activityTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity & GPS'**
  String get activityTitle;

  /// No description provided for @activitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Live route tracking with OpenStreetMap'**
  String get activitySubtitle;

  /// No description provided for @startWalk.
  ///
  /// In en, this message translates to:
  /// **'Start Walk'**
  String get startWalk;

  /// No description provided for @pauseWalk.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseWalk;

  /// No description provided for @resumeWalk.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resumeWalk;

  /// No description provided for @stopWalk.
  ///
  /// In en, this message translates to:
  /// **'Finish & Save'**
  String get stopWalk;

  /// No description provided for @liveTracking.
  ///
  /// In en, this message translates to:
  /// **'Live Tracking'**
  String get liveTracking;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @avgSpeed.
  ///
  /// In en, this message translates to:
  /// **'Avg Speed'**
  String get avgSpeed;

  /// No description provided for @currentSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get currentSpeed;

  /// No description provided for @pace.
  ///
  /// In en, this message translates to:
  /// **'Pace'**
  String get pace;

  /// No description provided for @caloriesBurned.
  ///
  /// In en, this message translates to:
  /// **'Burned Calories'**
  String get caloriesBurned;

  /// No description provided for @mapAttribution.
  ///
  /// In en, this message translates to:
  /// **'© OpenStreetMap contributors'**
  String get mapAttribution;

  /// No description provided for @routeHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Route History'**
  String get routeHistoryTitle;

  /// No description provided for @noRoutesYet.
  ///
  /// In en, this message translates to:
  /// **'No recorded routes yet'**
  String get noRoutesYet;

  /// No description provided for @noRoutesDesc.
  ///
  /// In en, this message translates to:
  /// **'Start your first walking or running session to record your path on OpenStreetMap.'**
  String get noRoutesDesc;

  /// No description provided for @routeSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Route saved successfully!'**
  String get routeSavedSuccess;

  /// No description provided for @finishRouteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to finish this session?'**
  String get finishRouteConfirmation;

  /// No description provided for @finishRouteTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish Activity'**
  String get finishRouteTitle;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @saveRoute.
  ///
  /// In en, this message translates to:
  /// **'Save Route'**
  String get saveRoute;

  /// No description provided for @sessionRecorded.
  ///
  /// In en, this message translates to:
  /// **'Session Summary'**
  String get sessionRecorded;

  /// No description provided for @speedUnitKmH.
  ///
  /// In en, this message translates to:
  /// **'km/h'**
  String get speedUnitKmH;

  /// No description provided for @paceUnitMinKm.
  ///
  /// In en, this message translates to:
  /// **'min/km'**
  String get paceUnitMinKm;

  /// No description provided for @gpsPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'GPS Location Permission Required'**
  String get gpsPermissionRequired;

  /// No description provided for @gpsPermissionDesc.
  ///
  /// In en, this message translates to:
  /// **'YHealth requires your precise location to track walking routes, calculate accurate distance, and display your path on OpenStreetMap.'**
  String get gpsPermissionDesc;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission was denied.'**
  String get permissionDenied;

  /// No description provided for @permissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission is permanently denied. Please enable it in system settings.'**
  String get permissionPermanentlyDenied;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @locationConsentNote.
  ///
  /// In en, this message translates to:
  /// **'YHealth never tracks your location without your explicit consent.'**
  String get locationConsentNote;

  /// No description provided for @androidLocationInfo.
  ///
  /// In en, this message translates to:
  /// **'Android Location & Background Limits'**
  String get androidLocationInfo;

  /// No description provided for @androidLocationDesc.
  ///
  /// In en, this message translates to:
  /// **'To conserve battery, Android limits background GPS tracking unless a foreground service is active. Live recording runs with continuous GPS while the session is active.'**
  String get androidLocationDesc;

  /// No description provided for @stepCounterTitle.
  ///
  /// In en, this message translates to:
  /// **'Step Counter'**
  String get stepCounterTitle;

  /// No description provided for @stepStatistics.
  ///
  /// In en, this message translates to:
  /// **'Step Analytics'**
  String get stepStatistics;

  /// No description provided for @hardwareSensorStatus.
  ///
  /// In en, this message translates to:
  /// **'Hardware Sensor Status'**
  String get hardwareSensorStatus;

  /// No description provided for @sensorActive.
  ///
  /// In en, this message translates to:
  /// **'Physical sensor connected and active'**
  String get sensorActive;

  /// No description provided for @sensorUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Hardware step sensor not detected on this device or emulator'**
  String get sensorUnavailable;

  /// No description provided for @sensorExplanation.
  ///
  /// In en, this message translates to:
  /// **'Step detection relies on your phone\'s built-in pedometer hardware (STEP_COUNTER / STEP_DETECTOR). Most emulators do not have physical motion sensors.'**
  String get sensorExplanation;

  /// No description provided for @sensorPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Physical Activity Permission Required'**
  String get sensorPermissionRequired;

  /// No description provided for @sensorPermissionDesc.
  ///
  /// In en, this message translates to:
  /// **'To count steps accurately throughout the day, YHealth needs permission to access your device\'s activity recognition sensor.'**
  String get sensorPermissionDesc;

  /// No description provided for @dailySteps.
  ///
  /// In en, this message translates to:
  /// **'Daily Steps'**
  String get dailySteps;

  /// No description provided for @weeklySteps.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weeklySteps;

  /// No description provided for @monthlySteps.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthlySteps;

  /// No description provided for @averageSteps.
  ///
  /// In en, this message translates to:
  /// **'Daily Average'**
  String get averageSteps;

  /// No description provided for @simulateStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Test Sensor Simulation'**
  String get simulateStepTitle;

  /// No description provided for @simulateStepDesc.
  ///
  /// In en, this message translates to:
  /// **'Since emulator hardware lacks physical accelerometer steps, you can simulate steps for testing.'**
  String get simulateStepDesc;

  /// No description provided for @addTestSteps.
  ///
  /// In en, this message translates to:
  /// **'+500 Test Steps'**
  String get addTestSteps;

  /// No description provided for @sensorCompatibilityNotice.
  ///
  /// In en, this message translates to:
  /// **'Hardware Compatibility Notice: Phone step counter sensors require physical motion. Real hardware step counters do not increment when stationary.'**
  String get sensorCompatibilityNotice;

  /// No description provided for @bmiTitle.
  ///
  /// In en, this message translates to:
  /// **'BMI Calculator'**
  String get bmiTitle;

  /// No description provided for @bmiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Body Mass Index assessment & guidance'**
  String get bmiSubtitle;

  /// No description provided for @heightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get heightLabel;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightLabel;

  /// No description provided for @calculateBmi.
  ///
  /// In en, this message translates to:
  /// **'Calculate BMI'**
  String get calculateBmi;

  /// No description provided for @recalculate.
  ///
  /// In en, this message translates to:
  /// **'Recalculate'**
  String get recalculate;

  /// No description provided for @yourBmiIs.
  ///
  /// In en, this message translates to:
  /// **'Your Body Mass Index is'**
  String get yourBmiIs;

  /// No description provided for @bmiCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get bmiCategory;

  /// No description provided for @healthyWeightRange.
  ///
  /// In en, this message translates to:
  /// **'Healthy weight range for your height: {min} kg – {max} kg'**
  String healthyWeightRange(Object max, Object min);

  /// No description provided for @categoryUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get categoryUnderweight;

  /// No description provided for @categoryNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal weight'**
  String get categoryNormal;

  /// No description provided for @categoryOverweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get categoryOverweight;

  /// No description provided for @categoryObese.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get categoryObese;

  /// No description provided for @bmiExplanationUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Your BMI indicates underweight. Consider nutrient-rich balanced meals and consult a healthcare provider for personalized nutritional advice.'**
  String get bmiExplanationUnderweight;

  /// No description provided for @bmiExplanationNormal.
  ///
  /// In en, this message translates to:
  /// **'Your BMI falls in the healthy weight range. Maintain regular walking, mindful nutrition, and consistent physical activity.'**
  String get bmiExplanationNormal;

  /// No description provided for @bmiExplanationOverweight.
  ///
  /// In en, this message translates to:
  /// **'Your BMI indicates slight overweight. Increasing daily walking distance and mindful dietary adjustments can help reach an optimal range.'**
  String get bmiExplanationOverweight;

  /// No description provided for @bmiExplanationObese.
  ///
  /// In en, this message translates to:
  /// **'Your BMI falls into the obese category. Prioritizing structured daily low-impact exercise like walking and consulting a medical professional is recommended.'**
  String get bmiExplanationObese;

  /// No description provided for @bmiDisclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Important Medical Disclaimer'**
  String get bmiDisclaimerTitle;

  /// No description provided for @bmiDisclaimerText.
  ///
  /// In en, this message translates to:
  /// **'Body Mass Index (BMI) is an approximate statistical screening measure based on height and weight. It does not measure body fat percentage directly, nor does it account for muscle mass, bone density, or individual clinical factors. This tool is provided for educational and wellness tracking purposes only and is not a medical diagnosis. Consult a licensed physician or nutritionist for professional health assessments.'**
  String get bmiDisclaimerText;

  /// No description provided for @heightUnitCm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get heightUnitCm;

  /// No description provided for @weightUnitKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get weightUnitKg;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile & Settings'**
  String get profileTitle;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveProfile;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get nameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @yearsOld.
  ///
  /// In en, this message translates to:
  /// **'{age} years'**
  String yearsOld(Object age);

  /// No description provided for @dailyGoalsSettings.
  ///
  /// In en, this message translates to:
  /// **'Daily Goals'**
  String get dailyGoalsSettings;

  /// No description provided for @stepGoal.
  ///
  /// In en, this message translates to:
  /// **'Step Goal'**
  String get stepGoal;

  /// No description provided for @calorieGoal.
  ///
  /// In en, this message translates to:
  /// **'Calorie Goal'**
  String get calorieGoal;

  /// No description provided for @distanceGoal.
  ///
  /// In en, this message translates to:
  /// **'Distance Goal'**
  String get distanceGoal;

  /// No description provided for @activeTimeGoal.
  ///
  /// In en, this message translates to:
  /// **'Active Time Goal'**
  String get activeTimeGoal;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettings;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Application Language'**
  String get selectLanguage;

  /// No description provided for @measurementUnits.
  ///
  /// In en, this message translates to:
  /// **'Measurement Units'**
  String get measurementUnits;

  /// No description provided for @unitMetric.
  ///
  /// In en, this message translates to:
  /// **'Metric (kg, km, cm)'**
  String get unitMetric;

  /// No description provided for @unitImperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial (lb, mi, in)'**
  String get unitImperial;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSettings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out?'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your YHealth account?'**
  String get logoutConfirmDesc;

  /// No description provided for @firebaseStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync & Storage'**
  String get firebaseStatusTitle;

  /// No description provided for @firebaseConnected.
  ///
  /// In en, this message translates to:
  /// **'Firebase Cloud Connected'**
  String get firebaseConnected;

  /// No description provided for @firebaseOfflineMode.
  ///
  /// In en, this message translates to:
  /// **'Local Storage Mode (Firebase Not Configured)'**
  String get firebaseOfflineMode;

  /// No description provided for @firebaseSetupGuide.
  ///
  /// In en, this message translates to:
  /// **'Firebase Setup Information'**
  String get firebaseSetupGuide;

  /// No description provided for @firebaseGuideDesc.
  ///
  /// In en, this message translates to:
  /// **'To connect real Firebase Authentication and Cloud Firestore, place your downloaded google-services.json file inside the android/app/ directory and rebuild.'**
  String get firebaseGuideDesc;

  /// No description provided for @aboutYHealth.
  ///
  /// In en, this message translates to:
  /// **'About YHealth'**
  String get aboutYHealth;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get appVersion;

  /// No description provided for @privacyPhilosophy.
  ///
  /// In en, this message translates to:
  /// **'Minimalist design, calm aesthetics, zero unwanted tracking.'**
  String get privacyPhilosophy;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync your health journey'**
  String get loginSubtitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your mindful wellness journey today'**
  String get registerSubtitle;

  /// No description provided for @emailInput.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailInput;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailHint;

  /// No description provided for @passwordInput.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordInput;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get passwordHint;

  /// No description provided for @confirmPasswordInput.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordInput;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get confirmPasswordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email address and we\'ll send you instructions to reset your password.'**
  String get forgotPasswordDesc;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent! Check your inbox.'**
  String get resetLinkSent;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerButton;

  /// No description provided for @doNotHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get doNotHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccount;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Continue in Local Mode'**
  String get skipForNow;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get authErrorWrongPassword;

  /// No description provided for @authErrorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email.'**
  String get authErrorUserNotFound;

  /// No description provided for @authErrorResetUnavailableOffline.
  ///
  /// In en, this message translates to:
  /// **'Password recovery isn\'t available in offline mode. You can continue as a guest or create a new account.'**
  String get authErrorResetUnavailableOffline;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this email address.'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network connection error occurred. Please check your internet connection.'**
  String get authErrorNetwork;

  /// No description provided for @authErrorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many unsuccessful attempts. Please try again later.'**
  String get authErrorTooManyRequests;

  /// No description provided for @authErrorDefault.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please check your credentials.'**
  String get authErrorDefault;

  /// No description provided for @authSuccessLogin.
  ///
  /// In en, this message translates to:
  /// **'Signed in successfully!'**
  String get authSuccessLogin;

  /// No description provided for @authSuccessRegister.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get authSuccessRegister;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

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

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @savedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully'**
  String get savedSuccessfully;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @themeSettings.
  ///
  /// In en, this message translates to:
  /// **'Appearance / Theme'**
  String get themeSettings;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get themeDark;

  /// No description provided for @themeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose application color theme'**
  String get themeSubtitle;

  /// No description provided for @deviceCompatibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Device Compatibility Center'**
  String get deviceCompatibilityTitle;

  /// No description provided for @deviceCompatibilitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hardware sensors and background operation diagnostics'**
  String get deviceCompatibilitySubtitle;

  /// No description provided for @deviceInfo.
  ///
  /// In en, this message translates to:
  /// **'Device Information'**
  String get deviceInfo;

  /// No description provided for @deviceManufacturer.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get deviceManufacturer;

  /// No description provided for @deviceModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get deviceModel;

  /// No description provided for @androidVersion.
  ///
  /// In en, this message translates to:
  /// **'Android Version'**
  String get androidVersion;

  /// No description provided for @sensorDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Hardware Sensors'**
  String get sensorDiagnostics;

  /// No description provided for @stepCounterSensor.
  ///
  /// In en, this message translates to:
  /// **'Step Counter (TYPE_STEP_COUNTER)'**
  String get stepCounterSensor;

  /// No description provided for @stepDetectorSensor.
  ///
  /// In en, this message translates to:
  /// **'Step Detector (TYPE_STEP_DETECTOR)'**
  String get stepDetectorSensor;

  /// No description provided for @accelerometerSensor.
  ///
  /// In en, this message translates to:
  /// **'Accelerometer Sensor'**
  String get accelerometerSensor;

  /// No description provided for @activeTrackingMode.
  ///
  /// In en, this message translates to:
  /// **'Active Tracking Mode'**
  String get activeTrackingMode;

  /// No description provided for @sensorCounterPrimary.
  ///
  /// In en, this message translates to:
  /// **'Hardware Step Counter (Primary)'**
  String get sensorCounterPrimary;

  /// No description provided for @sensorDetectorAlternative.
  ///
  /// In en, this message translates to:
  /// **'Hardware Step Detector (Alternative)'**
  String get sensorDetectorAlternative;

  /// No description provided for @sensorNone.
  ///
  /// In en, this message translates to:
  /// **'No Hardware Sensor (Limited)'**
  String get sensorNone;

  /// No description provided for @sensorHardwareName.
  ///
  /// In en, this message translates to:
  /// **'Sensor Chip'**
  String get sensorHardwareName;

  /// No description provided for @activityRecognitionTitle.
  ///
  /// In en, this message translates to:
  /// **'Human Activity Recognition'**
  String get activityRecognitionTitle;

  /// No description provided for @activityRecognitionDesc.
  ///
  /// In en, this message translates to:
  /// **'Intelligent sensor and GPS kinematic fusion'**
  String get activityRecognitionDesc;

  /// No description provided for @activityStill.
  ///
  /// In en, this message translates to:
  /// **'Still'**
  String get activityStill;

  /// No description provided for @activityWalking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get activityWalking;

  /// No description provided for @activityRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get activityRunning;

  /// No description provided for @activityBicycle.
  ///
  /// In en, this message translates to:
  /// **'On Bicycle'**
  String get activityBicycle;

  /// No description provided for @activityVehicle.
  ///
  /// In en, this message translates to:
  /// **'In Vehicle'**
  String get activityVehicle;

  /// No description provided for @vehicleFilteringActive.
  ///
  /// In en, this message translates to:
  /// **'Vehicle distance excluded from walking stats'**
  String get vehicleFilteringActive;

  /// No description provided for @backgroundOperationTitle.
  ///
  /// In en, this message translates to:
  /// **'Background Operation'**
  String get backgroundOperationTitle;

  /// No description provided for @foregroundServiceStatus.
  ///
  /// In en, this message translates to:
  /// **'Health Service (Foreground)'**
  String get foregroundServiceStatus;

  /// No description provided for @serviceRunning.
  ///
  /// In en, this message translates to:
  /// **'Active & Running'**
  String get serviceRunning;

  /// No description provided for @serviceStopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get serviceStopped;

  /// No description provided for @notificationPermission.
  ///
  /// In en, this message translates to:
  /// **'Notification Permission'**
  String get notificationPermission;

  /// No description provided for @bootRecovery.
  ///
  /// In en, this message translates to:
  /// **'Device Reboot Recovery'**
  String get bootRecovery;

  /// No description provided for @batteryOptimizationTitle.
  ///
  /// In en, this message translates to:
  /// **'Battery Optimization & Restrictions'**
  String get batteryOptimizationTitle;

  /// No description provided for @batteryUnrestricted.
  ///
  /// In en, this message translates to:
  /// **'Unrestricted (Recommended)'**
  String get batteryUnrestricted;

  /// No description provided for @batteryRestricted.
  ///
  /// In en, this message translates to:
  /// **'Restricted (OS may pause tracking)'**
  String get batteryRestricted;

  /// No description provided for @batteryOptimizeButton.
  ///
  /// In en, this message translates to:
  /// **'Disable Battery Restrictions'**
  String get batteryOptimizeButton;

  /// No description provided for @openOemSettingsButton.
  ///
  /// In en, this message translates to:
  /// **'Open Manufacturer Settings'**
  String get openOemSettingsButton;

  /// No description provided for @manufacturerGuidance.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer-Specific Guidance'**
  String get manufacturerGuidance;

  /// No description provided for @guidanceXiaomi.
  ///
  /// In en, this message translates to:
  /// **'Xiaomi/Redmi/POCO: Enable \'Autostart\' in Security app. Set Battery saver to \'No restrictions\'.'**
  String get guidanceXiaomi;

  /// No description provided for @guidanceSamsung.
  ///
  /// In en, this message translates to:
  /// **'Samsung: Settings > Device Care > Battery > Background usage limits > Add YHealth to \'Never sleeping apps\'.'**
  String get guidanceSamsung;

  /// No description provided for @guidanceHuawei.
  ///
  /// In en, this message translates to:
  /// **'Huawei: Settings > Battery > App launch > Set YHealth to \'Manage manually\' and enable Background.'**
  String get guidanceHuawei;

  /// No description provided for @guidanceOnePlus.
  ///
  /// In en, this message translates to:
  /// **'OnePlus/OPPO/Realme: Settings > Apps > YHealth > Battery usage > Enable \'Allow background activity\' and \'Auto-launch\'.'**
  String get guidanceOnePlus;

  /// No description provided for @guidanceVivo.
  ///
  /// In en, this message translates to:
  /// **'Vivo: Settings > Battery > Enable \'High background power consumption\'.'**
  String get guidanceVivo;

  /// No description provided for @guidancePixel.
  ///
  /// In en, this message translates to:
  /// **'Google Pixel / Stock Android: Settings > Apps > YHealth > Battery > Select \'Unrestricted\'.'**
  String get guidancePixel;

  /// No description provided for @guidanceGeneral.
  ///
  /// In en, this message translates to:
  /// **'To ensure uninterrupted background step counting, set battery usage to unrestricted.'**
  String get guidanceGeneral;

  /// No description provided for @gpsTrackingStatus.
  ///
  /// In en, this message translates to:
  /// **'GPS & Location Status'**
  String get gpsTrackingStatus;

  /// No description provided for @gpsOptionalNote.
  ///
  /// In en, this message translates to:
  /// **'GPS is not required for basic step counting. Steps are counted by hardware sensors without GPS.'**
  String get gpsOptionalNote;

  /// No description provided for @supportedMethodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Supported Tracking Methods'**
  String get supportedMethodsTitle;

  /// No description provided for @supportedMethodsDesc.
  ///
  /// In en, this message translates to:
  /// **'Step counting and route recording are fully supported on this device.'**
  String get supportedMethodsDesc;

  /// No description provided for @fullyCompatible.
  ///
  /// In en, this message translates to:
  /// **'Fully Compatible'**
  String get fullyCompatible;

  /// No description provided for @partiallyCompatible.
  ///
  /// In en, this message translates to:
  /// **'Partially Compatible'**
  String get partiallyCompatible;

  /// No description provided for @attentionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Action Needed'**
  String get attentionNeeded;

  /// No description provided for @granted.
  ///
  /// In en, this message translates to:
  /// **'Granted'**
  String get granted;

  /// No description provided for @denied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get denied;

  /// No description provided for @supported.
  ///
  /// In en, this message translates to:
  /// **'Supported'**
  String get supported;

  /// No description provided for @unsupported.
  ///
  /// In en, this message translates to:
  /// **'Unsupported'**
  String get unsupported;

  /// No description provided for @vehicleDetectedWarning.
  ///
  /// In en, this message translates to:
  /// **'Vehicle transit detected — journey distance excluded from walking workout.'**
  String get vehicleDetectedWarning;

  /// No description provided for @sleepTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep Tracking'**
  String get sleepTrackingTitle;

  /// No description provided for @lastNightSleep.
  ///
  /// In en, this message translates to:
  /// **'Last Night\'s Sleep'**
  String get lastNightSleep;

  /// No description provided for @bedtime.
  ///
  /// In en, this message translates to:
  /// **'Bedtime'**
  String get bedtime;

  /// No description provided for @wakeTime.
  ///
  /// In en, this message translates to:
  /// **'Wake-up Time'**
  String get wakeTime;

  /// No description provided for @sleepDuration.
  ///
  /// In en, this message translates to:
  /// **'Sleep Duration'**
  String get sleepDuration;

  /// No description provided for @bedtimeConsistency.
  ///
  /// In en, this message translates to:
  /// **'Bedtime Consistency'**
  String get bedtimeConsistency;

  /// No description provided for @logSleep.
  ///
  /// In en, this message translates to:
  /// **'Log Sleep'**
  String get logSleep;

  /// No description provided for @editSleep.
  ///
  /// In en, this message translates to:
  /// **'Edit Sleep'**
  String get editSleep;

  /// No description provided for @deleteSleepConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this sleep record?'**
  String get deleteSleepConfirm;

  /// No description provided for @healthConnectSync.
  ///
  /// In en, this message translates to:
  /// **'Sync with Health Connect'**
  String get healthConnectSync;

  /// No description provided for @weeklyReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Reports'**
  String get weeklyReportsTitle;

  /// No description provided for @weeklySummary.
  ///
  /// In en, this message translates to:
  /// **'Weekly Summary'**
  String get weeklySummary;

  /// No description provided for @viewWeeklyReport.
  ///
  /// In en, this message translates to:
  /// **'View Weekly Report'**
  String get viewWeeklyReport;

  /// No description provided for @weeklyReportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automated Monday summary and historical insights'**
  String get weeklyReportsSubtitle;

  /// No description provided for @mostActiveDay.
  ///
  /// In en, this message translates to:
  /// **'Most Active Day'**
  String get mostActiveDay;

  /// No description provided for @weekOverWeek.
  ///
  /// In en, this message translates to:
  /// **'vs Previous Week'**
  String get weekOverWeek;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF Report'**
  String get exportPdf;

  /// No description provided for @pdfExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Report PDF exported successfully!'**
  String get pdfExportSuccess;

  /// No description provided for @noReportsYet.
  ///
  /// In en, this message translates to:
  /// **'No weekly reports generated yet'**
  String get noReportsYet;

  /// No description provided for @generateNow.
  ///
  /// In en, this message translates to:
  /// **'Generate Now'**
  String get generateNow;

  /// No description provided for @goalsMet.
  ///
  /// In en, this message translates to:
  /// **'Goals Achieved'**
  String get goalsMet;

  /// No description provided for @dailyBreakdown.
  ///
  /// In en, this message translates to:
  /// **'7-Day Breakdown'**
  String get dailyBreakdown;

  /// No description provided for @missingRecord.
  ///
  /// In en, this message translates to:
  /// **'No record'**
  String get missingRecord;

  /// No description provided for @weekNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get weekNumberLabel;

  /// No description provided for @avgSleepPerNight.
  ///
  /// In en, this message translates to:
  /// **'Avg Sleep / Night'**
  String get avgSleepPerNight;

  /// No description provided for @weightCoachTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Weight Coach'**
  String get weightCoachTitle;

  /// No description provided for @weightCoachSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personalized offline metabolic insights & guidance'**
  String get weightCoachSubtitle;

  /// No description provided for @logWeight.
  ///
  /// In en, this message translates to:
  /// **'Log Weight'**
  String get logWeight;

  /// No description provided for @currentWeight.
  ///
  /// In en, this message translates to:
  /// **'Current Weight'**
  String get currentWeight;

  /// No description provided for @targetWeight.
  ///
  /// In en, this message translates to:
  /// **'Target Weight'**
  String get targetWeight;

  /// No description provided for @timelineEstimate.
  ///
  /// In en, this message translates to:
  /// **'Estimated Timeline'**
  String get timelineEstimate;

  /// No description provided for @safeRate.
  ///
  /// In en, this message translates to:
  /// **'Safe Pacing'**
  String get safeRate;

  /// No description provided for @dailyCalorieTarget.
  ///
  /// In en, this message translates to:
  /// **'Daily Calorie Target'**
  String get dailyCalorieTarget;

  /// No description provided for @bmrLabel.
  ///
  /// In en, this message translates to:
  /// **'Basal Metabolic Rate'**
  String get bmrLabel;

  /// No description provided for @tdeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily Expenditure (TDEE)'**
  String get tdeeLabel;

  /// No description provided for @hydrationTarget.
  ///
  /// In en, this message translates to:
  /// **'Daily Water Target'**
  String get hydrationTarget;

  /// No description provided for @quickPrompts.
  ///
  /// In en, this message translates to:
  /// **'Quick Questions'**
  String get quickPrompts;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Ask your coach anything...'**
  String get typeMessage;

  /// No description provided for @weightHistory.
  ///
  /// In en, this message translates to:
  /// **'Weight History'**
  String get weightHistory;

  /// No description provided for @deleteWeightConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this weight measurement?'**
  String get deleteWeightConfirm;

  /// No description provided for @medicalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'YHealth Weight Coach provides educational lifestyle insights based on physiological formulas. It is not a clinical medical diagnosis or prescription. Always consult a physician for individual health conditions.'**
  String get medicalDisclaimer;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get backupTitle;

  /// No description provided for @backupExport.
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get backupExport;

  /// No description provided for @backupExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Save all your data to a file and share it'**
  String get backupExportDesc;

  /// No description provided for @backupImport.
  ///
  /// In en, this message translates to:
  /// **'Restore data'**
  String get backupImport;

  /// No description provided for @backupImportDesc.
  ///
  /// In en, this message translates to:
  /// **'Load data from a YHealth backup file'**
  String get backupImportDesc;

  /// No description provided for @backupImportConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore data?'**
  String get backupImportConfirmTitle;

  /// No description provided for @backupImportConfirmDesc.
  ///
  /// In en, this message translates to:
  /// **'Your current data will be replaced with the data in the backup. This can\'t be undone.'**
  String get backupImportConfirmDesc;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get backupRestore;

  /// No description provided for @backupRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data restored. The app will close now — open it again to see your data.'**
  String get backupRestoreSuccess;

  /// No description provided for @backupInvalidFile.
  ///
  /// In en, this message translates to:
  /// **'This file isn\'t a YHealth backup.'**
  String get backupInvalidFile;

  /// No description provided for @backupUnsupportedVersion.
  ///
  /// In en, this message translates to:
  /// **'This backup was made with a newer version of YHealth. Update the app first.'**
  String get backupUnsupportedVersion;

  /// No description provided for @backupExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the backup.'**
  String get backupExportFailed;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get setupTitle;

  /// No description provided for @setupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your name and age help personalize your goals and Coach Leo.'**
  String get setupSubtitle;

  /// No description provided for @setupShareConsent.
  ///
  /// In en, this message translates to:
  /// **'Share my name and age with the YHealth developer'**
  String get setupShareConsent;

  /// No description provided for @setupShareDesc.
  ///
  /// In en, this message translates to:
  /// **'Only your name and age are sent. Health data and location never leave your phone. You can turn this off anytime in Profile.'**
  String get setupShareDesc;

  /// No description provided for @setupNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get setupNameRequired;

  /// No description provided for @setupInvalidAge.
  ///
  /// In en, this message translates to:
  /// **'Enter an age between 5 and 120'**
  String get setupInvalidAge;

  /// No description provided for @shareSettingTitle.
  ///
  /// In en, this message translates to:
  /// **'Share name & age'**
  String get shareSettingTitle;

  /// No description provided for @shareSettingOn.
  ///
  /// In en, this message translates to:
  /// **'Shared with the YHealth developer'**
  String get shareSettingOn;

  /// No description provided for @shareSettingOff.
  ///
  /// In en, this message translates to:
  /// **'Not shared — stays on this phone'**
  String get shareSettingOff;
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
      <String>['az', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'az':
      return AppLocalizationsAz();
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
