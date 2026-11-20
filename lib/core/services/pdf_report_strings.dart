class PdfReportStrings {
  final String title;
  final String Function(String start, String end, int week, int year) period;
  final String badge;
  final String summaryHeading;
  final String totalSteps;
  final String steps;
  final String distance;
  final String calories;
  final String kcal;
  final String activeTime;
  final String minutes;
  final String avgSleep;
  final String goalCompleted;
  final String Function(int met) goalDays;
  final String mostActiveDay;
  final String vsPreviousWeek;
  final String breakdownHeading;
  final String colDay;
  final String colDate;
  final String colSteps;
  final String colDistance;
  final String colCalories;
  final String colActive;
  final String colSleep;
  final String colGoal;
  final String yes;
  final String no;
  final String noRecord;
  final String hourShort;
  final String minuteShort;
  final String footer;
  final String generated;
  final List<String> dayNames;

  const PdfReportStrings({
    required this.title,
    required this.period,
    required this.badge,
    required this.summaryHeading,
    required this.totalSteps,
    required this.steps,
    required this.distance,
    required this.calories,
    required this.kcal,
    required this.activeTime,
    required this.minutes,
    required this.avgSleep,
    required this.goalCompleted,
    required this.goalDays,
    required this.mostActiveDay,
    required this.vsPreviousWeek,
    required this.breakdownHeading,
    required this.colDay,
    required this.colDate,
    required this.colSteps,
    required this.colDistance,
    required this.colCalories,
    required this.colActive,
    required this.colSleep,
    required this.colGoal,
    required this.yes,
    required this.no,
    required this.noRecord,
    required this.hourShort,
    required this.minuteShort,
    required this.footer,
    required this.generated,
    required this.dayNames,
  });

  factory PdfReportStrings.forLanguage(String languageCode) =>
      languageCode == 'az' ? azerbaijani : english;

  String dayName(int dayOfWeek, String fallback) =>
      dayOfWeek >= 1 && dayOfWeek <= 7 ? dayNames[dayOfWeek - 1] : fallback;

  String duration(int totalMinutes) =>
      '${totalMinutes ~/ 60}$hourShort ${totalMinutes % 60}$minuteShort';

  static final PdfReportStrings english = PdfReportStrings(
    title: 'YHealth - Weekly Report',
    period: (start, end, week, year) => '$start  to  $end   |   Week $week, $year',
    badge: 'YHEALTH OFFLINE',
    summaryHeading: 'Weekly Summary Metrics',
    totalSteps: 'Total Steps',
    steps: 'steps',
    distance: 'Distance',
    calories: 'Calories',
    kcal: 'kcal',
    activeTime: 'Active Time',
    minutes: 'min',
    avgSleep: 'Avg Sleep / Night',
    goalCompleted: 'Goal Completed',
    goalDays: (met) => '$met / 7 days',
    mostActiveDay: 'Most Active Day:',
    vsPreviousWeek: 'vs Previous Week:',
    breakdownHeading: '7-Day Daily Breakdown (Monday - Sunday)',
    colDay: 'Day',
    colDate: 'Date',
    colSteps: 'Steps',
    colDistance: 'Dist (km)',
    colCalories: 'Calories',
    colActive: 'Active (m)',
    colSleep: 'Sleep',
    colGoal: 'Goal Met',
    yes: 'Yes',
    no: 'No',
    noRecord: 'No record',
    hourShort: 'h',
    minuteShort: 'm',
    footer: 'Generated locally by YHealth. Data is stored strictly on-device without cloud sync.',
    generated: 'Generated',
    dayNames: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
  );

  static final PdfReportStrings azerbaijani = PdfReportStrings(
    title: 'YHealth - Həftəlik Hesabat',
    period: (start, end, week, year) => '$start  –  $end   |   $year, həftə $week',
    badge: 'YHEALTH OFFLINE',
    summaryHeading: 'Həftəlik göstəricilər',
    totalSteps: 'Ümumi addım',
    steps: 'addım',
    distance: 'Məsafə',
    calories: 'Kalori',
    kcal: 'kkal',
    activeTime: 'Aktiv vaxt',
    minutes: 'dəq',
    avgSleep: 'Orta yuxu / gecə',
    goalCompleted: 'Hədəfə çatılıb',
    goalDays: (met) => '$met / 7 gün',
    mostActiveDay: 'Ən aktiv gün:',
    vsPreviousWeek: 'Ötən həftə ilə müqayisə:',
    breakdownHeading: '7 günlük göstəricilər (bazar ertəsi - bazar)',
    colDay: 'Gün',
    colDate: 'Tarix',
    colSteps: 'Addım',
    colDistance: 'Məsafə (km)',
    colCalories: 'Kalori',
    colActive: 'Aktiv (dəq)',
    colSleep: 'Yuxu',
    colGoal: 'Hədəf',
    yes: 'Bəli',
    no: 'Xeyr',
    noRecord: 'Qeyd yoxdur',
    hourShort: 's',
    minuteShort: 'dəq',
    footer: 'YHealth tərəfindən cihazda yaradılıb. Data yalnız cihazda saxlanılır, buluda göndərilmir.',
    generated: 'Yaradılıb',
    dayNames: const ['B.e.', 'Ç.a.', 'Ç.', 'C.a.', 'C.', 'Ş.', 'B.'],
  );
}
