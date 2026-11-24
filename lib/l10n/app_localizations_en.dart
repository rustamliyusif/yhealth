// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'YHealth';

  @override
  String get welcomeTitle => 'Welcome to YHealth';

  @override
  String get welcomeSubtitle =>
      'Your minimalist, mindful companion for daily health, walking routes, and mindful activity tracking.';

  @override
  String get chooseLanguage => 'Choose Your Language';

  @override
  String get chooseLanguageSubtitle =>
      'Select your preferred language to continue';

  @override
  String get azerbaijani => 'Azərbaycan dili';

  @override
  String get english => 'English';

  @override
  String get continueButton => 'Continue';

  @override
  String get getStarted => 'Get Started';

  @override
  String get navHome => 'Home';

  @override
  String get navActivity => 'Activity';

  @override
  String get navHealth => 'Health';

  @override
  String get navProfile => 'Profile';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get dailySummary => 'Daily Overview';

  @override
  String get todayProgress => 'Today\'s Progress';

  @override
  String get stepsLabel => 'Steps';

  @override
  String get distanceLabel => 'Distance';

  @override
  String get caloriesLabel => 'Calories';

  @override
  String get activeTimeLabel => 'Active Time';

  @override
  String goalTarget(Object target) {
    return 'Goal: $target';
  }

  @override
  String get goalReached => 'Goal achieved! Excellent work!';

  @override
  String stepsRemaining(Object count) {
    return '$count steps to reach your goal';
  }

  @override
  String get dailyGoalsTitle => 'Daily Goals';

  @override
  String get kmUnit => 'km';

  @override
  String get kcalUnit => 'kcal';

  @override
  String get minUnit => 'min';

  @override
  String get stepsUnit => 'steps';

  @override
  String get weeklyOverview => 'Weekly Activity';

  @override
  String get quickStartWalk => 'Start Walking';

  @override
  String get viewDetails => 'View Details';

  @override
  String get activityTitle => 'Activity & GPS';

  @override
  String get activitySubtitle => 'Live route tracking with OpenStreetMap';

  @override
  String get startWalk => 'Start Walk';

  @override
  String get pauseWalk => 'Pause';

  @override
  String get resumeWalk => 'Resume';

  @override
  String get stopWalk => 'Finish & Save';

  @override
  String get liveTracking => 'Live Tracking';

  @override
  String get duration => 'Duration';

  @override
  String get avgSpeed => 'Avg Speed';

  @override
  String get currentSpeed => 'Speed';

  @override
  String get pace => 'Pace';

  @override
  String get caloriesBurned => 'Burned Calories';

  @override
  String get mapAttribution => '© OpenStreetMap contributors';

  @override
  String get routeHistoryTitle => 'Route History';

  @override
  String get noRoutesYet => 'No recorded routes yet';

  @override
  String get noRoutesDesc =>
      'Start your first walking or running session to record your path on OpenStreetMap.';

  @override
  String get routeSavedSuccess => 'Route saved successfully!';

  @override
  String get finishRouteConfirmation =>
      'Are you sure you want to finish this session?';

  @override
  String get finishRouteTitle => 'Finish Activity';

  @override
  String get discard => 'Discard';

  @override
  String get saveRoute => 'Save Route';

  @override
  String get sessionRecorded => 'Session Summary';

  @override
  String get speedUnitKmH => 'km/h';

  @override
  String get paceUnitMinKm => 'min/km';

  @override
  String get gpsPermissionRequired => 'GPS Location Permission Required';

  @override
  String get gpsPermissionDesc =>
      'YHealth requires your precise location to track walking routes, calculate accurate distance, and display your path on OpenStreetMap.';

  @override
  String get permissionDenied => 'Location permission was denied.';

  @override
  String get permissionPermanentlyDenied =>
      'Location permission is permanently denied. Please enable it in system settings.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get locationConsentNote =>
      'YHealth never tracks your location without your explicit consent.';

  @override
  String get androidLocationInfo => 'Android Location & Background Limits';

  @override
  String get androidLocationDesc =>
      'To conserve battery, Android limits background GPS tracking unless a foreground service is active. Live recording runs with continuous GPS while the session is active.';

  @override
  String get stepCounterTitle => 'Step Counter';

  @override
  String get stepStatistics => 'Step Analytics';

  @override
  String get hardwareSensorStatus => 'Hardware Sensor Status';

  @override
  String get sensorActive => 'Physical sensor connected and active';

  @override
  String get sensorUnavailable =>
      'Hardware step sensor not detected on this device or emulator';

  @override
  String get sensorExplanation =>
      'Step detection relies on your phone\'s built-in pedometer hardware (STEP_COUNTER / STEP_DETECTOR). Most emulators do not have physical motion sensors.';

  @override
  String get sensorPermissionRequired =>
      'Physical Activity Permission Required';

  @override
  String get sensorPermissionDesc =>
      'To count steps accurately throughout the day, YHealth needs permission to access your device\'s activity recognition sensor.';

  @override
  String get dailySteps => 'Daily Steps';

  @override
  String get weeklySteps => 'Weekly';

  @override
  String get monthlySteps => 'Monthly';

  @override
  String get averageSteps => 'Daily Average';

  @override
  String get simulateStepTitle => 'Test Sensor Simulation';

  @override
  String get simulateStepDesc =>
      'Since emulator hardware lacks physical accelerometer steps, you can simulate steps for testing.';

  @override
  String get addTestSteps => '+500 Test Steps';

  @override
  String get sensorCompatibilityNotice =>
      'Hardware Compatibility Notice: Phone step counter sensors require physical motion. Real hardware step counters do not increment when stationary.';

  @override
  String get bmiTitle => 'BMI Calculator';

  @override
  String get bmiSubtitle => 'Body Mass Index assessment & guidance';

  @override
  String get heightLabel => 'Height';

  @override
  String get weightLabel => 'Weight';

  @override
  String get calculateBmi => 'Calculate BMI';

  @override
  String get recalculate => 'Recalculate';

  @override
  String get yourBmiIs => 'Your Body Mass Index is';

  @override
  String get bmiCategory => 'Category';

  @override
  String healthyWeightRange(Object max, Object min) {
    return 'Healthy weight range for your height: $min kg – $max kg';
  }

  @override
  String get categoryUnderweight => 'Underweight';

  @override
  String get categoryNormal => 'Normal weight';

  @override
  String get categoryOverweight => 'Overweight';

  @override
  String get categoryObese => 'Obese';

  @override
  String get bmiExplanationUnderweight =>
      'Your BMI indicates underweight. Consider nutrient-rich balanced meals and consult a healthcare provider for personalized nutritional advice.';

  @override
  String get bmiExplanationNormal =>
      'Your BMI falls in the healthy weight range. Maintain regular walking, mindful nutrition, and consistent physical activity.';

  @override
  String get bmiExplanationOverweight =>
      'Your BMI indicates slight overweight. Increasing daily walking distance and mindful dietary adjustments can help reach an optimal range.';

  @override
  String get bmiExplanationObese =>
      'Your BMI falls into the obese category. Prioritizing structured daily low-impact exercise like walking and consulting a medical professional is recommended.';

  @override
  String get bmiDisclaimerTitle => 'Important Medical Disclaimer';

  @override
  String get bmiDisclaimerText =>
      'Body Mass Index (BMI) is an approximate statistical screening measure based on height and weight. It does not measure body fat percentage directly, nor does it account for muscle mass, bone density, or individual clinical factors. This tool is provided for educational and wellness tracking purposes only and is not a medical diagnosis. Consult a licensed physician or nutritionist for professional health assessments.';

  @override
  String get heightUnitCm => 'cm';

  @override
  String get weightUnitKg => 'kg';

  @override
  String get profileTitle => 'Profile & Settings';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get saveProfile => 'Save Changes';

  @override
  String get nameLabel => 'Full Name';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get ageLabel => 'Age';

  @override
  String yearsOld(Object age) {
    return '$age years';
  }

  @override
  String get dailyGoalsSettings => 'Daily Goals';

  @override
  String get stepGoal => 'Step Goal';

  @override
  String get calorieGoal => 'Calorie Goal';

  @override
  String get distanceGoal => 'Distance Goal';

  @override
  String get activeTimeGoal => 'Active Time Goal';

  @override
  String get languageSettings => 'Language';

  @override
  String get selectLanguage => 'Application Language';

  @override
  String get measurementUnits => 'Measurement Units';

  @override
  String get unitMetric => 'Metric (kg, km, cm)';

  @override
  String get unitImperial => 'Imperial (lb, mi, in)';

  @override
  String get accountSettings => 'Account';

  @override
  String get logout => 'Log Out';

  @override
  String get logoutConfirmTitle => 'Log Out?';

  @override
  String get logoutConfirmDesc =>
      'Are you sure you want to log out of your YHealth account?';

  @override
  String get firebaseStatusTitle => 'Cloud Sync & Storage';

  @override
  String get firebaseConnected => 'Firebase Cloud Connected';

  @override
  String get firebaseOfflineMode =>
      'Local Storage Mode (Firebase Not Configured)';

  @override
  String get firebaseSetupGuide => 'Firebase Setup Information';

  @override
  String get firebaseGuideDesc =>
      'To connect real Firebase Authentication and Cloud Firestore, place your downloaded google-services.json file inside the android/app/ directory and rebuild.';

  @override
  String get aboutYHealth => 'About YHealth';

  @override
  String get appVersion => 'Version 1.0.0';

  @override
  String get privacyPhilosophy =>
      'Minimalist design, calm aesthetics, zero unwanted tracking.';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginSubtitle => 'Sign in to sync your health journey';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle => 'Start your mindful wellness journey today';

  @override
  String get emailInput => 'Email Address';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get passwordInput => 'Password';

  @override
  String get passwordHint => '••••••••';

  @override
  String get confirmPasswordInput => 'Confirm Password';

  @override
  String get confirmPasswordHint => '••••••••';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get forgotPasswordTitle => 'Reset Password';

  @override
  String get forgotPasswordDesc =>
      'Enter your registered email address and we\'ll send you instructions to reset your password.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get resetLinkSent => 'Password reset email sent! Check your inbox.';

  @override
  String get loginButton => 'Sign In';

  @override
  String get registerButton => 'Create Account';

  @override
  String get doNotHaveAccount => 'Don\'t have an account? Sign up';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get skipForNow => 'Continue in Local Mode';

  @override
  String get authErrorInvalidEmail => 'Please enter a valid email address.';

  @override
  String get authErrorWrongPassword => 'Incorrect password. Please try again.';

  @override
  String get authErrorUserNotFound => 'No account found with this email.';

  @override
  String get authErrorResetUnavailableOffline =>
      'Password recovery isn\'t available in offline mode. You can continue as a guest or create a new account.';

  @override
  String get authErrorWeakPassword => 'Password must be at least 6 characters.';

  @override
  String get authErrorEmailInUse =>
      'An account already exists with this email address.';

  @override
  String get authErrorNetwork =>
      'Network connection error occurred. Please check your internet connection.';

  @override
  String get authErrorTooManyRequests =>
      'Too many unsuccessful attempts. Please try again later.';

  @override
  String get authErrorDefault =>
      'Authentication failed. Please check your credentials.';

  @override
  String get authSuccessLogin => 'Signed in successfully!';

  @override
  String get authSuccessRegister => 'Account created successfully!';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get savedSuccessfully => 'Changes saved successfully';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get ok => 'OK';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get themeSettings => 'Appearance / Theme';

  @override
  String get themeLight => 'Light Mode';

  @override
  String get themeDark => 'Dark Mode';

  @override
  String get themeSubtitle => 'Choose application color theme';

  @override
  String get deviceCompatibilityTitle => 'Device Compatibility Center';

  @override
  String get deviceCompatibilitySubtitle =>
      'Hardware sensors and background operation diagnostics';

  @override
  String get deviceInfo => 'Device Information';

  @override
  String get deviceManufacturer => 'Manufacturer';

  @override
  String get deviceModel => 'Model';

  @override
  String get androidVersion => 'Android Version';

  @override
  String get sensorDiagnostics => 'Hardware Sensors';

  @override
  String get stepCounterSensor => 'Step Counter (TYPE_STEP_COUNTER)';

  @override
  String get stepDetectorSensor => 'Step Detector (TYPE_STEP_DETECTOR)';

  @override
  String get accelerometerSensor => 'Accelerometer Sensor';

  @override
  String get activeTrackingMode => 'Active Tracking Mode';

  @override
  String get sensorCounterPrimary => 'Hardware Step Counter (Primary)';

  @override
  String get sensorDetectorAlternative =>
      'Hardware Step Detector (Alternative)';

  @override
  String get sensorNone => 'No Hardware Sensor (Limited)';

  @override
  String get sensorHardwareName => 'Sensor Chip';

  @override
  String get activityRecognitionTitle => 'Human Activity Recognition';

  @override
  String get activityRecognitionDesc =>
      'Intelligent sensor and GPS kinematic fusion';

  @override
  String get activityStill => 'Still';

  @override
  String get activityWalking => 'Walking';

  @override
  String get activityRunning => 'Running';

  @override
  String get activityBicycle => 'On Bicycle';

  @override
  String get activityVehicle => 'In Vehicle';

  @override
  String get vehicleFilteringActive =>
      'Vehicle distance excluded from walking stats';

  @override
  String get backgroundOperationTitle => 'Background Operation';

  @override
  String get foregroundServiceStatus => 'Health Service (Foreground)';

  @override
  String get serviceRunning => 'Active & Running';

  @override
  String get serviceStopped => 'Stopped';

  @override
  String get notificationPermission => 'Notification Permission';

  @override
  String get bootRecovery => 'Device Reboot Recovery';

  @override
  String get batteryOptimizationTitle => 'Battery Optimization & Restrictions';

  @override
  String get batteryUnrestricted => 'Unrestricted (Recommended)';

  @override
  String get batteryRestricted => 'Restricted (OS may pause tracking)';

  @override
  String get batteryOptimizeButton => 'Disable Battery Restrictions';

  @override
  String get openOemSettingsButton => 'Open Manufacturer Settings';

  @override
  String get manufacturerGuidance => 'Manufacturer-Specific Guidance';

  @override
  String get guidanceXiaomi =>
      'Xiaomi/Redmi/POCO: Enable \'Autostart\' in Security app. Set Battery saver to \'No restrictions\'.';

  @override
  String get guidanceSamsung =>
      'Samsung: Settings > Device Care > Battery > Background usage limits > Add YHealth to \'Never sleeping apps\'.';

  @override
  String get guidanceHuawei =>
      'Huawei: Settings > Battery > App launch > Set YHealth to \'Manage manually\' and enable Background.';

  @override
  String get guidanceOnePlus =>
      'OnePlus/OPPO/Realme: Settings > Apps > YHealth > Battery usage > Enable \'Allow background activity\' and \'Auto-launch\'.';

  @override
  String get guidanceVivo =>
      'Vivo: Settings > Battery > Enable \'High background power consumption\'.';

  @override
  String get guidancePixel =>
      'Google Pixel / Stock Android: Settings > Apps > YHealth > Battery > Select \'Unrestricted\'.';

  @override
  String get guidanceGeneral =>
      'To ensure uninterrupted background step counting, set battery usage to unrestricted.';

  @override
  String get gpsTrackingStatus => 'GPS & Location Status';

  @override
  String get gpsOptionalNote =>
      'GPS is not required for basic step counting. Steps are counted by hardware sensors without GPS.';

  @override
  String get supportedMethodsTitle => 'Supported Tracking Methods';

  @override
  String get supportedMethodsDesc =>
      'Step counting and route recording are fully supported on this device.';

  @override
  String get fullyCompatible => 'Fully Compatible';

  @override
  String get partiallyCompatible => 'Partially Compatible';

  @override
  String get attentionNeeded => 'Action Needed';

  @override
  String get granted => 'Granted';

  @override
  String get denied => 'Denied';

  @override
  String get supported => 'Supported';

  @override
  String get unsupported => 'Unsupported';

  @override
  String get vehicleDetectedWarning =>
      'Vehicle transit detected — journey distance excluded from walking workout.';

  @override
  String get sleepTrackingTitle => 'Sleep Tracking';

  @override
  String get lastNightSleep => 'Last Night\'s Sleep';

  @override
  String get bedtime => 'Bedtime';

  @override
  String get wakeTime => 'Wake-up Time';

  @override
  String get sleepDuration => 'Sleep Duration';

  @override
  String get bedtimeConsistency => 'Bedtime Consistency';

  @override
  String get logSleep => 'Log Sleep';

  @override
  String get editSleep => 'Edit Sleep';

  @override
  String get deleteSleepConfirm =>
      'Are you sure you want to delete this sleep record?';

  @override
  String get healthConnectSync => 'Sync with Health Connect';

  @override
  String get weeklyReportsTitle => 'Weekly Reports';

  @override
  String get weeklySummary => 'Weekly Summary';

  @override
  String get viewWeeklyReport => 'View Weekly Report';

  @override
  String get weeklyReportsSubtitle =>
      'Automated Monday summary and historical insights';

  @override
  String get mostActiveDay => 'Most Active Day';

  @override
  String get weekOverWeek => 'vs Previous Week';

  @override
  String get exportPdf => 'Export PDF Report';

  @override
  String get pdfExportSuccess => 'Report PDF exported successfully!';

  @override
  String get noReportsYet => 'No weekly reports generated yet';

  @override
  String get generateNow => 'Generate Now';

  @override
  String get goalsMet => 'Goals Achieved';

  @override
  String get dailyBreakdown => '7-Day Breakdown';

  @override
  String get missingRecord => 'No record';

  @override
  String get weekNumberLabel => 'Week';

  @override
  String get avgSleepPerNight => 'Avg Sleep / Night';

  @override
  String get weightCoachTitle => 'AI Weight Coach';

  @override
  String get weightCoachSubtitle =>
      'Personalized offline metabolic insights & guidance';

  @override
  String get logWeight => 'Log Weight';

  @override
  String get currentWeight => 'Current Weight';

  @override
  String get targetWeight => 'Target Weight';

  @override
  String get timelineEstimate => 'Estimated Timeline';

  @override
  String get safeRate => 'Safe Pacing';

  @override
  String get dailyCalorieTarget => 'Daily Calorie Target';

  @override
  String get bmrLabel => 'Basal Metabolic Rate';

  @override
  String get tdeeLabel => 'Daily Expenditure (TDEE)';

  @override
  String get hydrationTarget => 'Daily Water Target';

  @override
  String get quickPrompts => 'Quick Questions';

  @override
  String get typeMessage => 'Ask your coach anything...';

  @override
  String get weightHistory => 'Weight History';

  @override
  String get deleteWeightConfirm =>
      'Are you sure you want to delete this weight measurement?';

  @override
  String get medicalDisclaimer =>
      'YHealth Weight Coach provides educational lifestyle insights based on physiological formulas. It is not a clinical medical diagnosis or prescription. Always consult a physician for individual health conditions.';

  @override
  String get backupTitle => 'Backup & restore';

  @override
  String get backupExport => 'Export data';

  @override
  String get backupExportDesc => 'Save all your data to a file and share it';

  @override
  String get backupImport => 'Restore data';

  @override
  String get backupImportDesc => 'Load data from a YHealth backup file';

  @override
  String get backupImportConfirmTitle => 'Restore data?';

  @override
  String get backupImportConfirmDesc =>
      'Your current data will be replaced with the data in the backup. This can\'t be undone.';

  @override
  String get backupRestore => 'Restore';

  @override
  String get backupRestoreSuccess =>
      'Data restored. The app will close now — open it again to see your data.';

  @override
  String get backupInvalidFile => 'This file isn\'t a YHealth backup.';

  @override
  String get backupUnsupportedVersion =>
      'This backup was made with a newer version of YHealth. Update the app first.';

  @override
  String get backupExportFailed => 'Couldn\'t create the backup.';

  @override
  String get setupTitle => 'About you';

  @override
  String get setupSubtitle =>
      'Your name and age help personalize your goals and Coach Leo.';

  @override
  String get setupShareConsent =>
      'Share my name and age with the YHealth developer';

  @override
  String get setupShareDesc =>
      'Only your name and age are sent. Health data and location never leave your phone. You can turn this off anytime in Profile.';

  @override
  String get setupNameRequired => 'Enter your name';

  @override
  String get setupInvalidAge => 'Enter an age between 5 and 120';

  @override
  String get shareSettingTitle => 'Share name & age';

  @override
  String get shareSettingOn => 'Shared with the YHealth developer';

  @override
  String get shareSettingOff => 'Not shared — stays on this phone';

  @override
  String get waterTitle => 'Water';

  @override
  String get waterGoalTitle => 'Daily water goal';

  @override
  String get waterGoalReached => 'Today\'s water goal reached 💧';

  @override
  String waterRemaining(String amount) {
    return '$amount ml to go';
  }

  @override
  String waterRecommended(String amount) {
    return 'Recommended for your weight: $amount ml';
  }

  @override
  String get mlUnit => 'ml';

  @override
  String get remindersTitle => 'Reminders';

  @override
  String get remindersSubtitle => 'Water, movement, quiet hours';

  @override
  String get reminderWaterTitle => 'Water';

  @override
  String get reminderWaterDesc =>
      'Only when you fall behind your daily water goal';

  @override
  String get reminderMoveTitle => 'Movement';

  @override
  String get reminderMoveDesc =>
      'After an inactive hour, plus an evening nudge near your step goal';

  @override
  String get quietHoursTitle => 'Quiet hours';

  @override
  String get quietHoursDesc => 'No reminders during this time';

  @override
  String get quietFrom => 'From';

  @override
  String get quietTo => 'To';

  @override
  String get reminderTest => 'Send test reminder';

  @override
  String get reminderTestSent => 'Test reminder sent';

  @override
  String get remindersFootnote =>
      'Reminders run on your phone, even when the app is closed.';

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String get streakLabel => 'day streak';

  @override
  String get streakBestLabel => 'best streak';

  @override
  String get totalStepsLabel => 'total steps';

  @override
  String get streakTodayDone => 'Today\'s goal done ✅';

  @override
  String get streakTodayPending => 'Reach your goal today to keep it going';

  @override
  String get badgeFirstGoal => 'First goal';

  @override
  String get badgeFirstGoalDesc => 'Reach your daily step goal once';

  @override
  String get badgeStreak3 => '3-day streak';

  @override
  String get badgeStreak3Desc => 'Hit your goal 3 days in a row';

  @override
  String get badgeStreak7 => 'Week warrior';

  @override
  String get badgeStreak7Desc => 'Hit your goal 7 days in a row';

  @override
  String get badgeStreak30 => 'Unstoppable';

  @override
  String get badgeStreak30Desc => 'Hit your goal 30 days in a row';

  @override
  String get badgeDay10k => '10K day';

  @override
  String get badgeDay10kDesc => 'Walk 10,000 steps in one day';

  @override
  String get badgeDay20k => '20K day';

  @override
  String get badgeDay20kDesc => 'Walk 20,000 steps in one day';

  @override
  String get badgeTotal100k => '100K club';

  @override
  String get badgeTotal100kDesc => '100,000 steps in total';

  @override
  String get badgeTotal500k => 'Half a million';

  @override
  String get badgeTotal500kDesc => '500,000 steps in total';

  @override
  String get badgeTotal1m => 'Millionaire';

  @override
  String get badgeTotal1mDesc => '1,000,000 steps in total';

  @override
  String get badgeWater1 => 'Hydrated';

  @override
  String get badgeWater1Desc => 'Reach your water goal once';

  @override
  String get badgeWater7 => 'Water week';

  @override
  String get badgeWater7Desc => 'Reach your water goal on 7 days';

  @override
  String streakBest(int count) {
    return 'Best: $count';
  }

  @override
  String badgesEarned(int earned, int total) {
    return '$earned/$total badges';
  }

  @override
  String get coachTipTitle => 'Today\'s tip';

  @override
  String get csvExport => 'Export data (CSV)';

  @override
  String get csvExportDesc =>
      'Steps, sleep, weight and water by day, opens in Excel';

  @override
  String get hcNotConnected => 'Not connected';

  @override
  String get hcNotInstalled => 'Health Connect is not installed';

  @override
  String get hcUnsupported => 'This phone doesn\'t support Health Connect';

  @override
  String get hcConnect => 'Connect';

  @override
  String get hcOpenShort => 'Open';

  @override
  String get hcSyncNow => 'Sync now';

  @override
  String get hcOpenSettings => 'Health Connect settings';

  @override
  String get hcInstall => 'Install Health Connect';

  @override
  String get hcReadSleep => 'Sleep → YHealth';

  @override
  String get hcReadWeight => 'Weight → YHealth';

  @override
  String get hcWriteSteps => 'Steps → Health Connect';

  @override
  String get hcWriteWater => 'Water → Health Connect';

  @override
  String get hcPermissionDenied => 'Permission was not granted';

  @override
  String get hcNever => 'not yet';

  @override
  String get hcSamsungHint =>
      'To get sleep and weight from Samsung Health: Samsung Health → Settings → Health Connect, and allow sharing.';

  @override
  String hcConnected(String time) {
    return 'Connected • last sync: $time';
  }

  @override
  String hcSyncResult(int sleep, int weight) {
    return 'Sync done: $sleep sleep, $weight weight records added';
  }

  @override
  String get sleepHistoryTitle => 'Sleep history';

  @override
  String get sleepEmptyHistory =>
      'No sleep records yet. Tap "Log sleep" to begin.';

  @override
  String get sleepSourceManual => 'Manual entry';

  @override
  String get sleepStagesTitle => 'Sleep stages';

  @override
  String get sleepStagesBadge => 'From wearable';

  @override
  String get stageDeep => 'Deep';

  @override
  String get stageLight => 'Light';

  @override
  String get stageAwake => 'Awake';

  @override
  String get sleepStagesHint =>
      'Sleep stages need a smartwatch synced via Health Connect.';

  @override
  String get sleepEmptyTitle => 'Track your sleep';

  @override
  String get sleepEmptyDesc =>
      'Log your bedtime and wake-up time to see consistency and duration trends.';

  @override
  String get sleepOvernight => 'Overnight';

  @override
  String get editLabel => 'Edit';

  @override
  String get deleteLabel => 'Delete';

  @override
  String get sleepDeleteTitle => 'Delete sleep record';

  @override
  String get consistencyGathering => 'Gathering data...';

  @override
  String get sleepDialogEdit => 'Edit sleep record';

  @override
  String get sleepDialogLocal => 'Stored on this phone';

  @override
  String get sleepWakeDate => 'Wake-up date';

  @override
  String get sleepInvalidDuration => 'Invalid duration';

  @override
  String get sleepOvernightSession => 'Overnight session (crosses midnight)';

  @override
  String get sleepSameDay => 'Same-day session';

  @override
  String get sleepQuality => 'Sleep quality / efficiency';

  @override
  String get sleepNotes => 'Notes (optional)';

  @override
  String get sleepNotesHint => 'e.g. Restful sleep, drank chamomile tea';

  @override
  String get saveChanges => 'Save changes';

  @override
  String sleepRecordsCount(int count) {
    return '$count records';
  }

  @override
  String sleepEfficiency(int value) {
    return 'Efficiency: $value%';
  }

  @override
  String sleepAvg7(String value) {
    return '7-day average: $value';
  }

  @override
  String consistencyHigh(int minutes) {
    return 'High consistency (±$minutesm)';
  }

  @override
  String consistencyModerate(int minutes) {
    return 'Moderate consistency (±$minutesm)';
  }

  @override
  String consistencyVariable(int minutes) {
    return 'Variable bedtimes (±$minutesm)';
  }

  @override
  String durationHm(int hours, int minutes) {
    return '$hoursh $minutesm';
  }

  @override
  String sleepTotal(String value) {
    return 'Total sleep: $value';
  }
}
