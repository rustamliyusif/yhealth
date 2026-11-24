import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/database/app_database.dart';
import 'core/repositories/activity_repository.dart';
import 'core/services/database_migration_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/backup_service.dart';
import 'core/services/csv_export_service.dart';
import 'core/services/cloud_profile_service.dart';
import 'core/services/firebase_service.dart';
import 'core/providers/language_provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/step_counter_provider.dart';
import 'core/providers/activity_provider.dart';
import 'core/providers/health_provider.dart';
import 'core/providers/sleep_provider.dart';
import 'core/providers/water_provider.dart';
import 'core/providers/reminder_provider.dart';
import 'core/providers/health_sync_provider.dart';
import 'core/providers/weekly_report_provider.dart';
import 'core/providers/weight_coach_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'features/onboarding/language_selection_screen.dart';
import 'features/navigation/main_navigation_screen.dart';
import 'features/onboarding/profile_setup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Local Storage Service
  final storageService = await StorageService.init();

  // Initialize Local Drift Database and Repository
  final appDatabase = AppDatabase();
  final activityRepository = DriftActivityRepository(appDatabase);

  // Safe one-time migration from SharedPreferences to Drift (non-destructive)
  await DatabaseMigrationService.migrateFromSharedPreferences(
    storageService: storageService,
    activityRepository: activityRepository,
  );

  final cloudProfileService = await CloudProfileService.init(storageService);
  cloudProfileService.sync();

  // Initialize Firebase (safely handles missing credentials with local fallback)
  await FirebaseService.initialize();
  final firebaseService = FirebaseService();

  // Create StepCounterProvider and ActivityProvider, and wire GPS speed updates
  final stepCounterProvider = StepCounterProvider(
    storageService,
    activityRepository: activityRepository,
  );
  final activityProvider = ActivityProvider(
    storageService,
    firebaseService,
    activityRepository,
  );
  final sleepProvider = SleepProvider(activityRepository);
  final weightCoachProvider = WeightCoachProvider(activityRepository, storageService);
  activityProvider.onSpeedUpdate = (speed) {
    stepCounterProvider.updateGpsSpeed(speed);
  };

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: appDatabase),
        Provider<ActivityRepository>.value(value: activityRepository),
        Provider<BackupService>.value(value: BackupService(appDatabase, storageService)),
        Provider<CsvExportService>.value(value: CsvExportService(appDatabase, storageService)),
        ChangeNotifierProvider(create: (_) => ThemeProvider(storageService)),
        ChangeNotifierProvider(create: (_) => LanguageProvider(storageService)),
        ChangeNotifierProvider(create: (_) => AuthProvider(storageService, firebaseService, cloudProfileService)),
        ChangeNotifierProvider.value(value: stepCounterProvider),
        ChangeNotifierProvider.value(value: activityProvider),
        ChangeNotifierProvider(create: (_) => HealthProvider(storageService)),
        ChangeNotifierProvider.value(value: sleepProvider),
        ChangeNotifierProvider(create: (_) => WaterProvider(storageService)),
        ChangeNotifierProvider(create: (_) => ReminderProvider(storageService)),
        ChangeNotifierProvider(create: (_) => WeeklyReportProvider(activityRepository)),
        ChangeNotifierProvider.value(value: weightCoachProvider),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => HealthSyncProvider(storageService, stepCounterProvider, sleepProvider, weightCoachProvider),
        ),
      ],
      child: const YHealthApp(),
    ),
  );
}

class YHealthApp extends StatelessWidget {
  const YHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final profileSetupDone = context.select<AuthProvider, bool>((a) => a.profileSetupDone);

    Widget homeScreen;
    if (!languageProvider.hasSelectedInitialLanguage) {
      homeScreen = const LanguageSelectionScreen();
    } else if (!profileSetupDone) {
      homeScreen = const ProfileSetupScreen();
    } else {
      homeScreen = const MainNavigationScreen();
    }

    return MaterialApp(
      title: 'YHealth',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      locale: languageProvider.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: homeScreen,
    );
  }
}
