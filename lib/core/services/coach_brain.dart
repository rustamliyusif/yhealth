import 'weight_coach_engine.dart';

enum CoachIntent {
  greeting,
  thanks,
  help,
  progress,
  today,
  week,
  bmi,
  hydration,
  sleep,
  nutrition,
  protein,
  mealTiming,
  snacks,
  sugar,
  calories,
  timeline,
  steps,
  exercise,
  cardio,
  plateau,
  motivation,
  stress,
  alcohol,
  fasting,
  weightGain,
  medical,
  eatingConcern,
  followUp,
  unknown,
}

class CoachContext {
  final int todaySteps;
  final int goalSteps;
  final int daysTracked7d;
  final int avgSteps7d;
  final int goalHits7d;
  final int sleepNights7d;
  final int avgSleepMinutes7d;
  final double? weightChange30d;
  final int weighIns30d;

  const CoachContext({
    this.todaySteps = 0,
    this.goalSteps = 8000,
    this.daysTracked7d = 0,
    this.avgSteps7d = 0,
    this.goalHits7d = 0,
    this.sleepNights7d = 0,
    this.avgSleepMinutes7d = 0,
    this.weightChange30d,
    this.weighIns30d = 0,
  });

  bool get hasStepData => daysTracked7d > 0;
  bool get hasSleepData => sleepNights7d > 0;
}

class CoachReply {
  final CoachIntent intent;
  final String text;
  const CoachReply(this.intent, this.text);
}

class _Rule {
  final CoachIntent intent;
  final List<String> stems;
  final List<String> exact;
  final List<String> phrases;
  const _Rule(this.intent, {this.stems = const [], this.exact = const [], this.phrases = const []});
}

class CoachBrain {
  static const List<_Rule> _rules = [
    _Rule(CoachIntent.greeting,
        exact: ['salam', 'hi', 'hello', 'hey', 'necəsən', 'necesen'],
        phrases: ['good morning', 'sabahın xeyir', 'axşamın xeyir']),
    _Rule(CoachIntent.thanks,
        stems: ['təşəkkür', 'tesekkur', 'thank'],
        exact: ['thanks', 'thx', 'sağ ol', 'çox sağ ol'],
        phrases: ['sağ ol', 'sag ol']),
    _Rule(CoachIntent.help,
        exact: ['help', 'kömək', 'komek'],
        phrases: ['nə edə bilərsən', 'nə bacarırsan', 'what can you do', 'nələri bilirsən']),
    _Rule(CoachIntent.progress,
        stems: ['analiz', 'analyz', 'progress', 'tərəqqi', 'təhlil', 'nəticə', 'result'],
        exact: ['status', 'vəziyyətim', 'vəziyyət']),
    _Rule(CoachIntent.today,
        exact: ['bugün', 'today', 'bu gün'],
        phrases: ['bu gün', 'bugünkü', 'today so far', 'how am i doing today']),
    _Rule(CoachIntent.week,
        stems: ['həftə', 'hefte', 'week'],
        phrases: ['son 7 gün', 'last 7 days', 'this week']),
    _Rule(CoachIntent.bmi,
        stems: ['bmi', 'indeks', 'index'],
        phrases: ['çəki indeksi', 'bədən kütlə']),
    _Rule(CoachIntent.hydration,
        stems: ['water', 'hydrat', 'maye', 'içki'],
        exact: ['su', 'suyu', 'suyun', 'sudan', 'suya']),
    _Rule(CoachIntent.sleep,
        stems: ['sleep', 'yuxu', 'yatma', 'yatır', 'yatıram', 'insomn', 'yorğun', 'tired'],
        exact: ['rest', 'yat']),
    _Rule(CoachIntent.nutrition,
        stems: ['qida', 'yemək', 'yemek', 'pəhriz', 'pehriz', 'nutrit', 'diet', 'food', 'menyu', 'menu', 'boşqab'],
        exact: ['eat', 'eating', 'ye', 'yeyim', 'yeyirəm', 'yeməliyəm']),
    _Rule(CoachIntent.protein,
        stems: ['protein', 'zülal', 'zulal', 'toyuq', 'yumurta', 'muscle', 'əzələ'],
        exact: ['ət', 'əti', 'meat']),
    _Rule(CoachIntent.mealTiming,
        stems: ['səhər yeməy', 'breakfast', 'nahar', 'lunch', 'şam', 'dinner', 'gecə yeməy'],
        phrases: ['nə vaxt yemək', 'when to eat', 'gec yemək', 'late night', 'səhər yeməyi', 'axşam yeməyi']),
    _Rule(CoachIntent.snacks,
        stems: ['snack', 'qəlyanaltı', 'qelyanalti', 'aclıq', 'aclig', 'hungry', 'acıkır', 'ac qalıram']),
    _Rule(CoachIntent.sugar,
        stems: ['şirniyyat', 'şirin', 'sirin', 'sugar', 'sweet', 'şokolad', 'chocolate', 'dessert', 'desert', 'tort'],
        exact: ['şəkər', 'şəkəri', 'seker']),
    _Rule(CoachIntent.calories,
        stems: ['kalori', 'calori', 'kcal', 'kkal', 'tdee', 'bmr', 'metabol', 'maddələr mübadiləsi']),
    _Rule(CoachIntent.timeline,
        phrases: ['nə vaxt çatacam', 'nə qədər vaxt', 'neçə həftə', 'how long', 'when will i', 'hədəfə nə vaxt', 'nə vaxt arıqla'],
        stems: ['müddət', 'timeline']),
    _Rule(CoachIntent.steps,
        stems: ['addım', 'addim', 'step', 'walk', 'yeriş', 'gəzinti', 'gəzmək', 'gezinti']),
    _Rule(CoachIntent.exercise,
        stems: ['idman', 'məşq', 'mesq', 'exercis', 'workout', 'gym', 'güc', 'strength', 'squat', 'push-up', 'fitness', 'hərəkət', 'activ', 'aktiv'],
        exact: ['zal', 'zala', 'zalda']),
    _Rule(CoachIntent.cardio,
        stems: ['qaç', 'qac', 'run', 'jog', 'cardio', 'kardio', 'velosiped', 'bike', 'cycling', 'üzgüçü', 'swim']),
    _Rule(CoachIntent.plateau,
        stems: ['plato', 'plateau', 'stuck', 'dayanıb', 'dayanib', 'azalmır', 'azalmir', 'düşmür', 'dusmur', 'tərpənmir']),
    _Rule(CoachIntent.motivation,
        stems: ['motiv', 'həvəs', 'heves', 'tənbəl', 'tenbel', 'lazy', 'give up', 'bezmiş', 'bezdim', 'davam edə bilmir', 'iradə']),
    _Rule(CoachIntent.stress,
        stems: ['stress', 'stres', 'əsəb', 'narahat', 'anxi', 'gərgin', 'emosional', 'emotional']),
    _Rule(CoachIntent.alcohol,
        stems: ['alkoqol', 'alcohol', 'pivə', 'beer', 'şərab', 'wine', 'araq', 'vodka']),
    _Rule(CoachIntent.fasting,
        stems: ['oruc', 'fasting', 'aralıqlı', '16:8', 'intermittent', 'fast']),
    _Rule(CoachIntent.weightGain,
        stems: ['kökəl', 'kokel', 'çəki yığ', 'çəki art', 'gain weight', 'bulk', 'arıqam', 'ariqam', 'skinny', 'underweight']),
    _Rule(CoachIntent.medical,
        stems: ['ağrı', 'agri', 'pain', 'ürək', 'heart', 'diabet', 'hamilə', 'hamile', 'pregnan', 'dərman', 'derman', 'medic',
          'təzyiq', 'tezyiq', 'blood pressure', 'həkim', 'doctor', 'xəstə', 'xeste', 'baş gicəll', 'dizzy', 'tiroid', 'thyroid']),
    _Rule(CoachIntent.eatingConcern,
        stems: ['qusma', 'qusur', 'qusdur', 'vomit', 'purge', 'laksativ', 'laxative', 'binge', 'starv', 'anoreks', 'bulim'],
        phrases: ['ac qalmaq', 'heç nə yemir', 'yemək yemirəm', 'not eating', 'stop eating', 'skip all meals', 'yeməyi kəs']),
  ];

  static const List<String> _followUpPhrases = [
    'daha ətraflı', 'ətraflı', 'etrafli', 'daha çox', 'davam', 'bəs sonra', 'niyə', 'niye', 'why', 'more', 'tell me more', 'explain more', 'details', 'and then',
  ];

  static String _normalize(String input) {
    final lower = input.replaceAll('İ', 'i').toLowerCase();
    return lower.replaceAll(RegExp(r"[^\p{L}\p{N}:\- ]", unicode: true), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static CoachIntent detectIntent(String query, {CoachIntent? previousIntent}) {
    final text = _normalize(query);
    if (text.isEmpty) return CoachIntent.unknown;
    final padded = ' $text ';
    final tokens = text.split(' ');

    final scores = <CoachIntent, int>{};
    for (final rule in _rules) {
      var score = 0;
      for (final phrase in rule.phrases) {
        if (padded.contains(' ${_normalize(phrase)}')) score += 3;
      }
      for (final word in rule.exact) {
        final w = _normalize(word);
        if (w.contains(' ')) {
          if (padded.contains(' $w ')) score += 2;
        } else if (tokens.contains(w)) {
          score += 2;
        }
      }
      for (final stem in rule.stems) {
        final st = _normalize(stem);
        if (st.contains(' ')) {
          if (padded.contains(' $st')) score += 2;
        } else if (tokens.any((t) => t.startsWith(st))) {
          score += st.length >= 4 ? 2 : 1;
        }
      }
      if (score > 0) scores[rule.intent] = (scores[rule.intent] ?? 0) + score;
    }

    if ((scores[CoachIntent.eatingConcern] ?? 0) > 0) return CoachIntent.eatingConcern;
    if (_mentionsVeryLowCalories(text)) return CoachIntent.eatingConcern;
    if ((scores[CoachIntent.medical] ?? 0) >= 2) return CoachIntent.medical;

    if (scores.isEmpty) {
      if (previousIntent != null && _isFollowUp(text)) return CoachIntent.followUp;
      return CoachIntent.unknown;
    }

    final social = {CoachIntent.greeting, CoachIntent.thanks};
    final topical = scores.entries.where((e) => !social.contains(e.key)).toList();
    final pool = topical.isNotEmpty ? topical : scores.entries.toList();
    pool.sort((a, b) => b.value.compareTo(a.value));
    return pool.first.key;
  }

  static bool _isFollowUp(String text) {
    final padded = ' $text ';
    return _followUpPhrases.any((p) => padded.contains(' ${_normalize(p)}'));
  }

  static bool _mentionsVeryLowCalories(String text) {
    if (!RegExp(r'(kalori|calori|kcal|kkal)').hasMatch(text)) return false;
    final match = RegExp(r'\b(\d{3,4})\b').firstMatch(text);
    if (match == null) return false;
    final value = int.tryParse(match.group(1)!) ?? 0;
    return value > 0 && value < 1200;
  }

  static CoachReply respond({
    required String query,
    required CoachAnalysisResult analysis,
    required bool isAzerbaijani,
    CoachContext context = const CoachContext(),
    CoachIntent? previousIntent,
  }) {
    final detected = detectIntent(query, previousIntent: previousIntent);
    final az = isAzerbaijani;

    if (detected == CoachIntent.followUp && previousIntent != null) {
      return CoachReply(previousIntent, _detail(previousIntent, analysis, context, az));
    }

    final text = switch (detected) {
      CoachIntent.greeting => _greeting(analysis, context, az),
      CoachIntent.thanks => az
          ? '😊 Dəyməz! Sualın olanda yaz. Kiçik addımlar böyük nəticə verir.'
          : '😊 Anytime! Ask whenever you need. Small steps add up.',
      CoachIntent.help || CoachIntent.unknown => _help(analysis, az, unknown: detected == CoachIntent.unknown),
      CoachIntent.progress => _withData(_topic('analyze', analysis, az), _progressData(context, az)),
      CoachIntent.today => _today(context, az),
      CoachIntent.week => _week(context, analysis, az),
      CoachIntent.bmi => _topic('bmi', analysis, az),
      CoachIntent.hydration => _topic('water', analysis, az),
      CoachIntent.sleep => _withData(_topic('sleep', analysis, az), _sleepData(context, az)),
      CoachIntent.nutrition => _topic('food', analysis, az),
      CoachIntent.protein => _protein(analysis, az),
      CoachIntent.mealTiming => _mealTiming(az),
      CoachIntent.snacks => _snacks(az),
      CoachIntent.sugar => _sugar(az),
      CoachIntent.calories => _calories(analysis, az),
      CoachIntent.timeline => _timeline(analysis, context, az),
      CoachIntent.steps => _withData(_topic('step', analysis, az), _stepData(context, analysis, az)),
      CoachIntent.exercise => _exercise(analysis, az),
      CoachIntent.cardio => _cardio(az),
      CoachIntent.plateau => _withData(_topic('plateau', analysis, az), _weightData(context, az)),
      CoachIntent.motivation => _motivation(context, az),
      CoachIntent.stress => _stress(az),
      CoachIntent.alcohol => _alcohol(az),
      CoachIntent.fasting => _fasting(az),
      CoachIntent.weightGain => _weightGain(analysis, az),
      CoachIntent.medical => _medical(az),
      CoachIntent.eatingConcern => _eatingConcern(az),
      CoachIntent.followUp => _help(analysis, az, unknown: true),
    };
    final intent = detected == CoachIntent.unknown || detected == CoachIntent.followUp ? CoachIntent.help : detected;
    return CoachReply(intent, text);
  }

  static String _topic(String key, CoachAnalysisResult a, bool az) =>
      WeightCoachEngine.topicAnswer(topicKey: key, analysis: a, isAzerbaijani: az);

  static String _withData(String base, String? data) => data == null ? base : '$base\n\n$data';

  static String _fmtSleep(int minutes) => '${minutes ~/ 60}h ${minutes % 60}m';
  static String _fmtSleepAz(int minutes) => '${minutes ~/ 60} saat ${minutes % 60} dəq';

  static String _greeting(CoachAnalysisResult a, CoachContext c, bool az) {
    final hour = DateTime.now().hour;
    final hello = az
        ? (hour < 12 ? 'Sabahın xeyir' : hour < 18 ? 'Salam' : 'Axşamın xeyir')
        : (hour < 12 ? 'Good morning' : hour < 18 ? 'Hi' : 'Good evening');
    final steps = c.todaySteps > 0
        ? (az ? '\nBu gün artıq **${c.todaySteps}** addım atmısan.' : '\nYou already have **${c.todaySteps}** steps today.')
        : '';
    return az
        ? '👋 $hello! Mən Coach Leo-yam.$steps\n\nBu gün nəyə baxaq: tərəqqi, qidalanma, yuxu, yoxsa məşq?'
        : '👋 $hello! I\'m Coach Leo.$steps\n\nWhat should we look at today: progress, nutrition, sleep, or training?';
  }

  static String _help(CoachAnalysisResult a, bool az, {required bool unknown}) {
    final intro = unknown
        ? (az ? '🤔 Sualını tam başa düşmədim. ' : '🤔 I didn\'t quite catch that. ')
        : '';
    return az
        ? '$intro${unknown ? 'Bu mövzulardan birini soruşa bilərsən:' : 'Bu mövzularda kömək edə bilərəm:'}\n\n'
            '• 📊 *"Tərəqqimi təhlil et"*, *"Bu həftə necə keçdi?"*, *"Bu gün necəyəm?"*\n'
            '• 🥗 Qidalanma, protein, şirniyyat, qəlyanaltı, səhər yeməyi, oruc\n'
            '• 🔥 Kalori, BMR/TDEE, hədəfə nə vaxt çatacağım\n'
            '• 👟 Addım, idman, qaçış, plato\n'
            '• 🌙 Yuxu, 💧 su, 😮‍💨 stres, motivasiya\n\n'
            '_Coach Leo ümumi tövsiyələr verir və həkim məsləhətini əvəz etmir._'
        : '$intro${unknown ? 'Try asking about one of these:' : 'Here\'s what I can help with:'}\n\n'
            '• 📊 *"Analyze my progress"*, *"How was my week?"*, *"How am I doing today?"*\n'
            '• 🥗 Nutrition, protein, sweets, snacks, breakfast, fasting\n'
            '• 🔥 Calories, BMR/TDEE, when I\'ll reach my goal\n'
            '• 👟 Steps, workouts, running, plateaus\n'
            '• 🌙 Sleep, 💧 water, 😮‍💨 stress, motivation\n\n'
            '_Coach Leo gives general guidance and is not a substitute for medical advice._';
  }

  static String? _progressData(CoachContext c, bool az) {
    final lines = <String>[];
    final weight = _weightData(c, az);
    if (weight != null) lines.add(weight);
    final steps = c.hasStepData
        ? (az
            ? '👟 Son 7 gündə orta **${c.avgSteps7d}** addım, hədəfə **${c.goalHits7d}/${c.daysTracked7d}** gün çatmısan.'
            : '👟 Last 7 days: **${c.avgSteps7d}** steps/day on average, goal hit on **${c.goalHits7d}/${c.daysTracked7d}** days.')
        : null;
    if (steps != null) lines.add(steps);
    final sleep = c.hasSleepData
        ? (az
            ? '🌙 Orta yuxu: **${_fmtSleepAz(c.avgSleepMinutes7d)}** (${c.sleepNights7d} gecə).'
            : '🌙 Average sleep: **${_fmtSleep(c.avgSleepMinutes7d)}** (${c.sleepNights7d} nights).')
        : null;
    if (sleep != null) lines.add(sleep);
    if (lines.isEmpty) return null;
    final heading = az ? '**Sənin datan:**' : '**Your data:**';
    return '$heading\n${lines.join('\n')}';
  }

  static String? _weightData(CoachContext c, bool az) {
    final change = c.weightChange30d;
    if (change == null || c.weighIns30d < 2) return null;
    final abs = change.abs().toStringAsFixed(1);
    if (change.abs() < 0.3) {
      return az
          ? '⚖️ Son 30 gündə çəkin demək olar dəyişməyib (${c.weighIns30d} ölçü).'
          : '⚖️ Your weight has been about stable over the last 30 days (${c.weighIns30d} weigh-ins).';
    }
    return az
        ? '⚖️ Son 30 gündə çəkin **${change < 0 ? '-' : '+'}$abs kg** dəyişib (${c.weighIns30d} ölçü).'
        : '⚖️ Over the last 30 days your weight changed by **${change < 0 ? '-' : '+'}$abs kg** (${c.weighIns30d} weigh-ins).';
  }

  static String? _sleepData(CoachContext c, bool az) {
    if (!c.hasSleepData) {
      return az
          ? '📝 Yuxu qeydlərin yoxdur. Yuxu bölməsində bir neçə gecə qeyd etsən, sənə uyğun təhlil verərəm.'
          : '📝 No sleep logs yet. Log a few nights in the Sleep tab and I\'ll tailor this to you.';
    }
    final avg = c.avgSleepMinutes7d;
    final verdict = avg < 420
        ? (az ? 'Bu, tövsiyə olunan 7 saatdan azdır. Yatmağı hər gün 15-20 dəqiqə tezə çəkməklə başla.' : 'That\'s below the recommended 7 hours. Try moving bedtime 15-20 minutes earlier each night.')
        : avg > 570
            ? (az ? 'Bu, kifayət qədər çoxdur. Gün ərzində yorğunluq davam edirsə, həkimlə danışmağa dəyər.' : 'That\'s on the long side. If you still feel tired, it\'s worth checking with a doctor.')
            : (az ? 'Əla, sağlam aralıqdasan. Əsas iş indi ardıcıllığı qorumaqdır.' : 'Great, that\'s in the healthy range. Now focus on keeping it consistent.');
    return az
        ? '**Sənin yuxun:** son ${c.sleepNights7d} gecədə orta **${_fmtSleepAz(avg)}**. $verdict'
        : '**Your sleep:** **${_fmtSleep(avg)}** on average over ${c.sleepNights7d} nights. $verdict';
  }

  static String? _stepData(CoachContext c, CoachAnalysisResult a, bool az) {
    if (!c.hasStepData) return null;
    final gap = a.recommendedDailySteps - c.avgSteps7d;
    final advice = gap > 1500
        ? (az
            ? 'Birdən-birə hədəfə qalxma: növbəti həftə gündəlik ortanı **${c.avgSteps7d + 1000}** addıma çatdırmağa çalış.'
            : 'Don\'t jump straight to the target: aim for **${c.avgSteps7d + 1000}** steps/day next week.')
        : gap > 0
            ? (az ? 'Hədəfə az qalıb — yeməkdən sonra 10 dəqiqəlik gəzinti fərqi bağlayar.' : 'You\'re close — a 10-minute walk after meals will close the gap.')
            : (az ? 'Hədəfi keçirsən, əla! İndi həftədə 2 güc məşqi əlavə etməyi düşün.' : 'You\'re above target — great! Consider adding 2 strength sessions a week.');
    return az
        ? '**Sənin addımların:** son ${c.daysTracked7d} gündə orta **${c.avgSteps7d}**, bu gün **${c.todaySteps}**. $advice'
        : '**Your steps:** **${c.avgSteps7d}**/day over the last ${c.daysTracked7d} days, **${c.todaySteps}** today. $advice';
  }

  static String _today(CoachContext c, bool az) {
    final pct = c.goalSteps > 0 ? (c.todaySteps * 100 / c.goalSteps).round() : 0;
    final left = (c.goalSteps - c.todaySteps).clamp(0, 1 << 30);
    final minutes = (left / 100).ceil();
    if (az) {
      return '📅 **Bu gün**\n\n'
          '• Addım: **${c.todaySteps} / ${c.goalSteps}** ($pct%)\n'
          '${left > 0 ? '• Hədəfə **$left** addım qalıb — təxminən $minutes dəqiqəlik sürətli yeriş.\n' : '• 🎉 Günlük hədəfə çatmısan!\n'}'
          '\nAxşam yeməyindən sonra qısa gəzinti həm addım, həm də qan şəkəri üçün faydalıdır.';
    }
    return '📅 **Today**\n\n'
        '• Steps: **${c.todaySteps} / ${c.goalSteps}** ($pct%)\n'
        '${left > 0 ? '• **$left** steps to go — about $minutes minutes of brisk walking.\n' : '• 🎉 Daily goal reached!\n'}'
        '\nA short walk after dinner helps both your steps and blood sugar.';
  }

  static String _week(CoachContext c, CoachAnalysisResult a, bool az) {
    final data = _progressData(c, az);
    if (data == null) {
      return az
          ? '📆 Bu həftə üçün hələ kifayət qədər data yoxdur. Telefonu yanında gəzdir, yuxunu və çəkini qeyd et — bir neçə gündən sonra həftəlik təhlil verərəm.'
          : '📆 There isn\'t enough data for this week yet. Carry your phone, log sleep and weight — I\'ll have a weekly review in a few days.';
    }
    final focus = c.hasStepData && c.goalHits7d < (c.daysTracked7d / 2)
        ? (az ? 'Növbəti həftənin fokusu: **addım ardıcıllığı**.' : 'Next week\'s focus: **step consistency**.')
        : c.hasSleepData && c.avgSleepMinutes7d < 420
            ? (az ? 'Növbəti həftənin fokusu: **yuxu müddəti**.' : 'Next week\'s focus: **sleep duration**.')
            : (az ? 'Növbəti həftənin fokusu: **bu tempi qorumaq** 💪' : 'Next week\'s focus: **keep this momentum** 💪');
    return az ? '📆 **Həftəlik baxış**\n\n$data\n\n$focus' : '📆 **Weekly review**\n\n$data\n\n$focus';
  }

  static String _protein(CoachAnalysisResult a, bool az) {
    final low = (a.currentWeight * 1.2).round();
    final high = (a.currentWeight * 1.6).round();
    return az
        ? '🍗 **Protein**\n\nÇəkinə görə gündə təxminən **$low–$high q** protein yaxşı hədəfdir. Bu, arıqlayarkən əzələni qorumağa və tox qalmağa kömək edir.\n\n'
            '• Hər yeməkdə bir ovuc protein: toyuq, balıq, yumurta, qatıq, kəsmik, mərci, noxud\n'
            '• Səhər yeməyində protein gün boyu aclığı azaldır\n'
            '• Böyrək xəstəliyin varsa, proteini artırmazdan əvvəl həkimlə danış'
        : '🍗 **Protein**\n\nFor your weight, about **$low–$high g** of protein per day is a good target. It protects muscle while losing fat and keeps you full.\n\n'
            '• A palm-sized protein portion at each meal: chicken, fish, eggs, yogurt, cottage cheese, lentils, chickpeas\n'
            '• Protein at breakfast reduces hunger later in the day\n'
            '• If you have kidney disease, check with your doctor before increasing protein';
  }

  static String _mealTiming(bool az) => az
      ? '🕐 **Yemək vaxtları**\n\n'
          '• Ən vacibi ümumi kalori və keyfiyyətdir, saat yox. Amma ardıcıl qrafik iştahı tənzimləyir.\n'
          '• Səhər yeməyi: protein + lif (yumurta, qatıq, yulaf) gün boyu aclığı azaldır.\n'
          '• Yatmazdan 2–3 saat əvvəl yeməyi bitirmək yuxu keyfiyyətinə kömək edir.\n'
          '• Gün ərzində 3 əsas yemək + ehtiyac olsa 1 qəlyanaltı çox insan üçün yaxşı işləyir.'
      : '🕐 **Meal timing**\n\n'
          '• Total calories and food quality matter more than the clock, but a consistent schedule steadies appetite.\n'
          '• Breakfast with protein + fiber (eggs, yogurt, oats) reduces hunger later.\n'
          '• Finishing dinner 2–3 hours before bed helps sleep quality.\n'
          '• 3 main meals + 1 snack if needed works well for most people.';

  static String _snacks(bool az) => az
      ? '🍎 **Aclıq və qəlyanaltılar**\n\n'
          '• Əvvəlcə bir stəkan su iç — susuzluq tez-tez aclıq kimi hiss olunur.\n'
          '• Yaxşı seçimlər: meyvə + bir ovuc qoz-fındıq, qatıq, tərəvəz + humus, qaynadılmış yumurta.\n'
          '• Protein və lif olan qəlyanaltı uzun müddət tox saxlayır.\n'
          '• Tez-tez acıkırsansa, əsas yeməklərdə protein və tərəvəzi artır.'
      : '🍎 **Hunger & snacks**\n\n'
          '• Drink a glass of water first — thirst often feels like hunger.\n'
          '• Good picks: fruit + a handful of nuts, yogurt, veggies + hummus, a boiled egg.\n'
          '• Snacks with protein and fiber keep you full longer.\n'
          '• If you\'re hungry often, add more protein and vegetables to main meals.';

  static String _sugar(bool az) => az
      ? '🍫 **Şirniyyat və şəkər**\n\n'
          'Tam qadağa adətən geri tepir. Daha işlək yanaşma:\n\n'
          '• Şirniyyatı yeməkdən sonra kiçik porsiya ilə ye — ac qarına yox.\n'
          '• Qazlı və şirin içkiləri su, çay və ya mineral su ilə əvəz et — ən asan qazancdır.\n'
          '• Evdə görünən yerdə şirniyyat saxlama.\n'
          '• Şirin istəyi gələndə: meyvə, tünd şokoladdan bir-iki dilim və ya qatıq + bal.'
      : '🍫 **Sweets & sugar**\n\n'
          'Strict bans usually backfire. What works better:\n\n'
          '• Have sweets as a small portion after a meal, not on an empty stomach.\n'
          '• Swap sugary drinks for water, tea, or sparkling water — the easiest win.\n'
          '• Keep sweets out of sight at home.\n'
          '• For cravings: fruit, a square or two of dark chocolate, or yogurt + honey.';

  static String _calories(CoachAnalysisResult a, bool az) {
    final diff = a.targetDailyKcal - a.tdeeKcal;
    final diffText = diff == 0 ? '0' : (diff > 0 ? '+$diff' : '$diff');
    return az
        ? '🔥 **Sənin kalori rəqəmlərin**\n\n'
            '• **BMR** (istirahətdə yandırılan): ${a.bmrKcal} kkal\n'
            '• **TDEE** (aktivliklə birlikdə gündəlik xərc): ${a.tdeeKcal} kkal\n'
            '• **Gündəlik hədəf**: ${a.targetDailyKcal} kkal ($diffText kkal)\n\n'
            'Bu rəqəmlər Mifflin-St Jeor düsturu ilə hesablanır və təxminidir. 2–3 həftəlik çəki trendinə baxıb lazım olsa 100–150 kkal düzəliş et.\n\n'
            '_Gündəlik kalorini çox aşağı salmaq maddələr mübadiləsini yavaşladır və əzələ itkisinə səbəb olur._'
        : '🔥 **Your calorie numbers**\n\n'
            '• **BMR** (burned at rest): ${a.bmrKcal} kcal\n'
            '• **TDEE** (daily burn incl. activity): ${a.tdeeKcal} kcal\n'
            '• **Daily target**: ${a.targetDailyKcal} kcal ($diffText kcal)\n\n'
            'These come from the Mifflin-St Jeor formula and are estimates. Watch your 2–3 week weight trend and adjust by 100–150 kcal if needed.\n\n'
            '_Cutting calories very low slows metabolism and costs muscle._';
  }

  static String _timeline(CoachAnalysisResult a, CoachContext c, bool az) {
    if (a.goalType == WeightGoalType.maintenance) {
      return az
          ? '🎯 Hazırkı çəkin hədəfinə çox yaxındır (${a.currentWeight} → ${a.targetWeight} kg). İndi əsas məqsəd bu çəkini qorumaqdır.'
          : '🎯 You\'re basically at your goal (${a.currentWeight} → ${a.targetWeight} kg). The focus now is maintaining it.';
    }
    final trend = _weightData(c, az);
    return az
        ? '🎯 **Hədəfə qədər**\n\n'
            '${a.currentWeight} kg → ${a.targetWeight} kg: təhlükəsiz **${a.recommendedWeeklyChangeKg} kg/həftə** tempi ilə təxminən **${a.estimatedWeeksToGoal} həftə**.\n'
            '${trend != null ? '\n$trend\n' : ''}'
            '\nÇəki gündən-günə su səbəbindən 0.5–1.5 kg tərpənə bilər. Həftəlik ortaya bax, tək günə yox.'
        : '🎯 **Road to your goal**\n\n'
            '${a.currentWeight} kg → ${a.targetWeight} kg: about **${a.estimatedWeeksToGoal} weeks** at a safe **${a.recommendedWeeklyChangeKg} kg/week**.\n'
            '${trend != null ? '\n$trend\n' : ''}'
            '\nDaily weight swings of 0.5–1.5 kg from water are normal. Judge the weekly average, not a single day.';
  }

  static String _exercise(CoachAnalysisResult a, bool az) {
    final gain = a.goalType == WeightGoalType.gain;
    return az
        ? '🏋️ **Məşq planı (başlanğıc)**\n\n'
            '• Həftədə **2–3 dəfə güc məşqi** (30–40 dəq): squat, şınav (dizüstü də olar), lunge, plank, rezinlə dartma.\n'
            '• Hər hərəkət 2–3 dəst × 8–12 təkrar. Son 2 təkrar çətin olmalıdır.\n'
            '• Qalan günlərdə gəzinti və ya yüngül kardio.\n'
            '• ${gain ? 'Çəki yığmaq üçün güc məşqi + kalori artıqlığı birlikdə işləyir.' : 'Arıqlayarkən güc məşqi əzələni qoruyur, beləliklə itən çəki əsasən piy olur.'}\n\n'
            '_Ağrı hiss etsən dayan. Oynaq və ya ürək problemin varsa, əvvəlcə həkimlə danış._'
        : '🏋️ **Starter training plan**\n\n'
            '• **2–3 strength sessions/week** (30–40 min): squats, push-ups (knees are fine), lunges, planks, band rows.\n'
            '• 2–3 sets × 8–12 reps per move. The last 2 reps should feel hard.\n'
            '• Walk or do light cardio on the other days.\n'
            '• ${gain ? 'To gain weight, strength training plus a calorie surplus works best.' : 'While losing weight, strength work protects muscle so the weight you lose is mostly fat.'}\n\n'
            '_Stop if something hurts. Check with a doctor first if you have joint or heart issues._';
  }

  static String _cardio(bool az) => az
      ? '🏃 **Qaçış və kardio**\n\n'
          '• Yenisənsə, "qaç–yeri" üsulu ilə başla: 1 dəq qaç + 2 dəq yeri, 20 dəqiqə, həftədə 3 dəfə.\n'
          '• Hər həftə qaçış hissəsini bir az uzat. Danışa biləcəyin tempdə qal.\n'
          '• Həftəlik məsafəni hər dəfə 10%-dən çox artırma — zədə riskini azaldır.\n'
          '• Velosiped və üzgüçülük oynaqlara daha az yük salır.'
      : '🏃 **Running & cardio**\n\n'
          '• New to it? Start run–walk: 1 min run + 2 min walk, 20 minutes, 3× a week.\n'
          '• Lengthen the run intervals a little each week. Stay at a pace where you can talk.\n'
          '• Don\'t raise weekly distance by more than ~10% — it lowers injury risk.\n'
          '• Cycling and swimming are easier on the joints.';

  static String _motivation(CoachContext c, bool az) {
    final win = c.hasStepData && c.goalHits7d > 0
        ? (az ? 'Son 7 gündə **${c.goalHits7d}** dəfə addım hədəfinə çatmısan — bu, artıq nəticədir.\n\n' : 'You hit your step goal **${c.goalHits7d}** times in the last 7 days — that\'s real progress.\n\n')
        : '';
    return az
        ? '💪 **Motivasiya düşəndə**\n\n$win'
            '• Hədəfi kiçilt: "10 dəqiqə gəzim" — başlamaq ən çətin hissədir.\n'
            '• Motivasiyaya yox, vərdişə arxalan: hər gün eyni saatda eyni kiçik addım.\n'
            '• Pis gün = uğursuzluq deyil. Növbəti yeməkdən yenidən başla.\n'
            '• Yalnız tərəziyə yox, enerji, yuxu və paltarın oturuşuna da bax.'
        : '💪 **When motivation dips**\n\n$win'
            '• Shrink the goal: "just a 10-minute walk" — starting is the hardest part.\n'
            '• Rely on habits, not motivation: the same small action at the same time each day.\n'
            '• A bad day isn\'t failure. Restart at the next meal.\n'
            '• Track energy, sleep, and how clothes fit — not just the scale.';
  }

  static String _stress(bool az) => az
      ? '😮‍💨 **Stres və çəki**\n\n'
          'Stres kortizolu artırır, bu da iştahı və şirinə meyli gücləndirir.\n\n'
          '• 4–6 nəfəs: 4 saniyə nəfəs al, 6 saniyə ver, 2 dəqiqə — sinir sistemini sakitləşdirir.\n'
          '• Qısa gəzinti stresi azaltmağın ən sadə yoludur.\n'
          '• Yuxunu qoru — yorğunluq stresi artırır.\n'
          '• Stres uzun müddət davam edirsə və gündəlik həyatına təsir edirsə, psixoloqla danışmaq çox kömək edə bilər.'
      : '😮‍💨 **Stress & weight**\n\n'
          'Stress raises cortisol, which boosts appetite and sugar cravings.\n\n'
          '• 4–6 breathing: inhale 4 s, exhale 6 s, for 2 minutes — calms the nervous system.\n'
          '• A short walk is one of the simplest stress relievers.\n'
          '• Protect your sleep — fatigue amplifies stress.\n'
          '• If stress is ongoing and affecting daily life, talking to a psychologist can really help.';

  static String _alcohol(bool az) => az
      ? '🍷 **Alkoqol və çəki**\n\n'
          '• Alkoqolun qramında 7 kkal var, üstəlik iştahı artırır və yuxu keyfiyyətini pisləşdirir.\n'
          '• İçəcəksənsə: hər içkidən sonra bir stəkan su, şirin kokteyllərdən uzaq dur, əvvəlcədən yemək ye.\n'
          '• Həftədə alkoqolsuz günlər çox olduqca nəticə daha yaxşı olur.'
      : '🍷 **Alcohol & weight**\n\n'
          '• Alcohol has 7 kcal per gram, increases appetite, and worsens sleep quality.\n'
          '• If you drink: a glass of water between drinks, skip sugary cocktails, eat beforehand.\n'
          '• More alcohol-free days per week means better results.';

  static String _fasting(bool az) => az
      ? '⏳ **Aralıqlı oruc (məsələn 16:8)**\n\n'
          '• Bəziləri üçün kalorini azaltmağın rahat yoludur, amma adi kalori nəzarətindən "sehrli" dərəcədə üstün deyil.\n'
          '• Yemək pəncərəsində protein və tərəvəzə üstünlük ver, sonra həddən artıq yemə.\n'
          '• **Uyğun deyil:** hamiləlik, şəkərli diabet (xüsusən dərman qəbul edirsənsə), qidalanma pozuntusu tarixçəsi, 18 yaşdan kiçiklər. Bu hallarda həkimlə danış.'
      : '⏳ **Intermittent fasting (e.g. 16:8)**\n\n'
          '• It\'s a convenient way for some people to eat less, but it isn\'t magically better than regular calorie control.\n'
          '• Prioritize protein and vegetables in your eating window, and avoid overeating after.\n'
          '• **Not suitable for:** pregnancy, diabetes (especially on medication), a history of eating disorders, under-18s. Talk to a doctor in those cases.';

  static String _weightGain(CoachAnalysisResult a, bool az) {
    final target = a.tdeeKcal + 300;
    return az
        ? '📈 **Sağlam çəki yığmaq**\n\n'
            '• Gündəlik təxminən **$target kkal** (TDEE + 300) ilə başla — həftədə 0.25–0.5 kg artım hədəflə.\n'
            '• Həftədə 3 güc məşqi ki, artan çəki əsasən əzələ olsun.\n'
            '• Kaloriyə zəngin, sağlam qidalar: qoz-fındıq, fıstıq yağı, zeytun yağı, avokado, tam yağlı qatıq, quru meyvə.\n'
            '• 3 yemək + 2 qəlyanaltı. Səbəbsiz arıqlayırsansa, həkimə müraciət et.'
        : '📈 **Healthy weight gain**\n\n'
            '• Start around **$target kcal/day** (TDEE + 300) — aim for 0.25–0.5 kg per week.\n'
            '• 3 strength sessions a week so the gain is mostly muscle.\n'
            '• Energy-dense healthy foods: nuts, peanut butter, olive oil, avocado, full-fat yogurt, dried fruit.\n'
            '• 3 meals + 2 snacks. If you\'re losing weight without trying, see a doctor.';
  }

  static String _medical(bool az) => az
      ? '🩺 Bu, sağlamlıq vəziyyəti ilə bağlı sualdır və buna həkim cavab verməlidir. Coach Leo diaqnoz qoya və ya müalicə tövsiyə edə bilməz.\n\n'
          '• **Sinə ağrısı, nəfəs darlığı, huşun itməsi** kimi kəskin simptomlar varsa, dərhal **103** (təcili yardım) və ya **112** nömrəsinə zəng et.\n'
          '• Xroniki xəstəliyin (diabet, təzyiq, ürək, tiroid), hamiləliyin və ya dərman qəbulun varsa, pəhriz və məşq planını həkiminlə razılaşdır.\n\n'
          'Ümumi vərdişlər (yuxu, su, yeriş) haqqında sual versən, kömək edərəm.'
      : '🩺 That\'s a health-condition question, and a doctor should answer it. Coach Leo can\'t diagnose or recommend treatment.\n\n'
          '• For urgent symptoms like **chest pain, shortness of breath, or fainting**, call emergency services right away.\n'
          '• If you have a chronic condition (diabetes, blood pressure, heart, thyroid), are pregnant, or take medication, agree on diet and exercise changes with your doctor.\n\n'
          'Happy to help with general habits like sleep, water, and walking.';

  static String _eatingConcern(bool az) => az
      ? '💛 Bunu yazdığın üçün təşəkkür edirəm. Ac qalmaq, çox az yemək, qusma və ya işlətmə dərmanları ilə çəki idarə etmək sağlamlıq üçün ciddi risklidir və bu mövzuda sənə rəqəm və ya plan verməyəcəyəm.\n\n'
          'Yemək və bədən çəkisi ilə bağlı fikirlər səni narahat edirsə, bunu güvəndiyin biri ilə və ya həkim/psixoloqla bölüşmək çox kömək edir. Sən dəstəyə layiqsən.\n\n'
          'İstəsən, yuxu, stres və ya ümumi rifah haqqında danışa bilərik.'
      : '💛 Thank you for sharing this. Fasting for long periods, eating very little, vomiting, or using laxatives to control weight carries serious health risks, so I won\'t give numbers or a plan for that.\n\n'
          'If thoughts about food or your body are weighing on you, talking to someone you trust or to a doctor or psychologist can really help. You deserve support.\n\n'
          'If you\'d like, we can talk about sleep, stress, or general wellbeing.';

  static String _detail(CoachIntent intent, CoachAnalysisResult a, CoachContext c, bool az) {
    switch (intent) {
      case CoachIntent.nutrition:
      case CoachIntent.calories:
        return _protein(a, az);
      case CoachIntent.protein:
        return _mealTiming(az);
      case CoachIntent.steps:
      case CoachIntent.today:
        return _exercise(a, az);
      case CoachIntent.exercise:
        return _cardio(az);
      case CoachIntent.sleep:
        return _stress(az);
      case CoachIntent.plateau:
      case CoachIntent.progress:
      case CoachIntent.week:
        return _calories(a, az);
      case CoachIntent.sugar:
      case CoachIntent.snacks:
        return _mealTiming(az);
      default:
        return _help(a, az, unknown: false);
    }
  }
}
