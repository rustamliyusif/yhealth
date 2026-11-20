// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Azerbaijani (`az`).
class AppLocalizationsAz extends AppLocalizations {
  AppLocalizationsAz([String locale = 'az']) : super(locale);

  @override
  String get appName => 'YHealth';

  @override
  String get welcomeTitle => 'YHealth tətbiqinə xoş gəlmisiniz';

  @override
  String get welcomeSubtitle =>
      'Gündəlik sağlamlıq, addım və gəzinti marşrutlarınızı izləyən minimalist və rahat yardımçınız.';

  @override
  String get chooseLanguage => 'Dil seçin';

  @override
  String get chooseLanguageSubtitle =>
      'Davam etmək üçün istədiyiniz dili seçin';

  @override
  String get azerbaijani => 'Azərbaycan dili';

  @override
  String get english => 'English';

  @override
  String get continueButton => 'Davam et';

  @override
  String get getStarted => 'Başla';

  @override
  String get navHome => 'Əsas';

  @override
  String get navActivity => 'Fəaliyyət';

  @override
  String get navHealth => 'Sağlamlıq';

  @override
  String get navProfile => 'Profil';

  @override
  String get greetingMorning => 'Sabahınız xeyir';

  @override
  String get greetingAfternoon => 'Hər vaxtınız xeyir';

  @override
  String get greetingEvening => 'Axşamınız xeyir';

  @override
  String get dailySummary => 'Gündəlik xülasə';

  @override
  String get todayProgress => 'Bugünkü irəliləyiş';

  @override
  String get stepsLabel => 'Addımlar';

  @override
  String get distanceLabel => 'Məsafə';

  @override
  String get caloriesLabel => 'Kalori';

  @override
  String get activeTimeLabel => 'Fəal vaxt';

  @override
  String goalTarget(Object target) {
    return 'Hədəf: $target';
  }

  @override
  String get goalReached => 'Hədəfə çatdınız! Əla nəticə!';

  @override
  String stepsRemaining(Object count) {
    return 'Hədəfə $count addım qaldı';
  }

  @override
  String get dailyGoalsTitle => 'Gündəlik hədəflər';

  @override
  String get kmUnit => 'km';

  @override
  String get kcalUnit => 'kkal';

  @override
  String get minUnit => 'dəq';

  @override
  String get stepsUnit => 'addım';

  @override
  String get weeklyOverview => 'Həftəlik fəaliyyət';

  @override
  String get quickStartWalk => 'Gəzintiyə başla';

  @override
  String get viewDetails => 'Ətraflı bax';

  @override
  String get activityTitle => 'Fəaliyyət və GPS';

  @override
  String get activitySubtitle => 'OpenStreetMap ilə canlı marşrut izləmə';

  @override
  String get startWalk => 'Gəzintiyə başla';

  @override
  String get pauseWalk => 'Fasilə';

  @override
  String get resumeWalk => 'Davam et';

  @override
  String get stopWalk => 'Bitir və saxla';

  @override
  String get liveTracking => 'Canlı izləmə';

  @override
  String get duration => 'Müddət';

  @override
  String get avgSpeed => 'Orta sürət';

  @override
  String get currentSpeed => 'Sürət';

  @override
  String get pace => 'Temp';

  @override
  String get caloriesBurned => 'Yandırılan kalori';

  @override
  String get mapAttribution => '© OpenStreetMap müəllifləri';

  @override
  String get routeHistoryTitle => 'Marşrut tarixçəsi';

  @override
  String get noRoutesYet => 'Hələlik qeydə alınmış marşrut yoxdur';

  @override
  String get noRoutesDesc =>
      'OpenStreetMap xəritəsində yolunuzu qeyd etmək üçün ilk gəzinti və ya qaçış fəaliyyətinizə başlayın.';

  @override
  String get routeSavedSuccess => 'Marşrut uğurla yadda saxlanıldı!';

  @override
  String get finishRouteConfirmation =>
      'Bu fəaliyyəti bitirmək istədiyinizə əminsiniz?';

  @override
  String get finishRouteTitle => 'Fəaliyyəti bitir';

  @override
  String get discard => 'İmtina et';

  @override
  String get saveRoute => 'Marşrutu saxla';

  @override
  String get sessionRecorded => 'Fəaliyyət xülasəsi';

  @override
  String get speedUnitKmH => 'km/saat';

  @override
  String get paceUnitMinKm => 'dəq/km';

  @override
  String get gpsPermissionRequired => 'GPS Məkan icazəsi tələb olunur';

  @override
  String get gpsPermissionDesc =>
      'YHealth gəzinti marşrutlarınızı dəqiq izləmək, məsafəni hesablamaq və OpenStreetMap-də göstərmək üçün dəqiq məkan məlumatına ehtiyac duyur.';

  @override
  String get permissionDenied => 'Məkan icazəsi rədd edildi.';

  @override
  String get permissionPermanentlyDenied =>
      'Məkan icazəsi həmişəlik rədd edilib. Zəhmət olmasa, cihaz parametrlərindən aktiv edin.';

  @override
  String get openSettings => 'Parametrləri aç';

  @override
  String get locationConsentNote =>
      'YHealth heç vaxt açıq razılığınız olmadan məkanınızı izləmir.';

  @override
  String get androidLocationInfo => 'Android məkan və arxa fon məhdudiyyətləri';

  @override
  String get androidLocationDesc =>
      'Batareyaya qənaət etmək üçün Android ön fon xidməti aktiv olmadıqda arxa fonda GPS izləməni məhdudlaşdırır. Canlı qeydiyyat fəaliyyət davam etdikcə fasiləsiz işləyir.';

  @override
  String get stepCounterTitle => 'Addımölçən';

  @override
  String get stepStatistics => 'Addım statistikası';

  @override
  String get hardwareSensorStatus => 'Cihaz sensorunun vəziyyəti';

  @override
  String get sensorActive => 'Fiziki sensor qoşulub və aktivdir';

  @override
  String get sensorUnavailable =>
      'Bu cihazda və ya emulyatorda addım sensoru aşkarlanmadı';

  @override
  String get sensorExplanation =>
      'Addımların sayılması telefonunuzun daxili addımölçən sensorundan (STEP_COUNTER / STEP_DETECTOR) asılıdır. Əksər emulyatorlarda fiziki hərəkət sensoru olmur.';

  @override
  String get sensorPermissionRequired =>
      'Fiziki fəaliyyət icazəsi tələb olunur';

  @override
  String get sensorPermissionDesc =>
      'Gün ərzində addımları dəqiq hesablamaq üçün YHealth cihazınızın fiziki fəaliyyət sensoruna giriş tələb edir.';

  @override
  String get dailySteps => 'Gündəlik addımlar';

  @override
  String get weeklySteps => 'Həftəlik';

  @override
  String get monthlySteps => 'Aylıq';

  @override
  String get averageSteps => 'Gündəlik orta';

  @override
  String get simulateStepTitle => 'Sensor test simulyasiyası';

  @override
  String get simulateStepDesc =>
      'Emulyatorda fiziki addım sensoru olmadığı üçün test məqsədilə addımlar simulyasiya edə bilərsiniz.';

  @override
  String get addTestSteps => '+500 Test addımı';

  @override
  String get sensorCompatibilityNotice =>
      'Cihaz uyğunluğu bildirişi: Telefonun addım sensorları fiziki hərəkət tələb edir. Hərəkətsiz qaldıqda real sensor addım saymır.';

  @override
  String get bmiTitle => 'BÇİ Kalkulyatoru';

  @override
  String get bmiSubtitle => 'Bədən Kütlə İndeksinin qiymətləndirilməsi';

  @override
  String get heightLabel => 'Boy';

  @override
  String get weightLabel => 'Çəki';

  @override
  String get calculateBmi => 'BÇİ hesabla';

  @override
  String get recalculate => 'Yenidən hesabla';

  @override
  String get yourBmiIs => 'Bədən Kütlə İndeksiniz';

  @override
  String get bmiCategory => 'Kateqoriya';

  @override
  String healthyWeightRange(Object max, Object min) {
    return 'Boyunuza uyğun sağlam çəki diapazonu: $min kq – $max kq';
  }

  @override
  String get categoryUnderweight => 'Çəki azlığı';

  @override
  String get categoryNormal => 'Normal çəki';

  @override
  String get categoryOverweight => 'Artıq çəki';

  @override
  String get categoryObese => 'Piylənmə';

  @override
  String get bmiExplanationUnderweight =>
      'BÇİ göstəriciniz çəki azlığına işarə edir. Qidalandırıcı və balanslı qidalanmaya diqqət yetirin, fərdi tövsiyələr üçün mütəxəssislə məsləhətləşin.';

  @override
  String get bmiExplanationNormal =>
      'BÇİ göstəriciniz sağlam diapazondadır. Müntəzəm gəzinti, balanslı qidalanma və aktiv həyat tərzinizi davam etdirin.';

  @override
  String get bmiExplanationOverweight =>
      'BÇİ göstəriciniz bir qədər artıq çəkiyə işarə edir. Gündəlik gəzinti məsafəsini artırmaq və qidalanmaya diqqət yetirmək optimal çəkiyə çatmağa kömək edəcəkdir.';

  @override
  String get bmiExplanationObese =>
      'BÇİ göstəriciniz piylənmə dərəcəsindədir. Gündəlik yüngül gəzintilərə üstünlük vermək və həkim-mütəxəssislə məsləhətləşmək tövsiyə olunur.';

  @override
  String get bmiDisclaimerTitle => 'Vacib tibbi bildiriş';

  @override
  String get bmiDisclaimerText =>
      'Bədən Kütlə İndeksi (BÇİ) yalnız boy və çəkiyə əsaslanan təxmini statistik qiymətləndirmə vasitəsidir. O, birbaşa piy kütləsini, əzələ toxumasını, sümük sıxlığını və ya fərdi klinik amilləri nəzərə almır. Bu alət yalnız maarifləndirmə və sağlamlıq izləmə məqsədi daşıyır və tibbi diaqnoz deyil. Dəqiq tibbi qiymətləndirmə üçün həkimə və ya dietoloqa müraciət edin.';

  @override
  String get heightUnitCm => 'sm';

  @override
  String get weightUnitKg => 'kq';

  @override
  String get profileTitle => 'Profil və Parametrlər';

  @override
  String get personalInfo => 'Şəxsi məlumatlar';

  @override
  String get editProfile => 'Profili redaktə et';

  @override
  String get saveProfile => 'Dəyişiklikləri saxla';

  @override
  String get nameLabel => 'Ad və Soyad';

  @override
  String get emailLabel => 'E-poçt ünvanı';

  @override
  String get ageLabel => 'Yaş';

  @override
  String yearsOld(Object age) {
    return '$age yaş';
  }

  @override
  String get dailyGoalsSettings => 'Gündəlik hədəflər';

  @override
  String get stepGoal => 'Addım hədəfi';

  @override
  String get calorieGoal => 'Kalori hədəfi';

  @override
  String get distanceGoal => 'Məsafə hədəfi';

  @override
  String get activeTimeGoal => 'Fəal vaxt hədəfi';

  @override
  String get languageSettings => 'Dil';

  @override
  String get selectLanguage => 'Tətbiqin dili';

  @override
  String get measurementUnits => 'Ölçü vahidləri';

  @override
  String get unitMetric => 'Metrik (kq, km, sm)';

  @override
  String get unitImperial => 'İngilis (funt, mil, düym)';

  @override
  String get accountSettings => 'Hesab';

  @override
  String get logout => 'Çıxış';

  @override
  String get logoutConfirmTitle => 'Çıxış edilsin?';

  @override
  String get logoutConfirmDesc =>
      'YHealth hesabınızdan çıxmaq istədiyinizə əminsiniz?';

  @override
  String get firebaseStatusTitle => 'Bulud sinxronizasiyası və yaddaş';

  @override
  String get firebaseConnected => 'Firebase Buluduna qoşulub';

  @override
  String get firebaseOfflineMode => 'Yerli rejim (Firebase sazlanmayıb)';

  @override
  String get firebaseSetupGuide => 'Firebase quraşdırma məlumatı';

  @override
  String get firebaseGuideDesc =>
      'Həqiqi Firebase Authentication və Cloud Firestore xidmətlərini qoşmaq üçün endirdiyiniz google-services.json faylını android/app/ qovluğuna yerləşdirin və tətbiqi yenidən qurun.';

  @override
  String get aboutYHealth => 'YHealth haqqında';

  @override
  String get appVersion => 'Versiya 1.0.0';

  @override
  String get privacyPhilosophy =>
      'Minimalist dizayn, sakitləşdirici rənglər, arzuolunmaz izləmələrə yox.';

  @override
  String get loginTitle => 'Yenidən xoş gəlmisiniz';

  @override
  String get loginSubtitle => 'Sağlamlıq səyahətinizə daxil olun';

  @override
  String get registerTitle => 'Qeydiyyatdan keçin';

  @override
  String get registerSubtitle => 'Sağlam və aktiv həyatınıza bu gün başlayın';

  @override
  String get emailInput => 'E-poçt ünvanı';

  @override
  String get emailHint => 'misal@email.com';

  @override
  String get passwordInput => 'Şifrə';

  @override
  String get passwordHint => '••••••••';

  @override
  String get confirmPasswordInput => 'Şifrəni təsdiqləyin';

  @override
  String get confirmPasswordHint => '••••••••';

  @override
  String get forgotPassword => 'Şifrəni unutmusunuz?';

  @override
  String get forgotPasswordTitle => 'Şifrəni bərpa et';

  @override
  String get forgotPasswordDesc =>
      'Qeydiyyatdan keçdiyiniz e-poçt ünvanını daxil edin. Sizə şifrə bərpası üçün təlimat göndəriləcək.';

  @override
  String get sendResetLink => 'Bərpa linki göndər';

  @override
  String get resetLinkSent => 'Şifrə bərpa linki e-poçtunuza göndərildi!';

  @override
  String get loginButton => 'Daxil ol';

  @override
  String get registerButton => 'Qeydiyyatdan keç';

  @override
  String get doNotHaveAccount => 'Hesabınız yoxdur? Qeydiyyatdan keçin';

  @override
  String get alreadyHaveAccount => 'Artıq hesabınız var? Daxil olun';

  @override
  String get skipForNow => 'Yerli rejimdə davam et';

  @override
  String get authErrorInvalidEmail =>
      'Zəhmət olmasa, düzgün e-poçt ünvanı daxil edin.';

  @override
  String get authErrorWrongPassword => 'Şifrə yanlışdır. Yenidən cəhd edin.';

  @override
  String get authErrorUserNotFound => 'Bu e-poçtla bağlı hesab tapılmadı.';

  @override
  String get authErrorWeakPassword =>
      'Şifrə ən azı 6 simvoldan ibarət olmalıdır.';

  @override
  String get authErrorEmailInUse => 'Bu e-poçt ünvanı artıq istifadə olunur.';

  @override
  String get authErrorNetwork =>
      'İnternet bağlantısı xətası baş verdi. Zəhmət olmasa, şəbəkəni yoxlayın.';

  @override
  String get authErrorTooManyRequests =>
      'Çox sayda uğursuz cəhd. Zəhmət olmasa, bir az sonra yenidən cəhd edin.';

  @override
  String get authErrorDefault =>
      'Doğrulama xətası baş verdi. Məlumatları yoxlayın.';

  @override
  String get authSuccessLogin => 'Uğurla daxil oldunuz!';

  @override
  String get authSuccessRegister => 'Hesabınız uğurla yaradıldı!';

  @override
  String get passwordsDoNotMatch => 'Şifrələr uyğun gəlmir.';

  @override
  String get save => 'Saxla';

  @override
  String get cancel => 'Ləğv et';

  @override
  String get confirm => 'Təsdiqlə';

  @override
  String get savedSuccessfully => 'Dəyişikliklər uğurla saxlanıldı';

  @override
  String get errorOccurred => 'Xəta baş verdi';

  @override
  String get retry => 'Yenidən cəhd et';

  @override
  String get close => 'Bağla';

  @override
  String get ok => 'Oldu';

  @override
  String get today => 'Bu gün';

  @override
  String get yesterday => 'Dünən';

  @override
  String get themeSettings => 'Görünüş / Mövzu';

  @override
  String get themeLight => 'İşıqlı rejim';

  @override
  String get themeDark => 'Qaranlıq rejim';

  @override
  String get themeSubtitle => 'Tətbiqin rəng mövzusunu seçin';

  @override
  String get deviceCompatibilityTitle => 'Cihaz Uyğunluğu Mərkəzi';

  @override
  String get deviceCompatibilitySubtitle =>
      'Aparat sensorları və arxa fon fəaliyyət diaqnostikası';

  @override
  String get deviceInfo => 'Cihaz Məlumatı';

  @override
  String get deviceManufacturer => 'İstehsalçı';

  @override
  String get deviceModel => 'Model';

  @override
  String get androidVersion => 'Android Versiyası';

  @override
  String get sensorDiagnostics => 'Aparat Sensorları';

  @override
  String get stepCounterSensor => 'Addım Sayğacı (TYPE_STEP_COUNTER)';

  @override
  String get stepDetectorSensor => 'Addım Detektoru (TYPE_STEP_DETECTOR)';

  @override
  String get accelerometerSensor => 'Akselerometr Sensoru';

  @override
  String get activeTrackingMode => 'Aktiv İzləmə Rejimi';

  @override
  String get sensorCounterPrimary => 'Aparat Addım Sayğacı (Əsas)';

  @override
  String get sensorDetectorAlternative => 'Aparat Addım Detektoru (Alternativ)';

  @override
  String get sensorNone => 'Aparat Sensoru Yoxdur (Məhdud)';

  @override
  String get sensorHardwareName => 'Sensor Çipi';

  @override
  String get activityRecognitionTitle => 'İnsan Hərəkətinin Tanınması';

  @override
  String get activityRecognitionDesc =>
      'Sensor və GPS məlumatlarının intellektual birləşməsi';

  @override
  String get activityStill => 'Hərəkətsiz';

  @override
  String get activityWalking => 'Yeriş';

  @override
  String get activityRunning => 'Qaçış';

  @override
  String get activityBicycle => 'Velosiped';

  @override
  String get activityVehicle => 'Nəqliyyatda';

  @override
  String get vehicleFilteringActive => 'Nəqliyyat məsafəsi yerişdən çıxarılır';

  @override
  String get backgroundOperationTitle => 'Arxa Fon Fəaliyyəti';

  @override
  String get foregroundServiceStatus => 'Sağlamlıq Xidməti (Foreground)';

  @override
  String get serviceRunning => 'Aktiv işləyir';

  @override
  String get serviceStopped => 'Dayandırılıb';

  @override
  String get notificationPermission => 'Bildiriş İcazəsi';

  @override
  String get bootRecovery => 'Cihaz Yenidən Başlama Bərpası';

  @override
  String get batteryOptimizationTitle => 'Bataareya Qənaəti və Məhdudiyyətlər';

  @override
  String get batteryUnrestricted => 'Məhdudiyyətsiz (Tövsiyə olunur)';

  @override
  String get batteryRestricted => 'Məhdudlaşdırılmış (Sistem dayandıra bilər)';

  @override
  String get batteryOptimizeButton => 'Bataareya Məhdudiyyətini Qaldır';

  @override
  String get openOemSettingsButton => 'İstehsalçı Tənzimləmələrini Aç';

  @override
  String get manufacturerGuidance => 'İstehsalçıya Xüsusi Tövsiyə';

  @override
  String get guidanceXiaomi =>
      'Xiaomi/Redmi/POCO: Təhlükəsizlik > Avtomatik başlama (Autostart) icazəsini verin. Batareya qənaətini \'Məhdudiyyətsiz\' (No restrictions) seçin.';

  @override
  String get guidanceSamsung =>
      'Samsung: Ayarlar > Cihaz qulluğu > Batareya > \'Heç vaxt yatmayan tətbiqlər\' (Never sleeping apps) siyahısına YHealth əlavə edin.';

  @override
  String get guidanceHuawei =>
      'Huawei: Ayarlar > Batareya > Tətbiq işə salınması > YHealth üçün \'Əllə idarə et\' seçin və arxa fona icazə verin.';

  @override
  String get guidanceOnePlus =>
      'OnePlus/OPPO/Realme: Ayarlar > Tətbiqlər > YHealth > Batareya > \'Arxa fon fəaliyyətinə icazə ver\' və \'Avtomatik başlama\' aktiv edin.';

  @override
  String get guidanceVivo =>
      'Vivo: Ayarlar > Batareya > Yüksək arxa fon enerji sərfiyyatına icazə verin.';

  @override
  String get guidancePixel =>
      'Google Pixel / Standart Android: Ayarlar > Tətbiqlər > YHealth > Batareya > \'Məhdudiyyətsiz\' (Unrestricted) seçin.';

  @override
  String get guidanceGeneral =>
      'Arxa fonda fasiləsiz addım sayılması üçün batareya optimizasiyasını məhdudiyyətsiz edin.';

  @override
  String get gpsTrackingStatus => 'GPS və Məkan Statusu';

  @override
  String get gpsOptionalNote =>
      'Addım saymaq üçün GPS məcburi deyil. Addımlar aparat sensoru vasitəsilə GPS olmadan da dəqiq hesablanır.';

  @override
  String get supportedMethodsTitle => 'Dəstəklənən İzləmə Metodları';

  @override
  String get supportedMethodsDesc =>
      'Bu cihazda addım sayğacı və yeriş izləməsi tam dəstəklənir.';

  @override
  String get fullyCompatible => 'Tam Uyğundur';

  @override
  String get partiallyCompatible => 'Qismən Uyğundur';

  @override
  String get attentionNeeded => 'Tənzimləmə Lazımdır';

  @override
  String get granted => 'Verilib';

  @override
  String get denied => 'Verilməyib';

  @override
  String get supported => 'Dəstəklənir';

  @override
  String get unsupported => 'Dəstəklənmir';

  @override
  String get vehicleDetectedWarning =>
      'Nəqliyyat vasitəsi aşkarlandı — məsafə yeriş statistikasına əlavə olunmur.';

  @override
  String get sleepTrackingTitle => 'Yuxu İzləmə';

  @override
  String get lastNightSleep => 'Dünən Gecəki Yuxu';

  @override
  String get bedtime => 'Yuxuya getmə';

  @override
  String get wakeTime => 'Oyanma vaxtı';

  @override
  String get sleepDuration => 'Yuxu müddəti';

  @override
  String get bedtimeConsistency => 'Yuxu Rejimi Sabitliyi';

  @override
  String get logSleep => 'Yuxunu qeyd et';

  @override
  String get editSleep => 'Yuxunu redaktə et';

  @override
  String get deleteSleepConfirm =>
      'Bu yuxu qeydini silmək istədiyinizdən əminsiniz?';

  @override
  String get healthConnectSync => 'Health Connect ilə sinxronlaşdır';

  @override
  String get weeklyReportsTitle => 'Həftəlik Hesabatlar';

  @override
  String get weeklySummary => 'Həftəlik Xülasə';

  @override
  String get viewWeeklyReport => 'Həftəlik Hesabata Bax';

  @override
  String get weeklyReportsSubtitle =>
      'Avtomatlaşdırılmış bazar ertəsi xülasəsi və statistik təhlillər';

  @override
  String get mostActiveDay => 'Ən Aktiv Gün';

  @override
  String get weekOverWeek => 'Əvvəlki həftə ilə müqayisə';

  @override
  String get exportPdf => 'PDF Hesabat İxrac Et';

  @override
  String get pdfExportSuccess => 'Hesabat PDF faylı uğurla saxlanıldı!';

  @override
  String get noReportsYet => 'Hələlik həftəlik hesabat yaradılmayıb';

  @override
  String get generateNow => 'İndi Yarat';

  @override
  String get goalsMet => 'Məqsədə Çatılan Günlər';

  @override
  String get dailyBreakdown => '7 Günlük Göstəricilər';

  @override
  String get missingRecord => 'Qeyd yoxdur';

  @override
  String get weekNumberLabel => 'Həftə';

  @override
  String get avgSleepPerNight => 'Gecəlik Orta Yuxu';

  @override
  String get weightCoachTitle => 'AI Çəki Məşqçisi';

  @override
  String get weightCoachSubtitle =>
      'Fərdi oflayn metabolik təhlil və məsləhətlər';

  @override
  String get logWeight => 'Çəkini Qeyd Et';

  @override
  String get currentWeight => 'Cari Çəki';

  @override
  String get targetWeight => 'Hədəf Çəki';

  @override
  String get timelineEstimate => 'Təxmini Müddət';

  @override
  String get safeRate => 'Təhlükəsiz Temp';

  @override
  String get dailyCalorieTarget => 'Gündəlik Kalori Hədəfi';

  @override
  String get bmrLabel => 'Baza Maddələr Mübadiləsi';

  @override
  String get tdeeLabel => 'Ümumi Gündəlik Xərc (TDEE)';

  @override
  String get hydrationTarget => 'Gündəlik Su Hədəfi';

  @override
  String get quickPrompts => 'Sürətli Suallar';

  @override
  String get typeMessage => 'Məşqçinizdən sual soruşun...';

  @override
  String get weightHistory => 'Çəki Tarixçəsi';

  @override
  String get deleteWeightConfirm =>
      'Bu çəki qeydini silmək istədiyinizdən əminsiniz?';

  @override
  String get medicalDisclaimer =>
      'YHealth Çəki Məşqçisi fizioloji formulalara əsaslanan maarifləndirici məlumatlar təqdim edir. Bu, tibbi diaqnoz və ya təyinat deyil. Fərdi sağlamlıq vəziyyətiniz üçün həkiminizlə məsləhətləşin.';
}
