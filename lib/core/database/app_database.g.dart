// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DailyActivityEntriesTable extends DailyActivityEntries
    with TableInfo<$DailyActivityEntriesTable, DailyActivityEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyActivityEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
    'steps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _distanceKmMeta = const VerificationMeta(
    'distanceKm',
  );
  @override
  late final GeneratedColumn<double> distanceKm = GeneratedColumn<double>(
    'distance_km',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _activeMinutesMeta = const VerificationMeta(
    'activeMinutes',
  );
  @override
  late final GeneratedColumn<int> activeMinutes = GeneratedColumn<int>(
    'active_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _goalStepsMeta = const VerificationMeta(
    'goalSteps',
  );
  @override
  late final GeneratedColumn<int> goalSteps = GeneratedColumn<int>(
    'goal_steps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8000),
  );
  static const VerificationMeta _isGoalCompletedMeta = const VerificationMeta(
    'isGoalCompleted',
  );
  @override
  late final GeneratedColumn<bool> isGoalCompleted = GeneratedColumn<bool>(
    'is_goal_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_goal_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    steps,
    distanceKm,
    calories,
    activeMinutes,
    goalSteps,
    isGoalCompleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_activity_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyActivityEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('steps')) {
      context.handle(
        _stepsMeta,
        steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta),
      );
    }
    if (data.containsKey('distance_km')) {
      context.handle(
        _distanceKmMeta,
        distanceKm.isAcceptableOrUnknown(data['distance_km']!, _distanceKmMeta),
      );
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('active_minutes')) {
      context.handle(
        _activeMinutesMeta,
        activeMinutes.isAcceptableOrUnknown(
          data['active_minutes']!,
          _activeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('goal_steps')) {
      context.handle(
        _goalStepsMeta,
        goalSteps.isAcceptableOrUnknown(data['goal_steps']!, _goalStepsMeta),
      );
    }
    if (data.containsKey('is_goal_completed')) {
      context.handle(
        _isGoalCompletedMeta,
        isGoalCompleted.isAcceptableOrUnknown(
          data['is_goal_completed']!,
          _isGoalCompletedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DailyActivityEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyActivityEntry(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      steps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}steps'],
      )!,
      distanceKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_km'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories'],
      )!,
      activeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}active_minutes'],
      )!,
      goalSteps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_steps'],
      )!,
      isGoalCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_goal_completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyActivityEntriesTable createAlias(String alias) {
    return $DailyActivityEntriesTable(attachedDatabase, alias);
  }
}

class DailyActivityEntry extends DataClass
    implements Insertable<DailyActivityEntry> {
  /// Local calendar date representation: "YYYY-MM-DD" (Primary Key)
  final String date;
  final int steps;
  final double distanceKm;
  final int calories;
  final int activeMinutes;
  final int goalSteps;
  final bool isGoalCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DailyActivityEntry({
    required this.date,
    required this.steps,
    required this.distanceKm,
    required this.calories,
    required this.activeMinutes,
    required this.goalSteps,
    required this.isGoalCompleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['steps'] = Variable<int>(steps);
    map['distance_km'] = Variable<double>(distanceKm);
    map['calories'] = Variable<int>(calories);
    map['active_minutes'] = Variable<int>(activeMinutes);
    map['goal_steps'] = Variable<int>(goalSteps);
    map['is_goal_completed'] = Variable<bool>(isGoalCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyActivityEntriesCompanion toCompanion(bool nullToAbsent) {
    return DailyActivityEntriesCompanion(
      date: Value(date),
      steps: Value(steps),
      distanceKm: Value(distanceKm),
      calories: Value(calories),
      activeMinutes: Value(activeMinutes),
      goalSteps: Value(goalSteps),
      isGoalCompleted: Value(isGoalCompleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyActivityEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyActivityEntry(
      date: serializer.fromJson<String>(json['date']),
      steps: serializer.fromJson<int>(json['steps']),
      distanceKm: serializer.fromJson<double>(json['distanceKm']),
      calories: serializer.fromJson<int>(json['calories']),
      activeMinutes: serializer.fromJson<int>(json['activeMinutes']),
      goalSteps: serializer.fromJson<int>(json['goalSteps']),
      isGoalCompleted: serializer.fromJson<bool>(json['isGoalCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'steps': serializer.toJson<int>(steps),
      'distanceKm': serializer.toJson<double>(distanceKm),
      'calories': serializer.toJson<int>(calories),
      'activeMinutes': serializer.toJson<int>(activeMinutes),
      'goalSteps': serializer.toJson<int>(goalSteps),
      'isGoalCompleted': serializer.toJson<bool>(isGoalCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyActivityEntry copyWith({
    String? date,
    int? steps,
    double? distanceKm,
    int? calories,
    int? activeMinutes,
    int? goalSteps,
    bool? isGoalCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DailyActivityEntry(
    date: date ?? this.date,
    steps: steps ?? this.steps,
    distanceKm: distanceKm ?? this.distanceKm,
    calories: calories ?? this.calories,
    activeMinutes: activeMinutes ?? this.activeMinutes,
    goalSteps: goalSteps ?? this.goalSteps,
    isGoalCompleted: isGoalCompleted ?? this.isGoalCompleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DailyActivityEntry copyWithCompanion(DailyActivityEntriesCompanion data) {
    return DailyActivityEntry(
      date: data.date.present ? data.date.value : this.date,
      steps: data.steps.present ? data.steps.value : this.steps,
      distanceKm: data.distanceKm.present
          ? data.distanceKm.value
          : this.distanceKm,
      calories: data.calories.present ? data.calories.value : this.calories,
      activeMinutes: data.activeMinutes.present
          ? data.activeMinutes.value
          : this.activeMinutes,
      goalSteps: data.goalSteps.present ? data.goalSteps.value : this.goalSteps,
      isGoalCompleted: data.isGoalCompleted.present
          ? data.isGoalCompleted.value
          : this.isGoalCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyActivityEntry(')
          ..write('date: $date, ')
          ..write('steps: $steps, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('calories: $calories, ')
          ..write('activeMinutes: $activeMinutes, ')
          ..write('goalSteps: $goalSteps, ')
          ..write('isGoalCompleted: $isGoalCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    date,
    steps,
    distanceKm,
    calories,
    activeMinutes,
    goalSteps,
    isGoalCompleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyActivityEntry &&
          other.date == this.date &&
          other.steps == this.steps &&
          other.distanceKm == this.distanceKm &&
          other.calories == this.calories &&
          other.activeMinutes == this.activeMinutes &&
          other.goalSteps == this.goalSteps &&
          other.isGoalCompleted == this.isGoalCompleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DailyActivityEntriesCompanion
    extends UpdateCompanion<DailyActivityEntry> {
  final Value<String> date;
  final Value<int> steps;
  final Value<double> distanceKm;
  final Value<int> calories;
  final Value<int> activeMinutes;
  final Value<int> goalSteps;
  final Value<bool> isGoalCompleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DailyActivityEntriesCompanion({
    this.date = const Value.absent(),
    this.steps = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.calories = const Value.absent(),
    this.activeMinutes = const Value.absent(),
    this.goalSteps = const Value.absent(),
    this.isGoalCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyActivityEntriesCompanion.insert({
    required String date,
    this.steps = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.calories = const Value.absent(),
    this.activeMinutes = const Value.absent(),
    this.goalSteps = const Value.absent(),
    this.isGoalCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DailyActivityEntry> custom({
    Expression<String>? date,
    Expression<int>? steps,
    Expression<double>? distanceKm,
    Expression<int>? calories,
    Expression<int>? activeMinutes,
    Expression<int>? goalSteps,
    Expression<bool>? isGoalCompleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (steps != null) 'steps': steps,
      if (distanceKm != null) 'distance_km': distanceKm,
      if (calories != null) 'calories': calories,
      if (activeMinutes != null) 'active_minutes': activeMinutes,
      if (goalSteps != null) 'goal_steps': goalSteps,
      if (isGoalCompleted != null) 'is_goal_completed': isGoalCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyActivityEntriesCompanion copyWith({
    Value<String>? date,
    Value<int>? steps,
    Value<double>? distanceKm,
    Value<int>? calories,
    Value<int>? activeMinutes,
    Value<int>? goalSteps,
    Value<bool>? isGoalCompleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DailyActivityEntriesCompanion(
      date: date ?? this.date,
      steps: steps ?? this.steps,
      distanceKm: distanceKm ?? this.distanceKm,
      calories: calories ?? this.calories,
      activeMinutes: activeMinutes ?? this.activeMinutes,
      goalSteps: goalSteps ?? this.goalSteps,
      isGoalCompleted: isGoalCompleted ?? this.isGoalCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (distanceKm.present) {
      map['distance_km'] = Variable<double>(distanceKm.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (activeMinutes.present) {
      map['active_minutes'] = Variable<int>(activeMinutes.value);
    }
    if (goalSteps.present) {
      map['goal_steps'] = Variable<int>(goalSteps.value);
    }
    if (isGoalCompleted.present) {
      map['is_goal_completed'] = Variable<bool>(isGoalCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyActivityEntriesCompanion(')
          ..write('date: $date, ')
          ..write('steps: $steps, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('calories: $calories, ')
          ..write('activeMinutes: $activeMinutes, ')
          ..write('goalSteps: $goalSteps, ')
          ..write('isGoalCompleted: $isGoalCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedRoutesEntriesTable extends SavedRoutesEntries
    with TableInfo<$SavedRoutesEntriesTable, SavedRoutesEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedRoutesEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routeDateTimeMeta = const VerificationMeta(
    'routeDateTime',
  );
  @override
  late final GeneratedColumn<DateTime> routeDateTime =
      GeneratedColumn<DateTime>(
        'date_time',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _distanceKmMeta = const VerificationMeta(
    'distanceKm',
  );
  @override
  late final GeneratedColumn<double> distanceKm = GeneratedColumn<double>(
    'distance_km',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avgSpeedKmHMeta = const VerificationMeta(
    'avgSpeedKmH',
  );
  @override
  late final GeneratedColumn<double> avgSpeedKmH = GeneratedColumn<double>(
    'avg_speed_km_h',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleDistanceKmMeta = const VerificationMeta(
    'vehicleDistanceKm',
  );
  @override
  late final GeneratedColumn<double> vehicleDistanceKm =
      GeneratedColumn<double>(
        'vehicle_distance_km',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _coordinatesJsonMeta = const VerificationMeta(
    'coordinatesJson',
  );
  @override
  late final GeneratedColumn<String> coordinatesJson = GeneratedColumn<String>(
    'coordinates_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    routeDateTime,
    distanceKm,
    durationSeconds,
    avgSpeedKmH,
    calories,
    vehicleDistanceKm,
    coordinatesJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_routes_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedRoutesEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('date_time')) {
      context.handle(
        _routeDateTimeMeta,
        routeDateTime.isAcceptableOrUnknown(
          data['date_time']!,
          _routeDateTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_routeDateTimeMeta);
    }
    if (data.containsKey('distance_km')) {
      context.handle(
        _distanceKmMeta,
        distanceKm.isAcceptableOrUnknown(data['distance_km']!, _distanceKmMeta),
      );
    } else if (isInserting) {
      context.missing(_distanceKmMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('avg_speed_km_h')) {
      context.handle(
        _avgSpeedKmHMeta,
        avgSpeedKmH.isAcceptableOrUnknown(
          data['avg_speed_km_h']!,
          _avgSpeedKmHMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_avgSpeedKmHMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('vehicle_distance_km')) {
      context.handle(
        _vehicleDistanceKmMeta,
        vehicleDistanceKm.isAcceptableOrUnknown(
          data['vehicle_distance_km']!,
          _vehicleDistanceKmMeta,
        ),
      );
    }
    if (data.containsKey('coordinates_json')) {
      context.handle(
        _coordinatesJsonMeta,
        coordinatesJson.isAcceptableOrUnknown(
          data['coordinates_json']!,
          _coordinatesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_coordinatesJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedRoutesEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedRoutesEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      routeDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_time'],
      )!,
      distanceKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_km'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      avgSpeedKmH: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_speed_km_h'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories'],
      )!,
      vehicleDistanceKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vehicle_distance_km'],
      )!,
      coordinatesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}coordinates_json'],
      )!,
    );
  }

  @override
  $SavedRoutesEntriesTable createAlias(String alias) {
    return $SavedRoutesEntriesTable(attachedDatabase, alias);
  }
}

class SavedRoutesEntry extends DataClass
    implements Insertable<SavedRoutesEntry> {
  final String id;
  final String title;
  final DateTime routeDateTime;
  final double distanceKm;
  final int durationSeconds;
  final double avgSpeedKmH;
  final int calories;
  final double vehicleDistanceKm;
  final String coordinatesJson;
  const SavedRoutesEntry({
    required this.id,
    required this.title,
    required this.routeDateTime,
    required this.distanceKm,
    required this.durationSeconds,
    required this.avgSpeedKmH,
    required this.calories,
    required this.vehicleDistanceKm,
    required this.coordinatesJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['date_time'] = Variable<DateTime>(routeDateTime);
    map['distance_km'] = Variable<double>(distanceKm);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['avg_speed_km_h'] = Variable<double>(avgSpeedKmH);
    map['calories'] = Variable<int>(calories);
    map['vehicle_distance_km'] = Variable<double>(vehicleDistanceKm);
    map['coordinates_json'] = Variable<String>(coordinatesJson);
    return map;
  }

  SavedRoutesEntriesCompanion toCompanion(bool nullToAbsent) {
    return SavedRoutesEntriesCompanion(
      id: Value(id),
      title: Value(title),
      routeDateTime: Value(routeDateTime),
      distanceKm: Value(distanceKm),
      durationSeconds: Value(durationSeconds),
      avgSpeedKmH: Value(avgSpeedKmH),
      calories: Value(calories),
      vehicleDistanceKm: Value(vehicleDistanceKm),
      coordinatesJson: Value(coordinatesJson),
    );
  }

  factory SavedRoutesEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedRoutesEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      routeDateTime: serializer.fromJson<DateTime>(json['routeDateTime']),
      distanceKm: serializer.fromJson<double>(json['distanceKm']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      avgSpeedKmH: serializer.fromJson<double>(json['avgSpeedKmH']),
      calories: serializer.fromJson<int>(json['calories']),
      vehicleDistanceKm: serializer.fromJson<double>(json['vehicleDistanceKm']),
      coordinatesJson: serializer.fromJson<String>(json['coordinatesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'routeDateTime': serializer.toJson<DateTime>(routeDateTime),
      'distanceKm': serializer.toJson<double>(distanceKm),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'avgSpeedKmH': serializer.toJson<double>(avgSpeedKmH),
      'calories': serializer.toJson<int>(calories),
      'vehicleDistanceKm': serializer.toJson<double>(vehicleDistanceKm),
      'coordinatesJson': serializer.toJson<String>(coordinatesJson),
    };
  }

  SavedRoutesEntry copyWith({
    String? id,
    String? title,
    DateTime? routeDateTime,
    double? distanceKm,
    int? durationSeconds,
    double? avgSpeedKmH,
    int? calories,
    double? vehicleDistanceKm,
    String? coordinatesJson,
  }) => SavedRoutesEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    routeDateTime: routeDateTime ?? this.routeDateTime,
    distanceKm: distanceKm ?? this.distanceKm,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    avgSpeedKmH: avgSpeedKmH ?? this.avgSpeedKmH,
    calories: calories ?? this.calories,
    vehicleDistanceKm: vehicleDistanceKm ?? this.vehicleDistanceKm,
    coordinatesJson: coordinatesJson ?? this.coordinatesJson,
  );
  SavedRoutesEntry copyWithCompanion(SavedRoutesEntriesCompanion data) {
    return SavedRoutesEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      routeDateTime: data.routeDateTime.present
          ? data.routeDateTime.value
          : this.routeDateTime,
      distanceKm: data.distanceKm.present
          ? data.distanceKm.value
          : this.distanceKm,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      avgSpeedKmH: data.avgSpeedKmH.present
          ? data.avgSpeedKmH.value
          : this.avgSpeedKmH,
      calories: data.calories.present ? data.calories.value : this.calories,
      vehicleDistanceKm: data.vehicleDistanceKm.present
          ? data.vehicleDistanceKm.value
          : this.vehicleDistanceKm,
      coordinatesJson: data.coordinatesJson.present
          ? data.coordinatesJson.value
          : this.coordinatesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedRoutesEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('routeDateTime: $routeDateTime, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('avgSpeedKmH: $avgSpeedKmH, ')
          ..write('calories: $calories, ')
          ..write('vehicleDistanceKm: $vehicleDistanceKm, ')
          ..write('coordinatesJson: $coordinatesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    routeDateTime,
    distanceKm,
    durationSeconds,
    avgSpeedKmH,
    calories,
    vehicleDistanceKm,
    coordinatesJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedRoutesEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.routeDateTime == this.routeDateTime &&
          other.distanceKm == this.distanceKm &&
          other.durationSeconds == this.durationSeconds &&
          other.avgSpeedKmH == this.avgSpeedKmH &&
          other.calories == this.calories &&
          other.vehicleDistanceKm == this.vehicleDistanceKm &&
          other.coordinatesJson == this.coordinatesJson);
}

class SavedRoutesEntriesCompanion extends UpdateCompanion<SavedRoutesEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<DateTime> routeDateTime;
  final Value<double> distanceKm;
  final Value<int> durationSeconds;
  final Value<double> avgSpeedKmH;
  final Value<int> calories;
  final Value<double> vehicleDistanceKm;
  final Value<String> coordinatesJson;
  final Value<int> rowid;
  const SavedRoutesEntriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.routeDateTime = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.avgSpeedKmH = const Value.absent(),
    this.calories = const Value.absent(),
    this.vehicleDistanceKm = const Value.absent(),
    this.coordinatesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedRoutesEntriesCompanion.insert({
    required String id,
    required String title,
    required DateTime routeDateTime,
    required double distanceKm,
    required int durationSeconds,
    required double avgSpeedKmH,
    required int calories,
    this.vehicleDistanceKm = const Value.absent(),
    required String coordinatesJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       routeDateTime = Value(routeDateTime),
       distanceKm = Value(distanceKm),
       durationSeconds = Value(durationSeconds),
       avgSpeedKmH = Value(avgSpeedKmH),
       calories = Value(calories),
       coordinatesJson = Value(coordinatesJson);
  static Insertable<SavedRoutesEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<DateTime>? routeDateTime,
    Expression<double>? distanceKm,
    Expression<int>? durationSeconds,
    Expression<double>? avgSpeedKmH,
    Expression<int>? calories,
    Expression<double>? vehicleDistanceKm,
    Expression<String>? coordinatesJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (routeDateTime != null) 'date_time': routeDateTime,
      if (distanceKm != null) 'distance_km': distanceKm,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (avgSpeedKmH != null) 'avg_speed_km_h': avgSpeedKmH,
      if (calories != null) 'calories': calories,
      if (vehicleDistanceKm != null) 'vehicle_distance_km': vehicleDistanceKm,
      if (coordinatesJson != null) 'coordinates_json': coordinatesJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedRoutesEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<DateTime>? routeDateTime,
    Value<double>? distanceKm,
    Value<int>? durationSeconds,
    Value<double>? avgSpeedKmH,
    Value<int>? calories,
    Value<double>? vehicleDistanceKm,
    Value<String>? coordinatesJson,
    Value<int>? rowid,
  }) {
    return SavedRoutesEntriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      routeDateTime: routeDateTime ?? this.routeDateTime,
      distanceKm: distanceKm ?? this.distanceKm,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      avgSpeedKmH: avgSpeedKmH ?? this.avgSpeedKmH,
      calories: calories ?? this.calories,
      vehicleDistanceKm: vehicleDistanceKm ?? this.vehicleDistanceKm,
      coordinatesJson: coordinatesJson ?? this.coordinatesJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (routeDateTime.present) {
      map['date_time'] = Variable<DateTime>(routeDateTime.value);
    }
    if (distanceKm.present) {
      map['distance_km'] = Variable<double>(distanceKm.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (avgSpeedKmH.present) {
      map['avg_speed_km_h'] = Variable<double>(avgSpeedKmH.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (vehicleDistanceKm.present) {
      map['vehicle_distance_km'] = Variable<double>(vehicleDistanceKm.value);
    }
    if (coordinatesJson.present) {
      map['coordinates_json'] = Variable<String>(coordinatesJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedRoutesEntriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('routeDateTime: $routeDateTime, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('avgSpeedKmH: $avgSpeedKmH, ')
          ..write('calories: $calories, ')
          ..write('vehicleDistanceKm: $vehicleDistanceKm, ')
          ..write('coordinatesJson: $coordinatesJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MigrationMetadataEntriesTable extends MigrationMetadataEntries
    with TableInfo<$MigrationMetadataEntriesTable, MigrationMetadataEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MigrationMetadataEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _migratedAtMeta = const VerificationMeta(
    'migratedAt',
  );
  @override
  late final GeneratedColumn<DateTime> migratedAt = GeneratedColumn<DateTime>(
    'migrated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordsCountMeta = const VerificationMeta(
    'recordsCount',
  );
  @override
  late final GeneratedColumn<int> recordsCount = GeneratedColumn<int>(
    'records_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _verificationHashMeta = const VerificationMeta(
    'verificationHash',
  );
  @override
  late final GeneratedColumn<String> verificationHash = GeneratedColumn<String>(
    'verification_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    isCompleted,
    migratedAt,
    recordsCount,
    verificationHash,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'migration_metadata_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<MigrationMetadataEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('migrated_at')) {
      context.handle(
        _migratedAtMeta,
        migratedAt.isAcceptableOrUnknown(data['migrated_at']!, _migratedAtMeta),
      );
    }
    if (data.containsKey('records_count')) {
      context.handle(
        _recordsCountMeta,
        recordsCount.isAcceptableOrUnknown(
          data['records_count']!,
          _recordsCountMeta,
        ),
      );
    }
    if (data.containsKey('verification_hash')) {
      context.handle(
        _verificationHashMeta,
        verificationHash.isAcceptableOrUnknown(
          data['verification_hash']!,
          _verificationHashMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  MigrationMetadataEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MigrationMetadataEntry(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      migratedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}migrated_at'],
      ),
      recordsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}records_count'],
      )!,
      verificationHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verification_hash'],
      ),
    );
  }

  @override
  $MigrationMetadataEntriesTable createAlias(String alias) {
    return $MigrationMetadataEntriesTable(attachedDatabase, alias);
  }
}

class MigrationMetadataEntry extends DataClass
    implements Insertable<MigrationMetadataEntry> {
  final String key;
  final bool isCompleted;
  final DateTime? migratedAt;
  final int recordsCount;
  final String? verificationHash;
  const MigrationMetadataEntry({
    required this.key,
    required this.isCompleted,
    this.migratedAt,
    required this.recordsCount,
    this.verificationHash,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || migratedAt != null) {
      map['migrated_at'] = Variable<DateTime>(migratedAt);
    }
    map['records_count'] = Variable<int>(recordsCount);
    if (!nullToAbsent || verificationHash != null) {
      map['verification_hash'] = Variable<String>(verificationHash);
    }
    return map;
  }

  MigrationMetadataEntriesCompanion toCompanion(bool nullToAbsent) {
    return MigrationMetadataEntriesCompanion(
      key: Value(key),
      isCompleted: Value(isCompleted),
      migratedAt: migratedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(migratedAt),
      recordsCount: Value(recordsCount),
      verificationHash: verificationHash == null && nullToAbsent
          ? const Value.absent()
          : Value(verificationHash),
    );
  }

  factory MigrationMetadataEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MigrationMetadataEntry(
      key: serializer.fromJson<String>(json['key']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      migratedAt: serializer.fromJson<DateTime?>(json['migratedAt']),
      recordsCount: serializer.fromJson<int>(json['recordsCount']),
      verificationHash: serializer.fromJson<String?>(json['verificationHash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'migratedAt': serializer.toJson<DateTime?>(migratedAt),
      'recordsCount': serializer.toJson<int>(recordsCount),
      'verificationHash': serializer.toJson<String?>(verificationHash),
    };
  }

  MigrationMetadataEntry copyWith({
    String? key,
    bool? isCompleted,
    Value<DateTime?> migratedAt = const Value.absent(),
    int? recordsCount,
    Value<String?> verificationHash = const Value.absent(),
  }) => MigrationMetadataEntry(
    key: key ?? this.key,
    isCompleted: isCompleted ?? this.isCompleted,
    migratedAt: migratedAt.present ? migratedAt.value : this.migratedAt,
    recordsCount: recordsCount ?? this.recordsCount,
    verificationHash: verificationHash.present
        ? verificationHash.value
        : this.verificationHash,
  );
  MigrationMetadataEntry copyWithCompanion(
    MigrationMetadataEntriesCompanion data,
  ) {
    return MigrationMetadataEntry(
      key: data.key.present ? data.key.value : this.key,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      migratedAt: data.migratedAt.present
          ? data.migratedAt.value
          : this.migratedAt,
      recordsCount: data.recordsCount.present
          ? data.recordsCount.value
          : this.recordsCount,
      verificationHash: data.verificationHash.present
          ? data.verificationHash.value
          : this.verificationHash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MigrationMetadataEntry(')
          ..write('key: $key, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('migratedAt: $migratedAt, ')
          ..write('recordsCount: $recordsCount, ')
          ..write('verificationHash: $verificationHash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(key, isCompleted, migratedAt, recordsCount, verificationHash);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MigrationMetadataEntry &&
          other.key == this.key &&
          other.isCompleted == this.isCompleted &&
          other.migratedAt == this.migratedAt &&
          other.recordsCount == this.recordsCount &&
          other.verificationHash == this.verificationHash);
}

class MigrationMetadataEntriesCompanion
    extends UpdateCompanion<MigrationMetadataEntry> {
  final Value<String> key;
  final Value<bool> isCompleted;
  final Value<DateTime?> migratedAt;
  final Value<int> recordsCount;
  final Value<String?> verificationHash;
  final Value<int> rowid;
  const MigrationMetadataEntriesCompanion({
    this.key = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.migratedAt = const Value.absent(),
    this.recordsCount = const Value.absent(),
    this.verificationHash = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MigrationMetadataEntriesCompanion.insert({
    required String key,
    this.isCompleted = const Value.absent(),
    this.migratedAt = const Value.absent(),
    this.recordsCount = const Value.absent(),
    this.verificationHash = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<MigrationMetadataEntry> custom({
    Expression<String>? key,
    Expression<bool>? isCompleted,
    Expression<DateTime>? migratedAt,
    Expression<int>? recordsCount,
    Expression<String>? verificationHash,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (migratedAt != null) 'migrated_at': migratedAt,
      if (recordsCount != null) 'records_count': recordsCount,
      if (verificationHash != null) 'verification_hash': verificationHash,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MigrationMetadataEntriesCompanion copyWith({
    Value<String>? key,
    Value<bool>? isCompleted,
    Value<DateTime?>? migratedAt,
    Value<int>? recordsCount,
    Value<String?>? verificationHash,
    Value<int>? rowid,
  }) {
    return MigrationMetadataEntriesCompanion(
      key: key ?? this.key,
      isCompleted: isCompleted ?? this.isCompleted,
      migratedAt: migratedAt ?? this.migratedAt,
      recordsCount: recordsCount ?? this.recordsCount,
      verificationHash: verificationHash ?? this.verificationHash,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (migratedAt.present) {
      map['migrated_at'] = Variable<DateTime>(migratedAt.value);
    }
    if (recordsCount.present) {
      map['records_count'] = Variable<int>(recordsCount.value);
    }
    if (verificationHash.present) {
      map['verification_hash'] = Variable<String>(verificationHash.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MigrationMetadataEntriesCompanion(')
          ..write('key: $key, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('migratedAt: $migratedAt, ')
          ..write('recordsCount: $recordsCount, ')
          ..write('verificationHash: $verificationHash, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SleepRecordsEntriesTable extends SleepRecordsEntries
    with TableInfo<$SleepRecordsEntriesTable, SleepRecordsEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SleepRecordsEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bedtimeMeta = const VerificationMeta(
    'bedtime',
  );
  @override
  late final GeneratedColumn<DateTime> bedtime = GeneratedColumn<DateTime>(
    'bedtime',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wakeTimeMeta = const VerificationMeta(
    'wakeTime',
  );
  @override
  late final GeneratedColumn<DateTime> wakeTime = GeneratedColumn<DateTime>(
    'wake_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _efficiencyPercentMeta = const VerificationMeta(
    'efficiencyPercent',
  );
  @override
  late final GeneratedColumn<int> efficiencyPercent = GeneratedColumn<int>(
    'efficiency_percent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(85),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasStagesMeta = const VerificationMeta(
    'hasStages',
  );
  @override
  late final GeneratedColumn<bool> hasStages = GeneratedColumn<bool>(
    'has_stages',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_stages" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lightSleepMinutesMeta = const VerificationMeta(
    'lightSleepMinutes',
  );
  @override
  late final GeneratedColumn<int> lightSleepMinutes = GeneratedColumn<int>(
    'light_sleep_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deepSleepMinutesMeta = const VerificationMeta(
    'deepSleepMinutes',
  );
  @override
  late final GeneratedColumn<int> deepSleepMinutes = GeneratedColumn<int>(
    'deep_sleep_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remSleepMinutesMeta = const VerificationMeta(
    'remSleepMinutes',
  );
  @override
  late final GeneratedColumn<int> remSleepMinutes = GeneratedColumn<int>(
    'rem_sleep_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _awakeMinutesMeta = const VerificationMeta(
    'awakeMinutes',
  );
  @override
  late final GeneratedColumn<int> awakeMinutes = GeneratedColumn<int>(
    'awake_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    bedtime,
    wakeTime,
    durationMinutes,
    source,
    efficiencyPercent,
    notes,
    hasStages,
    lightSleepMinutes,
    deepSleepMinutes,
    remSleepMinutes,
    awakeMinutes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sleep_records_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SleepRecordsEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('bedtime')) {
      context.handle(
        _bedtimeMeta,
        bedtime.isAcceptableOrUnknown(data['bedtime']!, _bedtimeMeta),
      );
    } else if (isInserting) {
      context.missing(_bedtimeMeta);
    }
    if (data.containsKey('wake_time')) {
      context.handle(
        _wakeTimeMeta,
        wakeTime.isAcceptableOrUnknown(data['wake_time']!, _wakeTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_wakeTimeMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('efficiency_percent')) {
      context.handle(
        _efficiencyPercentMeta,
        efficiencyPercent.isAcceptableOrUnknown(
          data['efficiency_percent']!,
          _efficiencyPercentMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('has_stages')) {
      context.handle(
        _hasStagesMeta,
        hasStages.isAcceptableOrUnknown(data['has_stages']!, _hasStagesMeta),
      );
    }
    if (data.containsKey('light_sleep_minutes')) {
      context.handle(
        _lightSleepMinutesMeta,
        lightSleepMinutes.isAcceptableOrUnknown(
          data['light_sleep_minutes']!,
          _lightSleepMinutesMeta,
        ),
      );
    }
    if (data.containsKey('deep_sleep_minutes')) {
      context.handle(
        _deepSleepMinutesMeta,
        deepSleepMinutes.isAcceptableOrUnknown(
          data['deep_sleep_minutes']!,
          _deepSleepMinutesMeta,
        ),
      );
    }
    if (data.containsKey('rem_sleep_minutes')) {
      context.handle(
        _remSleepMinutesMeta,
        remSleepMinutes.isAcceptableOrUnknown(
          data['rem_sleep_minutes']!,
          _remSleepMinutesMeta,
        ),
      );
    }
    if (data.containsKey('awake_minutes')) {
      context.handle(
        _awakeMinutesMeta,
        awakeMinutes.isAcceptableOrUnknown(
          data['awake_minutes']!,
          _awakeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SleepRecordsEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SleepRecordsEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      bedtime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}bedtime'],
      )!,
      wakeTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}wake_time'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      efficiencyPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}efficiency_percent'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      hasStages: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_stages'],
      )!,
      lightSleepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}light_sleep_minutes'],
      ),
      deepSleepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deep_sleep_minutes'],
      ),
      remSleepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rem_sleep_minutes'],
      ),
      awakeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}awake_minutes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SleepRecordsEntriesTable createAlias(String alias) {
    return $SleepRecordsEntriesTable(attachedDatabase, alias);
  }
}

class SleepRecordsEntry extends DataClass
    implements Insertable<SleepRecordsEntry> {
  /// Unique identifier (UUID or timestamp string)
  final String id;

  /// Reference date representing the wake-up calendar morning ("YYYY-MM-DD")
  final String date;

  /// Precise bedtime timestamp (e.g. 2026-11-06 23:15:00)
  final DateTime bedtime;

  /// Precise wake-up timestamp (e.g. 2026-11-07 07:30:00)
  final DateTime wakeTime;

  /// Total sleep duration in minutes
  final int durationMinutes;

  /// Data origin: 'manual', 'health_connect', 'estimated'
  final String source;

  /// Optional sleep efficiency percentage (0-100%)
  final int efficiencyPercent;

  /// Optional personal notes or dream tags
  final String? notes;

  /// Sleep stage breakdown - ONLY populated when genuinely provided by Health Connect or wearable.
  /// Never fabricated.
  final bool hasStages;
  final int? lightSleepMinutes;
  final int? deepSleepMinutes;
  final int? remSleepMinutes;
  final int? awakeMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SleepRecordsEntry({
    required this.id,
    required this.date,
    required this.bedtime,
    required this.wakeTime,
    required this.durationMinutes,
    required this.source,
    required this.efficiencyPercent,
    this.notes,
    required this.hasStages,
    this.lightSleepMinutes,
    this.deepSleepMinutes,
    this.remSleepMinutes,
    this.awakeMinutes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    map['bedtime'] = Variable<DateTime>(bedtime);
    map['wake_time'] = Variable<DateTime>(wakeTime);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['source'] = Variable<String>(source);
    map['efficiency_percent'] = Variable<int>(efficiencyPercent);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['has_stages'] = Variable<bool>(hasStages);
    if (!nullToAbsent || lightSleepMinutes != null) {
      map['light_sleep_minutes'] = Variable<int>(lightSleepMinutes);
    }
    if (!nullToAbsent || deepSleepMinutes != null) {
      map['deep_sleep_minutes'] = Variable<int>(deepSleepMinutes);
    }
    if (!nullToAbsent || remSleepMinutes != null) {
      map['rem_sleep_minutes'] = Variable<int>(remSleepMinutes);
    }
    if (!nullToAbsent || awakeMinutes != null) {
      map['awake_minutes'] = Variable<int>(awakeMinutes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SleepRecordsEntriesCompanion toCompanion(bool nullToAbsent) {
    return SleepRecordsEntriesCompanion(
      id: Value(id),
      date: Value(date),
      bedtime: Value(bedtime),
      wakeTime: Value(wakeTime),
      durationMinutes: Value(durationMinutes),
      source: Value(source),
      efficiencyPercent: Value(efficiencyPercent),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      hasStages: Value(hasStages),
      lightSleepMinutes: lightSleepMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(lightSleepMinutes),
      deepSleepMinutes: deepSleepMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(deepSleepMinutes),
      remSleepMinutes: remSleepMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(remSleepMinutes),
      awakeMinutes: awakeMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(awakeMinutes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SleepRecordsEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SleepRecordsEntry(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      bedtime: serializer.fromJson<DateTime>(json['bedtime']),
      wakeTime: serializer.fromJson<DateTime>(json['wakeTime']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      source: serializer.fromJson<String>(json['source']),
      efficiencyPercent: serializer.fromJson<int>(json['efficiencyPercent']),
      notes: serializer.fromJson<String?>(json['notes']),
      hasStages: serializer.fromJson<bool>(json['hasStages']),
      lightSleepMinutes: serializer.fromJson<int?>(json['lightSleepMinutes']),
      deepSleepMinutes: serializer.fromJson<int?>(json['deepSleepMinutes']),
      remSleepMinutes: serializer.fromJson<int?>(json['remSleepMinutes']),
      awakeMinutes: serializer.fromJson<int?>(json['awakeMinutes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'bedtime': serializer.toJson<DateTime>(bedtime),
      'wakeTime': serializer.toJson<DateTime>(wakeTime),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'source': serializer.toJson<String>(source),
      'efficiencyPercent': serializer.toJson<int>(efficiencyPercent),
      'notes': serializer.toJson<String?>(notes),
      'hasStages': serializer.toJson<bool>(hasStages),
      'lightSleepMinutes': serializer.toJson<int?>(lightSleepMinutes),
      'deepSleepMinutes': serializer.toJson<int?>(deepSleepMinutes),
      'remSleepMinutes': serializer.toJson<int?>(remSleepMinutes),
      'awakeMinutes': serializer.toJson<int?>(awakeMinutes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SleepRecordsEntry copyWith({
    String? id,
    String? date,
    DateTime? bedtime,
    DateTime? wakeTime,
    int? durationMinutes,
    String? source,
    int? efficiencyPercent,
    Value<String?> notes = const Value.absent(),
    bool? hasStages,
    Value<int?> lightSleepMinutes = const Value.absent(),
    Value<int?> deepSleepMinutes = const Value.absent(),
    Value<int?> remSleepMinutes = const Value.absent(),
    Value<int?> awakeMinutes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SleepRecordsEntry(
    id: id ?? this.id,
    date: date ?? this.date,
    bedtime: bedtime ?? this.bedtime,
    wakeTime: wakeTime ?? this.wakeTime,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    source: source ?? this.source,
    efficiencyPercent: efficiencyPercent ?? this.efficiencyPercent,
    notes: notes.present ? notes.value : this.notes,
    hasStages: hasStages ?? this.hasStages,
    lightSleepMinutes: lightSleepMinutes.present
        ? lightSleepMinutes.value
        : this.lightSleepMinutes,
    deepSleepMinutes: deepSleepMinutes.present
        ? deepSleepMinutes.value
        : this.deepSleepMinutes,
    remSleepMinutes: remSleepMinutes.present
        ? remSleepMinutes.value
        : this.remSleepMinutes,
    awakeMinutes: awakeMinutes.present ? awakeMinutes.value : this.awakeMinutes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SleepRecordsEntry copyWithCompanion(SleepRecordsEntriesCompanion data) {
    return SleepRecordsEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      bedtime: data.bedtime.present ? data.bedtime.value : this.bedtime,
      wakeTime: data.wakeTime.present ? data.wakeTime.value : this.wakeTime,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      source: data.source.present ? data.source.value : this.source,
      efficiencyPercent: data.efficiencyPercent.present
          ? data.efficiencyPercent.value
          : this.efficiencyPercent,
      notes: data.notes.present ? data.notes.value : this.notes,
      hasStages: data.hasStages.present ? data.hasStages.value : this.hasStages,
      lightSleepMinutes: data.lightSleepMinutes.present
          ? data.lightSleepMinutes.value
          : this.lightSleepMinutes,
      deepSleepMinutes: data.deepSleepMinutes.present
          ? data.deepSleepMinutes.value
          : this.deepSleepMinutes,
      remSleepMinutes: data.remSleepMinutes.present
          ? data.remSleepMinutes.value
          : this.remSleepMinutes,
      awakeMinutes: data.awakeMinutes.present
          ? data.awakeMinutes.value
          : this.awakeMinutes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SleepRecordsEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('bedtime: $bedtime, ')
          ..write('wakeTime: $wakeTime, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('source: $source, ')
          ..write('efficiencyPercent: $efficiencyPercent, ')
          ..write('notes: $notes, ')
          ..write('hasStages: $hasStages, ')
          ..write('lightSleepMinutes: $lightSleepMinutes, ')
          ..write('deepSleepMinutes: $deepSleepMinutes, ')
          ..write('remSleepMinutes: $remSleepMinutes, ')
          ..write('awakeMinutes: $awakeMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    bedtime,
    wakeTime,
    durationMinutes,
    source,
    efficiencyPercent,
    notes,
    hasStages,
    lightSleepMinutes,
    deepSleepMinutes,
    remSleepMinutes,
    awakeMinutes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SleepRecordsEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.bedtime == this.bedtime &&
          other.wakeTime == this.wakeTime &&
          other.durationMinutes == this.durationMinutes &&
          other.source == this.source &&
          other.efficiencyPercent == this.efficiencyPercent &&
          other.notes == this.notes &&
          other.hasStages == this.hasStages &&
          other.lightSleepMinutes == this.lightSleepMinutes &&
          other.deepSleepMinutes == this.deepSleepMinutes &&
          other.remSleepMinutes == this.remSleepMinutes &&
          other.awakeMinutes == this.awakeMinutes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SleepRecordsEntriesCompanion extends UpdateCompanion<SleepRecordsEntry> {
  final Value<String> id;
  final Value<String> date;
  final Value<DateTime> bedtime;
  final Value<DateTime> wakeTime;
  final Value<int> durationMinutes;
  final Value<String> source;
  final Value<int> efficiencyPercent;
  final Value<String?> notes;
  final Value<bool> hasStages;
  final Value<int?> lightSleepMinutes;
  final Value<int?> deepSleepMinutes;
  final Value<int?> remSleepMinutes;
  final Value<int?> awakeMinutes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SleepRecordsEntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.bedtime = const Value.absent(),
    this.wakeTime = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.source = const Value.absent(),
    this.efficiencyPercent = const Value.absent(),
    this.notes = const Value.absent(),
    this.hasStages = const Value.absent(),
    this.lightSleepMinutes = const Value.absent(),
    this.deepSleepMinutes = const Value.absent(),
    this.remSleepMinutes = const Value.absent(),
    this.awakeMinutes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SleepRecordsEntriesCompanion.insert({
    required String id,
    required String date,
    required DateTime bedtime,
    required DateTime wakeTime,
    required int durationMinutes,
    this.source = const Value.absent(),
    this.efficiencyPercent = const Value.absent(),
    this.notes = const Value.absent(),
    this.hasStages = const Value.absent(),
    this.lightSleepMinutes = const Value.absent(),
    this.deepSleepMinutes = const Value.absent(),
    this.remSleepMinutes = const Value.absent(),
    this.awakeMinutes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       bedtime = Value(bedtime),
       wakeTime = Value(wakeTime),
       durationMinutes = Value(durationMinutes);
  static Insertable<SleepRecordsEntry> custom({
    Expression<String>? id,
    Expression<String>? date,
    Expression<DateTime>? bedtime,
    Expression<DateTime>? wakeTime,
    Expression<int>? durationMinutes,
    Expression<String>? source,
    Expression<int>? efficiencyPercent,
    Expression<String>? notes,
    Expression<bool>? hasStages,
    Expression<int>? lightSleepMinutes,
    Expression<int>? deepSleepMinutes,
    Expression<int>? remSleepMinutes,
    Expression<int>? awakeMinutes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (bedtime != null) 'bedtime': bedtime,
      if (wakeTime != null) 'wake_time': wakeTime,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (source != null) 'source': source,
      if (efficiencyPercent != null) 'efficiency_percent': efficiencyPercent,
      if (notes != null) 'notes': notes,
      if (hasStages != null) 'has_stages': hasStages,
      if (lightSleepMinutes != null) 'light_sleep_minutes': lightSleepMinutes,
      if (deepSleepMinutes != null) 'deep_sleep_minutes': deepSleepMinutes,
      if (remSleepMinutes != null) 'rem_sleep_minutes': remSleepMinutes,
      if (awakeMinutes != null) 'awake_minutes': awakeMinutes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SleepRecordsEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? date,
    Value<DateTime>? bedtime,
    Value<DateTime>? wakeTime,
    Value<int>? durationMinutes,
    Value<String>? source,
    Value<int>? efficiencyPercent,
    Value<String?>? notes,
    Value<bool>? hasStages,
    Value<int?>? lightSleepMinutes,
    Value<int?>? deepSleepMinutes,
    Value<int?>? remSleepMinutes,
    Value<int?>? awakeMinutes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SleepRecordsEntriesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      bedtime: bedtime ?? this.bedtime,
      wakeTime: wakeTime ?? this.wakeTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      source: source ?? this.source,
      efficiencyPercent: efficiencyPercent ?? this.efficiencyPercent,
      notes: notes ?? this.notes,
      hasStages: hasStages ?? this.hasStages,
      lightSleepMinutes: lightSleepMinutes ?? this.lightSleepMinutes,
      deepSleepMinutes: deepSleepMinutes ?? this.deepSleepMinutes,
      remSleepMinutes: remSleepMinutes ?? this.remSleepMinutes,
      awakeMinutes: awakeMinutes ?? this.awakeMinutes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (bedtime.present) {
      map['bedtime'] = Variable<DateTime>(bedtime.value);
    }
    if (wakeTime.present) {
      map['wake_time'] = Variable<DateTime>(wakeTime.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (efficiencyPercent.present) {
      map['efficiency_percent'] = Variable<int>(efficiencyPercent.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (hasStages.present) {
      map['has_stages'] = Variable<bool>(hasStages.value);
    }
    if (lightSleepMinutes.present) {
      map['light_sleep_minutes'] = Variable<int>(lightSleepMinutes.value);
    }
    if (deepSleepMinutes.present) {
      map['deep_sleep_minutes'] = Variable<int>(deepSleepMinutes.value);
    }
    if (remSleepMinutes.present) {
      map['rem_sleep_minutes'] = Variable<int>(remSleepMinutes.value);
    }
    if (awakeMinutes.present) {
      map['awake_minutes'] = Variable<int>(awakeMinutes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SleepRecordsEntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('bedtime: $bedtime, ')
          ..write('wakeTime: $wakeTime, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('source: $source, ')
          ..write('efficiencyPercent: $efficiencyPercent, ')
          ..write('notes: $notes, ')
          ..write('hasStages: $hasStages, ')
          ..write('lightSleepMinutes: $lightSleepMinutes, ')
          ..write('deepSleepMinutes: $deepSleepMinutes, ')
          ..write('remSleepMinutes: $remSleepMinutes, ')
          ..write('awakeMinutes: $awakeMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeeklyReportsEntriesTable extends WeeklyReportsEntries
    with TableInfo<$WeeklyReportsEntriesTable, WeeklyReportsEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyReportsEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekNumberMeta = const VerificationMeta(
    'weekNumber',
  );
  @override
  late final GeneratedColumn<int> weekNumber = GeneratedColumn<int>(
    'week_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
    'generated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalStepsMeta = const VerificationMeta(
    'totalSteps',
  );
  @override
  late final GeneratedColumn<int> totalSteps = GeneratedColumn<int>(
    'total_steps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalDistanceKmMeta = const VerificationMeta(
    'totalDistanceKm',
  );
  @override
  late final GeneratedColumn<double> totalDistanceKm = GeneratedColumn<double>(
    'total_distance_km',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCaloriesMeta = const VerificationMeta(
    'totalCalories',
  );
  @override
  late final GeneratedColumn<int> totalCalories = GeneratedColumn<int>(
    'total_calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalActiveMinutesMeta =
      const VerificationMeta('totalActiveMinutes');
  @override
  late final GeneratedColumn<int> totalActiveMinutes = GeneratedColumn<int>(
    'total_active_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalSleepMinutesMeta = const VerificationMeta(
    'totalSleepMinutes',
  );
  @override
  late final GeneratedColumn<int> totalSleepMinutes = GeneratedColumn<int>(
    'total_sleep_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avgDailyStepsMeta = const VerificationMeta(
    'avgDailySteps',
  );
  @override
  late final GeneratedColumn<int> avgDailySteps = GeneratedColumn<int>(
    'avg_daily_steps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avgDailyDistanceKmMeta =
      const VerificationMeta('avgDailyDistanceKm');
  @override
  late final GeneratedColumn<double> avgDailyDistanceKm =
      GeneratedColumn<double>(
        'avg_daily_distance_km',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _avgDailyCaloriesMeta = const VerificationMeta(
    'avgDailyCalories',
  );
  @override
  late final GeneratedColumn<int> avgDailyCalories = GeneratedColumn<int>(
    'avg_daily_calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avgDailySleepMinutesMeta =
      const VerificationMeta('avgDailySleepMinutes');
  @override
  late final GeneratedColumn<int> avgDailySleepMinutes = GeneratedColumn<int>(
    'avg_daily_sleep_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalMetDaysMeta = const VerificationMeta(
    'goalMetDays',
  );
  @override
  late final GeneratedColumn<int> goalMetDays = GeneratedColumn<int>(
    'goal_met_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mostActiveDayDateMeta = const VerificationMeta(
    'mostActiveDayDate',
  );
  @override
  late final GeneratedColumn<String> mostActiveDayDate =
      GeneratedColumn<String>(
        'most_active_day_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _mostActiveDayStepsMeta =
      const VerificationMeta('mostActiveDaySteps');
  @override
  late final GeneratedColumn<int> mostActiveDaySteps = GeneratedColumn<int>(
    'most_active_day_steps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedDaysCountMeta = const VerificationMeta(
    'recordedDaysCount',
  );
  @override
  late final GeneratedColumn<int> recordedDaysCount = GeneratedColumn<int>(
    'recorded_days_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepsChangePercentMeta =
      const VerificationMeta('stepsChangePercent');
  @override
  late final GeneratedColumn<double> stepsChangePercent =
      GeneratedColumn<double>(
        'steps_change_percent',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sleepChangePercentMeta =
      const VerificationMeta('sleepChangePercent');
  @override
  late final GeneratedColumn<double> sleepChangePercent =
      GeneratedColumn<double>(
        'sleep_change_percent',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _caloriesChangePercentMeta =
      const VerificationMeta('caloriesChangePercent');
  @override
  late final GeneratedColumn<double> caloriesChangePercent =
      GeneratedColumn<double>(
        'calories_change_percent',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _distanceChangePercentMeta =
      const VerificationMeta('distanceChangePercent');
  @override
  late final GeneratedColumn<double> distanceChangePercent =
      GeneratedColumn<double>(
        'distance_change_percent',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _dailyBreakdownJsonMeta =
      const VerificationMeta('dailyBreakdownJson');
  @override
  late final GeneratedColumn<String> dailyBreakdownJson =
      GeneratedColumn<String>(
        'daily_breakdown_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startDate,
    endDate,
    year,
    weekNumber,
    generatedAt,
    totalSteps,
    totalDistanceKm,
    totalCalories,
    totalActiveMinutes,
    totalSleepMinutes,
    avgDailySteps,
    avgDailyDistanceKm,
    avgDailyCalories,
    avgDailySleepMinutes,
    goalMetDays,
    mostActiveDayDate,
    mostActiveDaySteps,
    recordedDaysCount,
    stepsChangePercent,
    sleepChangePercent,
    caloriesChangePercent,
    distanceChangePercent,
    dailyBreakdownJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_reports_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyReportsEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('week_number')) {
      context.handle(
        _weekNumberMeta,
        weekNumber.isAcceptableOrUnknown(data['week_number']!, _weekNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_weekNumberMeta);
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    if (data.containsKey('total_steps')) {
      context.handle(
        _totalStepsMeta,
        totalSteps.isAcceptableOrUnknown(data['total_steps']!, _totalStepsMeta),
      );
    } else if (isInserting) {
      context.missing(_totalStepsMeta);
    }
    if (data.containsKey('total_distance_km')) {
      context.handle(
        _totalDistanceKmMeta,
        totalDistanceKm.isAcceptableOrUnknown(
          data['total_distance_km']!,
          _totalDistanceKmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalDistanceKmMeta);
    }
    if (data.containsKey('total_calories')) {
      context.handle(
        _totalCaloriesMeta,
        totalCalories.isAcceptableOrUnknown(
          data['total_calories']!,
          _totalCaloriesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalCaloriesMeta);
    }
    if (data.containsKey('total_active_minutes')) {
      context.handle(
        _totalActiveMinutesMeta,
        totalActiveMinutes.isAcceptableOrUnknown(
          data['total_active_minutes']!,
          _totalActiveMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalActiveMinutesMeta);
    }
    if (data.containsKey('total_sleep_minutes')) {
      context.handle(
        _totalSleepMinutesMeta,
        totalSleepMinutes.isAcceptableOrUnknown(
          data['total_sleep_minutes']!,
          _totalSleepMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalSleepMinutesMeta);
    }
    if (data.containsKey('avg_daily_steps')) {
      context.handle(
        _avgDailyStepsMeta,
        avgDailySteps.isAcceptableOrUnknown(
          data['avg_daily_steps']!,
          _avgDailyStepsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_avgDailyStepsMeta);
    }
    if (data.containsKey('avg_daily_distance_km')) {
      context.handle(
        _avgDailyDistanceKmMeta,
        avgDailyDistanceKm.isAcceptableOrUnknown(
          data['avg_daily_distance_km']!,
          _avgDailyDistanceKmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_avgDailyDistanceKmMeta);
    }
    if (data.containsKey('avg_daily_calories')) {
      context.handle(
        _avgDailyCaloriesMeta,
        avgDailyCalories.isAcceptableOrUnknown(
          data['avg_daily_calories']!,
          _avgDailyCaloriesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_avgDailyCaloriesMeta);
    }
    if (data.containsKey('avg_daily_sleep_minutes')) {
      context.handle(
        _avgDailySleepMinutesMeta,
        avgDailySleepMinutes.isAcceptableOrUnknown(
          data['avg_daily_sleep_minutes']!,
          _avgDailySleepMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_avgDailySleepMinutesMeta);
    }
    if (data.containsKey('goal_met_days')) {
      context.handle(
        _goalMetDaysMeta,
        goalMetDays.isAcceptableOrUnknown(
          data['goal_met_days']!,
          _goalMetDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_goalMetDaysMeta);
    }
    if (data.containsKey('most_active_day_date')) {
      context.handle(
        _mostActiveDayDateMeta,
        mostActiveDayDate.isAcceptableOrUnknown(
          data['most_active_day_date']!,
          _mostActiveDayDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mostActiveDayDateMeta);
    }
    if (data.containsKey('most_active_day_steps')) {
      context.handle(
        _mostActiveDayStepsMeta,
        mostActiveDaySteps.isAcceptableOrUnknown(
          data['most_active_day_steps']!,
          _mostActiveDayStepsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mostActiveDayStepsMeta);
    }
    if (data.containsKey('recorded_days_count')) {
      context.handle(
        _recordedDaysCountMeta,
        recordedDaysCount.isAcceptableOrUnknown(
          data['recorded_days_count']!,
          _recordedDaysCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordedDaysCountMeta);
    }
    if (data.containsKey('steps_change_percent')) {
      context.handle(
        _stepsChangePercentMeta,
        stepsChangePercent.isAcceptableOrUnknown(
          data['steps_change_percent']!,
          _stepsChangePercentMeta,
        ),
      );
    }
    if (data.containsKey('sleep_change_percent')) {
      context.handle(
        _sleepChangePercentMeta,
        sleepChangePercent.isAcceptableOrUnknown(
          data['sleep_change_percent']!,
          _sleepChangePercentMeta,
        ),
      );
    }
    if (data.containsKey('calories_change_percent')) {
      context.handle(
        _caloriesChangePercentMeta,
        caloriesChangePercent.isAcceptableOrUnknown(
          data['calories_change_percent']!,
          _caloriesChangePercentMeta,
        ),
      );
    }
    if (data.containsKey('distance_change_percent')) {
      context.handle(
        _distanceChangePercentMeta,
        distanceChangePercent.isAcceptableOrUnknown(
          data['distance_change_percent']!,
          _distanceChangePercentMeta,
        ),
      );
    }
    if (data.containsKey('daily_breakdown_json')) {
      context.handle(
        _dailyBreakdownJsonMeta,
        dailyBreakdownJson.isAcceptableOrUnknown(
          data['daily_breakdown_json']!,
          _dailyBreakdownJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyBreakdownJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeeklyReportsEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyReportsEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      weekNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_number'],
      )!,
      generatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}generated_at'],
      )!,
      totalSteps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_steps'],
      )!,
      totalDistanceKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_distance_km'],
      )!,
      totalCalories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_calories'],
      )!,
      totalActiveMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_active_minutes'],
      )!,
      totalSleepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_sleep_minutes'],
      )!,
      avgDailySteps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}avg_daily_steps'],
      )!,
      avgDailyDistanceKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_daily_distance_km'],
      )!,
      avgDailyCalories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}avg_daily_calories'],
      )!,
      avgDailySleepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}avg_daily_sleep_minutes'],
      )!,
      goalMetDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_met_days'],
      )!,
      mostActiveDayDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}most_active_day_date'],
      )!,
      mostActiveDaySteps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}most_active_day_steps'],
      )!,
      recordedDaysCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recorded_days_count'],
      )!,
      stepsChangePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}steps_change_percent'],
      ),
      sleepChangePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sleep_change_percent'],
      ),
      caloriesChangePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories_change_percent'],
      ),
      distanceChangePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_change_percent'],
      ),
      dailyBreakdownJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}daily_breakdown_json'],
      )!,
    );
  }

  @override
  $WeeklyReportsEntriesTable createAlias(String alias) {
    return $WeeklyReportsEntriesTable(attachedDatabase, alias);
  }
}

class WeeklyReportsEntry extends DataClass
    implements Insertable<WeeklyReportsEntry> {
  /// Unique identifier: e.g. 'report_2026_W44' or 'report_2026-10-26_2026-11-01'
  final String id;

  /// Start date of the week (Monday, formatted as yyyy-MM-dd)
  final String startDate;

  /// End date of the week (Sunday, formatted as yyyy-MM-dd)
  final String endDate;

  /// Calendar year of the reporting week
  final int year;

  /// ISO 8601 week number (1 - 53)
  final int weekNumber;

  /// Timestamp when the report was generated
  final DateTime generatedAt;

  /// Total steps recorded across the 7-day period
  final int totalSteps;

  /// Total distance in kilometers
  final double totalDistanceKm;

  /// Total calories burned (kcal)
  final int totalCalories;

  /// Total active duration in minutes
  final int totalActiveMinutes;

  /// Total sleep duration in minutes
  final int totalSleepMinutes;

  /// Daily average step count (totalSteps / 7)
  final int avgDailySteps;

  /// Daily average distance in km
  final double avgDailyDistanceKm;

  /// Daily average calories burned
  final int avgDailyCalories;

  /// Daily average sleep in minutes
  final int avgDailySleepMinutes;

  /// Number of days (0 - 7) where the user met their daily step goal
  final int goalMetDays;

  /// Calendar date of the most active day (yyyy-MM-dd)
  final String mostActiveDayDate;

  /// Step count achieved on the most active day
  final int mostActiveDaySteps;

  /// Number of days during the week with recorded activity (0 - 7)
  final int recordedDaysCount;

  /// Percentage change in total steps compared to preceding week (nullable)
  final double? stepsChangePercent;

  /// Percentage change in total sleep compared to preceding week (nullable)
  final double? sleepChangePercent;

  /// Percentage change in calories burned compared to preceding week (nullable)
  final double? caloriesChangePercent;

  /// Percentage change in distance compared to preceding week (nullable)
  final double? distanceChangePercent;

  /// JSON-encoded array containing the 7-day daily breakdown data
  final String dailyBreakdownJson;
  const WeeklyReportsEntry({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.year,
    required this.weekNumber,
    required this.generatedAt,
    required this.totalSteps,
    required this.totalDistanceKm,
    required this.totalCalories,
    required this.totalActiveMinutes,
    required this.totalSleepMinutes,
    required this.avgDailySteps,
    required this.avgDailyDistanceKm,
    required this.avgDailyCalories,
    required this.avgDailySleepMinutes,
    required this.goalMetDays,
    required this.mostActiveDayDate,
    required this.mostActiveDaySteps,
    required this.recordedDaysCount,
    this.stepsChangePercent,
    this.sleepChangePercent,
    this.caloriesChangePercent,
    this.distanceChangePercent,
    required this.dailyBreakdownJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['start_date'] = Variable<String>(startDate);
    map['end_date'] = Variable<String>(endDate);
    map['year'] = Variable<int>(year);
    map['week_number'] = Variable<int>(weekNumber);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    map['total_steps'] = Variable<int>(totalSteps);
    map['total_distance_km'] = Variable<double>(totalDistanceKm);
    map['total_calories'] = Variable<int>(totalCalories);
    map['total_active_minutes'] = Variable<int>(totalActiveMinutes);
    map['total_sleep_minutes'] = Variable<int>(totalSleepMinutes);
    map['avg_daily_steps'] = Variable<int>(avgDailySteps);
    map['avg_daily_distance_km'] = Variable<double>(avgDailyDistanceKm);
    map['avg_daily_calories'] = Variable<int>(avgDailyCalories);
    map['avg_daily_sleep_minutes'] = Variable<int>(avgDailySleepMinutes);
    map['goal_met_days'] = Variable<int>(goalMetDays);
    map['most_active_day_date'] = Variable<String>(mostActiveDayDate);
    map['most_active_day_steps'] = Variable<int>(mostActiveDaySteps);
    map['recorded_days_count'] = Variable<int>(recordedDaysCount);
    if (!nullToAbsent || stepsChangePercent != null) {
      map['steps_change_percent'] = Variable<double>(stepsChangePercent);
    }
    if (!nullToAbsent || sleepChangePercent != null) {
      map['sleep_change_percent'] = Variable<double>(sleepChangePercent);
    }
    if (!nullToAbsent || caloriesChangePercent != null) {
      map['calories_change_percent'] = Variable<double>(caloriesChangePercent);
    }
    if (!nullToAbsent || distanceChangePercent != null) {
      map['distance_change_percent'] = Variable<double>(distanceChangePercent);
    }
    map['daily_breakdown_json'] = Variable<String>(dailyBreakdownJson);
    return map;
  }

  WeeklyReportsEntriesCompanion toCompanion(bool nullToAbsent) {
    return WeeklyReportsEntriesCompanion(
      id: Value(id),
      startDate: Value(startDate),
      endDate: Value(endDate),
      year: Value(year),
      weekNumber: Value(weekNumber),
      generatedAt: Value(generatedAt),
      totalSteps: Value(totalSteps),
      totalDistanceKm: Value(totalDistanceKm),
      totalCalories: Value(totalCalories),
      totalActiveMinutes: Value(totalActiveMinutes),
      totalSleepMinutes: Value(totalSleepMinutes),
      avgDailySteps: Value(avgDailySteps),
      avgDailyDistanceKm: Value(avgDailyDistanceKm),
      avgDailyCalories: Value(avgDailyCalories),
      avgDailySleepMinutes: Value(avgDailySleepMinutes),
      goalMetDays: Value(goalMetDays),
      mostActiveDayDate: Value(mostActiveDayDate),
      mostActiveDaySteps: Value(mostActiveDaySteps),
      recordedDaysCount: Value(recordedDaysCount),
      stepsChangePercent: stepsChangePercent == null && nullToAbsent
          ? const Value.absent()
          : Value(stepsChangePercent),
      sleepChangePercent: sleepChangePercent == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepChangePercent),
      caloriesChangePercent: caloriesChangePercent == null && nullToAbsent
          ? const Value.absent()
          : Value(caloriesChangePercent),
      distanceChangePercent: distanceChangePercent == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceChangePercent),
      dailyBreakdownJson: Value(dailyBreakdownJson),
    );
  }

  factory WeeklyReportsEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyReportsEntry(
      id: serializer.fromJson<String>(json['id']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String>(json['endDate']),
      year: serializer.fromJson<int>(json['year']),
      weekNumber: serializer.fromJson<int>(json['weekNumber']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      totalSteps: serializer.fromJson<int>(json['totalSteps']),
      totalDistanceKm: serializer.fromJson<double>(json['totalDistanceKm']),
      totalCalories: serializer.fromJson<int>(json['totalCalories']),
      totalActiveMinutes: serializer.fromJson<int>(json['totalActiveMinutes']),
      totalSleepMinutes: serializer.fromJson<int>(json['totalSleepMinutes']),
      avgDailySteps: serializer.fromJson<int>(json['avgDailySteps']),
      avgDailyDistanceKm: serializer.fromJson<double>(
        json['avgDailyDistanceKm'],
      ),
      avgDailyCalories: serializer.fromJson<int>(json['avgDailyCalories']),
      avgDailySleepMinutes: serializer.fromJson<int>(
        json['avgDailySleepMinutes'],
      ),
      goalMetDays: serializer.fromJson<int>(json['goalMetDays']),
      mostActiveDayDate: serializer.fromJson<String>(json['mostActiveDayDate']),
      mostActiveDaySteps: serializer.fromJson<int>(json['mostActiveDaySteps']),
      recordedDaysCount: serializer.fromJson<int>(json['recordedDaysCount']),
      stepsChangePercent: serializer.fromJson<double?>(
        json['stepsChangePercent'],
      ),
      sleepChangePercent: serializer.fromJson<double?>(
        json['sleepChangePercent'],
      ),
      caloriesChangePercent: serializer.fromJson<double?>(
        json['caloriesChangePercent'],
      ),
      distanceChangePercent: serializer.fromJson<double?>(
        json['distanceChangePercent'],
      ),
      dailyBreakdownJson: serializer.fromJson<String>(
        json['dailyBreakdownJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String>(endDate),
      'year': serializer.toJson<int>(year),
      'weekNumber': serializer.toJson<int>(weekNumber),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'totalSteps': serializer.toJson<int>(totalSteps),
      'totalDistanceKm': serializer.toJson<double>(totalDistanceKm),
      'totalCalories': serializer.toJson<int>(totalCalories),
      'totalActiveMinutes': serializer.toJson<int>(totalActiveMinutes),
      'totalSleepMinutes': serializer.toJson<int>(totalSleepMinutes),
      'avgDailySteps': serializer.toJson<int>(avgDailySteps),
      'avgDailyDistanceKm': serializer.toJson<double>(avgDailyDistanceKm),
      'avgDailyCalories': serializer.toJson<int>(avgDailyCalories),
      'avgDailySleepMinutes': serializer.toJson<int>(avgDailySleepMinutes),
      'goalMetDays': serializer.toJson<int>(goalMetDays),
      'mostActiveDayDate': serializer.toJson<String>(mostActiveDayDate),
      'mostActiveDaySteps': serializer.toJson<int>(mostActiveDaySteps),
      'recordedDaysCount': serializer.toJson<int>(recordedDaysCount),
      'stepsChangePercent': serializer.toJson<double?>(stepsChangePercent),
      'sleepChangePercent': serializer.toJson<double?>(sleepChangePercent),
      'caloriesChangePercent': serializer.toJson<double?>(
        caloriesChangePercent,
      ),
      'distanceChangePercent': serializer.toJson<double?>(
        distanceChangePercent,
      ),
      'dailyBreakdownJson': serializer.toJson<String>(dailyBreakdownJson),
    };
  }

  WeeklyReportsEntry copyWith({
    String? id,
    String? startDate,
    String? endDate,
    int? year,
    int? weekNumber,
    DateTime? generatedAt,
    int? totalSteps,
    double? totalDistanceKm,
    int? totalCalories,
    int? totalActiveMinutes,
    int? totalSleepMinutes,
    int? avgDailySteps,
    double? avgDailyDistanceKm,
    int? avgDailyCalories,
    int? avgDailySleepMinutes,
    int? goalMetDays,
    String? mostActiveDayDate,
    int? mostActiveDaySteps,
    int? recordedDaysCount,
    Value<double?> stepsChangePercent = const Value.absent(),
    Value<double?> sleepChangePercent = const Value.absent(),
    Value<double?> caloriesChangePercent = const Value.absent(),
    Value<double?> distanceChangePercent = const Value.absent(),
    String? dailyBreakdownJson,
  }) => WeeklyReportsEntry(
    id: id ?? this.id,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    year: year ?? this.year,
    weekNumber: weekNumber ?? this.weekNumber,
    generatedAt: generatedAt ?? this.generatedAt,
    totalSteps: totalSteps ?? this.totalSteps,
    totalDistanceKm: totalDistanceKm ?? this.totalDistanceKm,
    totalCalories: totalCalories ?? this.totalCalories,
    totalActiveMinutes: totalActiveMinutes ?? this.totalActiveMinutes,
    totalSleepMinutes: totalSleepMinutes ?? this.totalSleepMinutes,
    avgDailySteps: avgDailySteps ?? this.avgDailySteps,
    avgDailyDistanceKm: avgDailyDistanceKm ?? this.avgDailyDistanceKm,
    avgDailyCalories: avgDailyCalories ?? this.avgDailyCalories,
    avgDailySleepMinutes: avgDailySleepMinutes ?? this.avgDailySleepMinutes,
    goalMetDays: goalMetDays ?? this.goalMetDays,
    mostActiveDayDate: mostActiveDayDate ?? this.mostActiveDayDate,
    mostActiveDaySteps: mostActiveDaySteps ?? this.mostActiveDaySteps,
    recordedDaysCount: recordedDaysCount ?? this.recordedDaysCount,
    stepsChangePercent: stepsChangePercent.present
        ? stepsChangePercent.value
        : this.stepsChangePercent,
    sleepChangePercent: sleepChangePercent.present
        ? sleepChangePercent.value
        : this.sleepChangePercent,
    caloriesChangePercent: caloriesChangePercent.present
        ? caloriesChangePercent.value
        : this.caloriesChangePercent,
    distanceChangePercent: distanceChangePercent.present
        ? distanceChangePercent.value
        : this.distanceChangePercent,
    dailyBreakdownJson: dailyBreakdownJson ?? this.dailyBreakdownJson,
  );
  WeeklyReportsEntry copyWithCompanion(WeeklyReportsEntriesCompanion data) {
    return WeeklyReportsEntry(
      id: data.id.present ? data.id.value : this.id,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      year: data.year.present ? data.year.value : this.year,
      weekNumber: data.weekNumber.present
          ? data.weekNumber.value
          : this.weekNumber,
      generatedAt: data.generatedAt.present
          ? data.generatedAt.value
          : this.generatedAt,
      totalSteps: data.totalSteps.present
          ? data.totalSteps.value
          : this.totalSteps,
      totalDistanceKm: data.totalDistanceKm.present
          ? data.totalDistanceKm.value
          : this.totalDistanceKm,
      totalCalories: data.totalCalories.present
          ? data.totalCalories.value
          : this.totalCalories,
      totalActiveMinutes: data.totalActiveMinutes.present
          ? data.totalActiveMinutes.value
          : this.totalActiveMinutes,
      totalSleepMinutes: data.totalSleepMinutes.present
          ? data.totalSleepMinutes.value
          : this.totalSleepMinutes,
      avgDailySteps: data.avgDailySteps.present
          ? data.avgDailySteps.value
          : this.avgDailySteps,
      avgDailyDistanceKm: data.avgDailyDistanceKm.present
          ? data.avgDailyDistanceKm.value
          : this.avgDailyDistanceKm,
      avgDailyCalories: data.avgDailyCalories.present
          ? data.avgDailyCalories.value
          : this.avgDailyCalories,
      avgDailySleepMinutes: data.avgDailySleepMinutes.present
          ? data.avgDailySleepMinutes.value
          : this.avgDailySleepMinutes,
      goalMetDays: data.goalMetDays.present
          ? data.goalMetDays.value
          : this.goalMetDays,
      mostActiveDayDate: data.mostActiveDayDate.present
          ? data.mostActiveDayDate.value
          : this.mostActiveDayDate,
      mostActiveDaySteps: data.mostActiveDaySteps.present
          ? data.mostActiveDaySteps.value
          : this.mostActiveDaySteps,
      recordedDaysCount: data.recordedDaysCount.present
          ? data.recordedDaysCount.value
          : this.recordedDaysCount,
      stepsChangePercent: data.stepsChangePercent.present
          ? data.stepsChangePercent.value
          : this.stepsChangePercent,
      sleepChangePercent: data.sleepChangePercent.present
          ? data.sleepChangePercent.value
          : this.sleepChangePercent,
      caloriesChangePercent: data.caloriesChangePercent.present
          ? data.caloriesChangePercent.value
          : this.caloriesChangePercent,
      distanceChangePercent: data.distanceChangePercent.present
          ? data.distanceChangePercent.value
          : this.distanceChangePercent,
      dailyBreakdownJson: data.dailyBreakdownJson.present
          ? data.dailyBreakdownJson.value
          : this.dailyBreakdownJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyReportsEntry(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('year: $year, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('totalSteps: $totalSteps, ')
          ..write('totalDistanceKm: $totalDistanceKm, ')
          ..write('totalCalories: $totalCalories, ')
          ..write('totalActiveMinutes: $totalActiveMinutes, ')
          ..write('totalSleepMinutes: $totalSleepMinutes, ')
          ..write('avgDailySteps: $avgDailySteps, ')
          ..write('avgDailyDistanceKm: $avgDailyDistanceKm, ')
          ..write('avgDailyCalories: $avgDailyCalories, ')
          ..write('avgDailySleepMinutes: $avgDailySleepMinutes, ')
          ..write('goalMetDays: $goalMetDays, ')
          ..write('mostActiveDayDate: $mostActiveDayDate, ')
          ..write('mostActiveDaySteps: $mostActiveDaySteps, ')
          ..write('recordedDaysCount: $recordedDaysCount, ')
          ..write('stepsChangePercent: $stepsChangePercent, ')
          ..write('sleepChangePercent: $sleepChangePercent, ')
          ..write('caloriesChangePercent: $caloriesChangePercent, ')
          ..write('distanceChangePercent: $distanceChangePercent, ')
          ..write('dailyBreakdownJson: $dailyBreakdownJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    startDate,
    endDate,
    year,
    weekNumber,
    generatedAt,
    totalSteps,
    totalDistanceKm,
    totalCalories,
    totalActiveMinutes,
    totalSleepMinutes,
    avgDailySteps,
    avgDailyDistanceKm,
    avgDailyCalories,
    avgDailySleepMinutes,
    goalMetDays,
    mostActiveDayDate,
    mostActiveDaySteps,
    recordedDaysCount,
    stepsChangePercent,
    sleepChangePercent,
    caloriesChangePercent,
    distanceChangePercent,
    dailyBreakdownJson,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyReportsEntry &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.year == this.year &&
          other.weekNumber == this.weekNumber &&
          other.generatedAt == this.generatedAt &&
          other.totalSteps == this.totalSteps &&
          other.totalDistanceKm == this.totalDistanceKm &&
          other.totalCalories == this.totalCalories &&
          other.totalActiveMinutes == this.totalActiveMinutes &&
          other.totalSleepMinutes == this.totalSleepMinutes &&
          other.avgDailySteps == this.avgDailySteps &&
          other.avgDailyDistanceKm == this.avgDailyDistanceKm &&
          other.avgDailyCalories == this.avgDailyCalories &&
          other.avgDailySleepMinutes == this.avgDailySleepMinutes &&
          other.goalMetDays == this.goalMetDays &&
          other.mostActiveDayDate == this.mostActiveDayDate &&
          other.mostActiveDaySteps == this.mostActiveDaySteps &&
          other.recordedDaysCount == this.recordedDaysCount &&
          other.stepsChangePercent == this.stepsChangePercent &&
          other.sleepChangePercent == this.sleepChangePercent &&
          other.caloriesChangePercent == this.caloriesChangePercent &&
          other.distanceChangePercent == this.distanceChangePercent &&
          other.dailyBreakdownJson == this.dailyBreakdownJson);
}

class WeeklyReportsEntriesCompanion
    extends UpdateCompanion<WeeklyReportsEntry> {
  final Value<String> id;
  final Value<String> startDate;
  final Value<String> endDate;
  final Value<int> year;
  final Value<int> weekNumber;
  final Value<DateTime> generatedAt;
  final Value<int> totalSteps;
  final Value<double> totalDistanceKm;
  final Value<int> totalCalories;
  final Value<int> totalActiveMinutes;
  final Value<int> totalSleepMinutes;
  final Value<int> avgDailySteps;
  final Value<double> avgDailyDistanceKm;
  final Value<int> avgDailyCalories;
  final Value<int> avgDailySleepMinutes;
  final Value<int> goalMetDays;
  final Value<String> mostActiveDayDate;
  final Value<int> mostActiveDaySteps;
  final Value<int> recordedDaysCount;
  final Value<double?> stepsChangePercent;
  final Value<double?> sleepChangePercent;
  final Value<double?> caloriesChangePercent;
  final Value<double?> distanceChangePercent;
  final Value<String> dailyBreakdownJson;
  final Value<int> rowid;
  const WeeklyReportsEntriesCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.year = const Value.absent(),
    this.weekNumber = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.totalSteps = const Value.absent(),
    this.totalDistanceKm = const Value.absent(),
    this.totalCalories = const Value.absent(),
    this.totalActiveMinutes = const Value.absent(),
    this.totalSleepMinutes = const Value.absent(),
    this.avgDailySteps = const Value.absent(),
    this.avgDailyDistanceKm = const Value.absent(),
    this.avgDailyCalories = const Value.absent(),
    this.avgDailySleepMinutes = const Value.absent(),
    this.goalMetDays = const Value.absent(),
    this.mostActiveDayDate = const Value.absent(),
    this.mostActiveDaySteps = const Value.absent(),
    this.recordedDaysCount = const Value.absent(),
    this.stepsChangePercent = const Value.absent(),
    this.sleepChangePercent = const Value.absent(),
    this.caloriesChangePercent = const Value.absent(),
    this.distanceChangePercent = const Value.absent(),
    this.dailyBreakdownJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeeklyReportsEntriesCompanion.insert({
    required String id,
    required String startDate,
    required String endDate,
    required int year,
    required int weekNumber,
    required DateTime generatedAt,
    required int totalSteps,
    required double totalDistanceKm,
    required int totalCalories,
    required int totalActiveMinutes,
    required int totalSleepMinutes,
    required int avgDailySteps,
    required double avgDailyDistanceKm,
    required int avgDailyCalories,
    required int avgDailySleepMinutes,
    required int goalMetDays,
    required String mostActiveDayDate,
    required int mostActiveDaySteps,
    required int recordedDaysCount,
    this.stepsChangePercent = const Value.absent(),
    this.sleepChangePercent = const Value.absent(),
    this.caloriesChangePercent = const Value.absent(),
    this.distanceChangePercent = const Value.absent(),
    required String dailyBreakdownJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startDate = Value(startDate),
       endDate = Value(endDate),
       year = Value(year),
       weekNumber = Value(weekNumber),
       generatedAt = Value(generatedAt),
       totalSteps = Value(totalSteps),
       totalDistanceKm = Value(totalDistanceKm),
       totalCalories = Value(totalCalories),
       totalActiveMinutes = Value(totalActiveMinutes),
       totalSleepMinutes = Value(totalSleepMinutes),
       avgDailySteps = Value(avgDailySteps),
       avgDailyDistanceKm = Value(avgDailyDistanceKm),
       avgDailyCalories = Value(avgDailyCalories),
       avgDailySleepMinutes = Value(avgDailySleepMinutes),
       goalMetDays = Value(goalMetDays),
       mostActiveDayDate = Value(mostActiveDayDate),
       mostActiveDaySteps = Value(mostActiveDaySteps),
       recordedDaysCount = Value(recordedDaysCount),
       dailyBreakdownJson = Value(dailyBreakdownJson);
  static Insertable<WeeklyReportsEntry> custom({
    Expression<String>? id,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<int>? year,
    Expression<int>? weekNumber,
    Expression<DateTime>? generatedAt,
    Expression<int>? totalSteps,
    Expression<double>? totalDistanceKm,
    Expression<int>? totalCalories,
    Expression<int>? totalActiveMinutes,
    Expression<int>? totalSleepMinutes,
    Expression<int>? avgDailySteps,
    Expression<double>? avgDailyDistanceKm,
    Expression<int>? avgDailyCalories,
    Expression<int>? avgDailySleepMinutes,
    Expression<int>? goalMetDays,
    Expression<String>? mostActiveDayDate,
    Expression<int>? mostActiveDaySteps,
    Expression<int>? recordedDaysCount,
    Expression<double>? stepsChangePercent,
    Expression<double>? sleepChangePercent,
    Expression<double>? caloriesChangePercent,
    Expression<double>? distanceChangePercent,
    Expression<String>? dailyBreakdownJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (year != null) 'year': year,
      if (weekNumber != null) 'week_number': weekNumber,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (totalSteps != null) 'total_steps': totalSteps,
      if (totalDistanceKm != null) 'total_distance_km': totalDistanceKm,
      if (totalCalories != null) 'total_calories': totalCalories,
      if (totalActiveMinutes != null)
        'total_active_minutes': totalActiveMinutes,
      if (totalSleepMinutes != null) 'total_sleep_minutes': totalSleepMinutes,
      if (avgDailySteps != null) 'avg_daily_steps': avgDailySteps,
      if (avgDailyDistanceKm != null)
        'avg_daily_distance_km': avgDailyDistanceKm,
      if (avgDailyCalories != null) 'avg_daily_calories': avgDailyCalories,
      if (avgDailySleepMinutes != null)
        'avg_daily_sleep_minutes': avgDailySleepMinutes,
      if (goalMetDays != null) 'goal_met_days': goalMetDays,
      if (mostActiveDayDate != null) 'most_active_day_date': mostActiveDayDate,
      if (mostActiveDaySteps != null)
        'most_active_day_steps': mostActiveDaySteps,
      if (recordedDaysCount != null) 'recorded_days_count': recordedDaysCount,
      if (stepsChangePercent != null)
        'steps_change_percent': stepsChangePercent,
      if (sleepChangePercent != null)
        'sleep_change_percent': sleepChangePercent,
      if (caloriesChangePercent != null)
        'calories_change_percent': caloriesChangePercent,
      if (distanceChangePercent != null)
        'distance_change_percent': distanceChangePercent,
      if (dailyBreakdownJson != null)
        'daily_breakdown_json': dailyBreakdownJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeeklyReportsEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? startDate,
    Value<String>? endDate,
    Value<int>? year,
    Value<int>? weekNumber,
    Value<DateTime>? generatedAt,
    Value<int>? totalSteps,
    Value<double>? totalDistanceKm,
    Value<int>? totalCalories,
    Value<int>? totalActiveMinutes,
    Value<int>? totalSleepMinutes,
    Value<int>? avgDailySteps,
    Value<double>? avgDailyDistanceKm,
    Value<int>? avgDailyCalories,
    Value<int>? avgDailySleepMinutes,
    Value<int>? goalMetDays,
    Value<String>? mostActiveDayDate,
    Value<int>? mostActiveDaySteps,
    Value<int>? recordedDaysCount,
    Value<double?>? stepsChangePercent,
    Value<double?>? sleepChangePercent,
    Value<double?>? caloriesChangePercent,
    Value<double?>? distanceChangePercent,
    Value<String>? dailyBreakdownJson,
    Value<int>? rowid,
  }) {
    return WeeklyReportsEntriesCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      year: year ?? this.year,
      weekNumber: weekNumber ?? this.weekNumber,
      generatedAt: generatedAt ?? this.generatedAt,
      totalSteps: totalSteps ?? this.totalSteps,
      totalDistanceKm: totalDistanceKm ?? this.totalDistanceKm,
      totalCalories: totalCalories ?? this.totalCalories,
      totalActiveMinutes: totalActiveMinutes ?? this.totalActiveMinutes,
      totalSleepMinutes: totalSleepMinutes ?? this.totalSleepMinutes,
      avgDailySteps: avgDailySteps ?? this.avgDailySteps,
      avgDailyDistanceKm: avgDailyDistanceKm ?? this.avgDailyDistanceKm,
      avgDailyCalories: avgDailyCalories ?? this.avgDailyCalories,
      avgDailySleepMinutes: avgDailySleepMinutes ?? this.avgDailySleepMinutes,
      goalMetDays: goalMetDays ?? this.goalMetDays,
      mostActiveDayDate: mostActiveDayDate ?? this.mostActiveDayDate,
      mostActiveDaySteps: mostActiveDaySteps ?? this.mostActiveDaySteps,
      recordedDaysCount: recordedDaysCount ?? this.recordedDaysCount,
      stepsChangePercent: stepsChangePercent ?? this.stepsChangePercent,
      sleepChangePercent: sleepChangePercent ?? this.sleepChangePercent,
      caloriesChangePercent:
          caloriesChangePercent ?? this.caloriesChangePercent,
      distanceChangePercent:
          distanceChangePercent ?? this.distanceChangePercent,
      dailyBreakdownJson: dailyBreakdownJson ?? this.dailyBreakdownJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (weekNumber.present) {
      map['week_number'] = Variable<int>(weekNumber.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (totalSteps.present) {
      map['total_steps'] = Variable<int>(totalSteps.value);
    }
    if (totalDistanceKm.present) {
      map['total_distance_km'] = Variable<double>(totalDistanceKm.value);
    }
    if (totalCalories.present) {
      map['total_calories'] = Variable<int>(totalCalories.value);
    }
    if (totalActiveMinutes.present) {
      map['total_active_minutes'] = Variable<int>(totalActiveMinutes.value);
    }
    if (totalSleepMinutes.present) {
      map['total_sleep_minutes'] = Variable<int>(totalSleepMinutes.value);
    }
    if (avgDailySteps.present) {
      map['avg_daily_steps'] = Variable<int>(avgDailySteps.value);
    }
    if (avgDailyDistanceKm.present) {
      map['avg_daily_distance_km'] = Variable<double>(avgDailyDistanceKm.value);
    }
    if (avgDailyCalories.present) {
      map['avg_daily_calories'] = Variable<int>(avgDailyCalories.value);
    }
    if (avgDailySleepMinutes.present) {
      map['avg_daily_sleep_minutes'] = Variable<int>(
        avgDailySleepMinutes.value,
      );
    }
    if (goalMetDays.present) {
      map['goal_met_days'] = Variable<int>(goalMetDays.value);
    }
    if (mostActiveDayDate.present) {
      map['most_active_day_date'] = Variable<String>(mostActiveDayDate.value);
    }
    if (mostActiveDaySteps.present) {
      map['most_active_day_steps'] = Variable<int>(mostActiveDaySteps.value);
    }
    if (recordedDaysCount.present) {
      map['recorded_days_count'] = Variable<int>(recordedDaysCount.value);
    }
    if (stepsChangePercent.present) {
      map['steps_change_percent'] = Variable<double>(stepsChangePercent.value);
    }
    if (sleepChangePercent.present) {
      map['sleep_change_percent'] = Variable<double>(sleepChangePercent.value);
    }
    if (caloriesChangePercent.present) {
      map['calories_change_percent'] = Variable<double>(
        caloriesChangePercent.value,
      );
    }
    if (distanceChangePercent.present) {
      map['distance_change_percent'] = Variable<double>(
        distanceChangePercent.value,
      );
    }
    if (dailyBreakdownJson.present) {
      map['daily_breakdown_json'] = Variable<String>(dailyBreakdownJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyReportsEntriesCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('year: $year, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('totalSteps: $totalSteps, ')
          ..write('totalDistanceKm: $totalDistanceKm, ')
          ..write('totalCalories: $totalCalories, ')
          ..write('totalActiveMinutes: $totalActiveMinutes, ')
          ..write('totalSleepMinutes: $totalSleepMinutes, ')
          ..write('avgDailySteps: $avgDailySteps, ')
          ..write('avgDailyDistanceKm: $avgDailyDistanceKm, ')
          ..write('avgDailyCalories: $avgDailyCalories, ')
          ..write('avgDailySleepMinutes: $avgDailySleepMinutes, ')
          ..write('goalMetDays: $goalMetDays, ')
          ..write('mostActiveDayDate: $mostActiveDayDate, ')
          ..write('mostActiveDaySteps: $mostActiveDaySteps, ')
          ..write('recordedDaysCount: $recordedDaysCount, ')
          ..write('stepsChangePercent: $stepsChangePercent, ')
          ..write('sleepChangePercent: $sleepChangePercent, ')
          ..write('caloriesChangePercent: $caloriesChangePercent, ')
          ..write('distanceChangePercent: $distanceChangePercent, ')
          ..write('dailyBreakdownJson: $dailyBreakdownJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeightRecordsEntriesTable extends WeightRecordsEntries
    with TableInfo<$WeightRecordsEntriesTable, WeightRecordsEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightRecordsEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bmiMeta = const VerificationMeta('bmi');
  @override
  late final GeneratedColumn<double> bmi = GeneratedColumn<double>(
    'bmi',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    weightKg,
    bmi,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_records_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeightRecordsEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('bmi')) {
      context.handle(
        _bmiMeta,
        bmi.isAcceptableOrUnknown(data['bmi']!, _bmiMeta),
      );
    } else if (isInserting) {
      context.missing(_bmiMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightRecordsEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightRecordsEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      bmi: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bmi'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WeightRecordsEntriesTable createAlias(String alias) {
    return $WeightRecordsEntriesTable(attachedDatabase, alias);
  }
}

class WeightRecordsEntry extends DataClass
    implements Insertable<WeightRecordsEntry> {
  /// Unique identifier (e.g. UUID or timestamp string)
  final String id;

  /// Calendar date of the weight measurement (yyyy-MM-dd)
  final String date;

  /// Body weight in kilograms
  final double weightKg;

  /// Body Mass Index calculated at the time of recording
  final double bmi;

  /// Optional user notes or context (e.g. "Morning before breakfast")
  final String? notes;

  /// Creation timestamp
  final DateTime createdAt;
  const WeightRecordsEntry({
    required this.id,
    required this.date,
    required this.weightKg,
    required this.bmi,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    map['weight_kg'] = Variable<double>(weightKg);
    map['bmi'] = Variable<double>(bmi);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WeightRecordsEntriesCompanion toCompanion(bool nullToAbsent) {
    return WeightRecordsEntriesCompanion(
      id: Value(id),
      date: Value(date),
      weightKg: Value(weightKg),
      bmi: Value(bmi),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory WeightRecordsEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightRecordsEntry(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      bmi: serializer.fromJson<double>(json['bmi']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'weightKg': serializer.toJson<double>(weightKg),
      'bmi': serializer.toJson<double>(bmi),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WeightRecordsEntry copyWith({
    String? id,
    String? date,
    double? weightKg,
    double? bmi,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => WeightRecordsEntry(
    id: id ?? this.id,
    date: date ?? this.date,
    weightKg: weightKg ?? this.weightKg,
    bmi: bmi ?? this.bmi,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  WeightRecordsEntry copyWithCompanion(WeightRecordsEntriesCompanion data) {
    return WeightRecordsEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      bmi: data.bmi.present ? data.bmi.value : this.bmi,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightRecordsEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg, ')
          ..write('bmi: $bmi, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, weightKg, bmi, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightRecordsEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.weightKg == this.weightKg &&
          other.bmi == this.bmi &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class WeightRecordsEntriesCompanion
    extends UpdateCompanion<WeightRecordsEntry> {
  final Value<String> id;
  final Value<String> date;
  final Value<double> weightKg;
  final Value<double> bmi;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const WeightRecordsEntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.bmi = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeightRecordsEntriesCompanion.insert({
    required String id,
    required String date,
    required double weightKg,
    required double bmi,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       weightKg = Value(weightKg),
       bmi = Value(bmi),
       createdAt = Value(createdAt);
  static Insertable<WeightRecordsEntry> custom({
    Expression<String>? id,
    Expression<String>? date,
    Expression<double>? weightKg,
    Expression<double>? bmi,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (weightKg != null) 'weight_kg': weightKg,
      if (bmi != null) 'bmi': bmi,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeightRecordsEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? date,
    Value<double>? weightKg,
    Value<double>? bmi,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return WeightRecordsEntriesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      weightKg: weightKg ?? this.weightKg,
      bmi: bmi ?? this.bmi,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (bmi.present) {
      map['bmi'] = Variable<double>(bmi.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightRecordsEntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg, ')
          ..write('bmi: $bmi, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CoachMessagesEntriesTable extends CoachMessagesEntries
    with TableInfo<$CoachMessagesEntriesTable, CoachMessagesEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoachMessagesEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sender,
    content,
    timestamp,
    category,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coach_messages_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CoachMessagesEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sender')) {
      context.handle(
        _senderMeta,
        sender.isAcceptableOrUnknown(data['sender']!, _senderMeta),
      );
    } else if (isInserting) {
      context.missing(_senderMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CoachMessagesEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CoachMessagesEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
    );
  }

  @override
  $CoachMessagesEntriesTable createAlias(String alias) {
    return $CoachMessagesEntriesTable(attachedDatabase, alias);
  }
}

class CoachMessagesEntry extends DataClass
    implements Insertable<CoachMessagesEntry> {
  /// Unique identifier for the message
  final String id;

  /// Sender identifier: 'user' or 'coach'
  final String sender;

  /// Message content body
  final String content;

  /// Message timestamp
  final DateTime timestamp;

  /// Optional message topic category (e.g. 'analysis', 'nutrition', 'hydration', 'sleep', 'activity')
  final String? category;
  const CoachMessagesEntry({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
    this.category,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sender'] = Variable<String>(sender);
    map['content'] = Variable<String>(content);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    return map;
  }

  CoachMessagesEntriesCompanion toCompanion(bool nullToAbsent) {
    return CoachMessagesEntriesCompanion(
      id: Value(id),
      sender: Value(sender),
      content: Value(content),
      timestamp: Value(timestamp),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
    );
  }

  factory CoachMessagesEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CoachMessagesEntry(
      id: serializer.fromJson<String>(json['id']),
      sender: serializer.fromJson<String>(json['sender']),
      content: serializer.fromJson<String>(json['content']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      category: serializer.fromJson<String?>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sender': serializer.toJson<String>(sender),
      'content': serializer.toJson<String>(content),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'category': serializer.toJson<String?>(category),
    };
  }

  CoachMessagesEntry copyWith({
    String? id,
    String? sender,
    String? content,
    DateTime? timestamp,
    Value<String?> category = const Value.absent(),
  }) => CoachMessagesEntry(
    id: id ?? this.id,
    sender: sender ?? this.sender,
    content: content ?? this.content,
    timestamp: timestamp ?? this.timestamp,
    category: category.present ? category.value : this.category,
  );
  CoachMessagesEntry copyWithCompanion(CoachMessagesEntriesCompanion data) {
    return CoachMessagesEntry(
      id: data.id.present ? data.id.value : this.id,
      sender: data.sender.present ? data.sender.value : this.sender,
      content: data.content.present ? data.content.value : this.content,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CoachMessagesEntry(')
          ..write('id: $id, ')
          ..write('sender: $sender, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sender, content, timestamp, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoachMessagesEntry &&
          other.id == this.id &&
          other.sender == this.sender &&
          other.content == this.content &&
          other.timestamp == this.timestamp &&
          other.category == this.category);
}

class CoachMessagesEntriesCompanion
    extends UpdateCompanion<CoachMessagesEntry> {
  final Value<String> id;
  final Value<String> sender;
  final Value<String> content;
  final Value<DateTime> timestamp;
  final Value<String?> category;
  final Value<int> rowid;
  const CoachMessagesEntriesCompanion({
    this.id = const Value.absent(),
    this.sender = const Value.absent(),
    this.content = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.category = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CoachMessagesEntriesCompanion.insert({
    required String id,
    required String sender,
    required String content,
    required DateTime timestamp,
    this.category = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sender = Value(sender),
       content = Value(content),
       timestamp = Value(timestamp);
  static Insertable<CoachMessagesEntry> custom({
    Expression<String>? id,
    Expression<String>? sender,
    Expression<String>? content,
    Expression<DateTime>? timestamp,
    Expression<String>? category,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sender != null) 'sender': sender,
      if (content != null) 'content': content,
      if (timestamp != null) 'timestamp': timestamp,
      if (category != null) 'category': category,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CoachMessagesEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? sender,
    Value<String>? content,
    Value<DateTime>? timestamp,
    Value<String?>? category,
    Value<int>? rowid,
  }) {
    return CoachMessagesEntriesCompanion(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoachMessagesEntriesCompanion(')
          ..write('id: $id, ')
          ..write('sender: $sender, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('category: $category, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DailyActivityEntriesTable dailyActivityEntries =
      $DailyActivityEntriesTable(this);
  late final $SavedRoutesEntriesTable savedRoutesEntries =
      $SavedRoutesEntriesTable(this);
  late final $MigrationMetadataEntriesTable migrationMetadataEntries =
      $MigrationMetadataEntriesTable(this);
  late final $SleepRecordsEntriesTable sleepRecordsEntries =
      $SleepRecordsEntriesTable(this);
  late final $WeeklyReportsEntriesTable weeklyReportsEntries =
      $WeeklyReportsEntriesTable(this);
  late final $WeightRecordsEntriesTable weightRecordsEntries =
      $WeightRecordsEntriesTable(this);
  late final $CoachMessagesEntriesTable coachMessagesEntries =
      $CoachMessagesEntriesTable(this);
  late final ActivityDao activityDao = ActivityDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dailyActivityEntries,
    savedRoutesEntries,
    migrationMetadataEntries,
    sleepRecordsEntries,
    weeklyReportsEntries,
    weightRecordsEntries,
    coachMessagesEntries,
  ];
}

typedef $$DailyActivityEntriesTableCreateCompanionBuilder =
    DailyActivityEntriesCompanion Function({
      required String date,
      Value<int> steps,
      Value<double> distanceKm,
      Value<int> calories,
      Value<int> activeMinutes,
      Value<int> goalSteps,
      Value<bool> isGoalCompleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$DailyActivityEntriesTableUpdateCompanionBuilder =
    DailyActivityEntriesCompanion Function({
      Value<String> date,
      Value<int> steps,
      Value<double> distanceKm,
      Value<int> calories,
      Value<int> activeMinutes,
      Value<int> goalSteps,
      Value<bool> isGoalCompleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DailyActivityEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DailyActivityEntriesTable> {
  $$DailyActivityEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activeMinutes => $composableBuilder(
    column: $table.activeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalSteps => $composableBuilder(
    column: $table.goalSteps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isGoalCompleted => $composableBuilder(
    column: $table.isGoalCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyActivityEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyActivityEntriesTable> {
  $$DailyActivityEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activeMinutes => $composableBuilder(
    column: $table.activeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalSteps => $composableBuilder(
    column: $table.goalSteps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isGoalCompleted => $composableBuilder(
    column: $table.isGoalCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyActivityEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyActivityEntriesTable> {
  $$DailyActivityEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<int> get activeMinutes => $composableBuilder(
    column: $table.activeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get goalSteps =>
      $composableBuilder(column: $table.goalSteps, builder: (column) => column);

  GeneratedColumn<bool> get isGoalCompleted => $composableBuilder(
    column: $table.isGoalCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyActivityEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyActivityEntriesTable,
          DailyActivityEntry,
          $$DailyActivityEntriesTableFilterComposer,
          $$DailyActivityEntriesTableOrderingComposer,
          $$DailyActivityEntriesTableAnnotationComposer,
          $$DailyActivityEntriesTableCreateCompanionBuilder,
          $$DailyActivityEntriesTableUpdateCompanionBuilder,
          (
            DailyActivityEntry,
            BaseReferences<
              _$AppDatabase,
              $DailyActivityEntriesTable,
              DailyActivityEntry
            >,
          ),
          DailyActivityEntry,
          PrefetchHooks Function()
        > {
  $$DailyActivityEntriesTableTableManager(
    _$AppDatabase db,
    $DailyActivityEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyActivityEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyActivityEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DailyActivityEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<int> steps = const Value.absent(),
                Value<double> distanceKm = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<int> activeMinutes = const Value.absent(),
                Value<int> goalSteps = const Value.absent(),
                Value<bool> isGoalCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyActivityEntriesCompanion(
                date: date,
                steps: steps,
                distanceKm: distanceKm,
                calories: calories,
                activeMinutes: activeMinutes,
                goalSteps: goalSteps,
                isGoalCompleted: isGoalCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                Value<int> steps = const Value.absent(),
                Value<double> distanceKm = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<int> activeMinutes = const Value.absent(),
                Value<int> goalSteps = const Value.absent(),
                Value<bool> isGoalCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyActivityEntriesCompanion.insert(
                date: date,
                steps: steps,
                distanceKm: distanceKm,
                calories: calories,
                activeMinutes: activeMinutes,
                goalSteps: goalSteps,
                isGoalCompleted: isGoalCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyActivityEntriesTable, DailyActivityEntry>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $DailyActivityEntriesTable,
                    DailyActivityEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyActivityEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyActivityEntriesTable,
      DailyActivityEntry,
      $$DailyActivityEntriesTableFilterComposer,
      $$DailyActivityEntriesTableOrderingComposer,
      $$DailyActivityEntriesTableAnnotationComposer,
      $$DailyActivityEntriesTableCreateCompanionBuilder,
      $$DailyActivityEntriesTableUpdateCompanionBuilder,
      (
        DailyActivityEntry,
        BaseReferences<
          _$AppDatabase,
          $DailyActivityEntriesTable,
          DailyActivityEntry
        >,
      ),
      DailyActivityEntry,
      PrefetchHooks Function()
    >;
typedef $$SavedRoutesEntriesTableCreateCompanionBuilder =
    SavedRoutesEntriesCompanion Function({
      required String id,
      required String title,
      required DateTime routeDateTime,
      required double distanceKm,
      required int durationSeconds,
      required double avgSpeedKmH,
      required int calories,
      Value<double> vehicleDistanceKm,
      required String coordinatesJson,
      Value<int> rowid,
    });
typedef $$SavedRoutesEntriesTableUpdateCompanionBuilder =
    SavedRoutesEntriesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<DateTime> routeDateTime,
      Value<double> distanceKm,
      Value<int> durationSeconds,
      Value<double> avgSpeedKmH,
      Value<int> calories,
      Value<double> vehicleDistanceKm,
      Value<String> coordinatesJson,
      Value<int> rowid,
    });

class $$SavedRoutesEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SavedRoutesEntriesTable> {
  $$SavedRoutesEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get routeDateTime => $composableBuilder(
    column: $table.routeDateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgSpeedKmH => $composableBuilder(
    column: $table.avgSpeedKmH,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get vehicleDistanceKm => $composableBuilder(
    column: $table.vehicleDistanceKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coordinatesJson => $composableBuilder(
    column: $table.coordinatesJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedRoutesEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedRoutesEntriesTable> {
  $$SavedRoutesEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get routeDateTime => $composableBuilder(
    column: $table.routeDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgSpeedKmH => $composableBuilder(
    column: $table.avgSpeedKmH,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get vehicleDistanceKm => $composableBuilder(
    column: $table.vehicleDistanceKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coordinatesJson => $composableBuilder(
    column: $table.coordinatesJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedRoutesEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedRoutesEntriesTable> {
  $$SavedRoutesEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get routeDateTime => $composableBuilder(
    column: $table.routeDateTime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgSpeedKmH => $composableBuilder(
    column: $table.avgSpeedKmH,
    builder: (column) => column,
  );

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get vehicleDistanceKm => $composableBuilder(
    column: $table.vehicleDistanceKm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coordinatesJson => $composableBuilder(
    column: $table.coordinatesJson,
    builder: (column) => column,
  );
}

class $$SavedRoutesEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedRoutesEntriesTable,
          SavedRoutesEntry,
          $$SavedRoutesEntriesTableFilterComposer,
          $$SavedRoutesEntriesTableOrderingComposer,
          $$SavedRoutesEntriesTableAnnotationComposer,
          $$SavedRoutesEntriesTableCreateCompanionBuilder,
          $$SavedRoutesEntriesTableUpdateCompanionBuilder,
          (
            SavedRoutesEntry,
            BaseReferences<
              _$AppDatabase,
              $SavedRoutesEntriesTable,
              SavedRoutesEntry
            >,
          ),
          SavedRoutesEntry,
          PrefetchHooks Function()
        > {
  $$SavedRoutesEntriesTableTableManager(
    _$AppDatabase db,
    $SavedRoutesEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedRoutesEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedRoutesEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedRoutesEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> routeDateTime = const Value.absent(),
                Value<double> distanceKm = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<double> avgSpeedKmH = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<double> vehicleDistanceKm = const Value.absent(),
                Value<String> coordinatesJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedRoutesEntriesCompanion(
                id: id,
                title: title,
                routeDateTime: routeDateTime,
                distanceKm: distanceKm,
                durationSeconds: durationSeconds,
                avgSpeedKmH: avgSpeedKmH,
                calories: calories,
                vehicleDistanceKm: vehicleDistanceKm,
                coordinatesJson: coordinatesJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required DateTime routeDateTime,
                required double distanceKm,
                required int durationSeconds,
                required double avgSpeedKmH,
                required int calories,
                Value<double> vehicleDistanceKm = const Value.absent(),
                required String coordinatesJson,
                Value<int> rowid = const Value.absent(),
              }) => SavedRoutesEntriesCompanion.insert(
                id: id,
                title: title,
                routeDateTime: routeDateTime,
                distanceKm: distanceKm,
                durationSeconds: durationSeconds,
                avgSpeedKmH: avgSpeedKmH,
                calories: calories,
                vehicleDistanceKm: vehicleDistanceKm,
                coordinatesJson: coordinatesJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SavedRoutesEntriesTable, SavedRoutesEntry>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $SavedRoutesEntriesTable,
                    SavedRoutesEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedRoutesEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedRoutesEntriesTable,
      SavedRoutesEntry,
      $$SavedRoutesEntriesTableFilterComposer,
      $$SavedRoutesEntriesTableOrderingComposer,
      $$SavedRoutesEntriesTableAnnotationComposer,
      $$SavedRoutesEntriesTableCreateCompanionBuilder,
      $$SavedRoutesEntriesTableUpdateCompanionBuilder,
      (
        SavedRoutesEntry,
        BaseReferences<
          _$AppDatabase,
          $SavedRoutesEntriesTable,
          SavedRoutesEntry
        >,
      ),
      SavedRoutesEntry,
      PrefetchHooks Function()
    >;
typedef $$MigrationMetadataEntriesTableCreateCompanionBuilder =
    MigrationMetadataEntriesCompanion Function({
      required String key,
      Value<bool> isCompleted,
      Value<DateTime?> migratedAt,
      Value<int> recordsCount,
      Value<String?> verificationHash,
      Value<int> rowid,
    });
typedef $$MigrationMetadataEntriesTableUpdateCompanionBuilder =
    MigrationMetadataEntriesCompanion Function({
      Value<String> key,
      Value<bool> isCompleted,
      Value<DateTime?> migratedAt,
      Value<int> recordsCount,
      Value<String?> verificationHash,
      Value<int> rowid,
    });

class $$MigrationMetadataEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MigrationMetadataEntriesTable> {
  $$MigrationMetadataEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get migratedAt => $composableBuilder(
    column: $table.migratedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordsCount => $composableBuilder(
    column: $table.recordsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verificationHash => $composableBuilder(
    column: $table.verificationHash,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MigrationMetadataEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MigrationMetadataEntriesTable> {
  $$MigrationMetadataEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get migratedAt => $composableBuilder(
    column: $table.migratedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordsCount => $composableBuilder(
    column: $table.recordsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verificationHash => $composableBuilder(
    column: $table.verificationHash,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MigrationMetadataEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MigrationMetadataEntriesTable> {
  $$MigrationMetadataEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get migratedAt => $composableBuilder(
    column: $table.migratedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordsCount => $composableBuilder(
    column: $table.recordsCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get verificationHash => $composableBuilder(
    column: $table.verificationHash,
    builder: (column) => column,
  );
}

class $$MigrationMetadataEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MigrationMetadataEntriesTable,
          MigrationMetadataEntry,
          $$MigrationMetadataEntriesTableFilterComposer,
          $$MigrationMetadataEntriesTableOrderingComposer,
          $$MigrationMetadataEntriesTableAnnotationComposer,
          $$MigrationMetadataEntriesTableCreateCompanionBuilder,
          $$MigrationMetadataEntriesTableUpdateCompanionBuilder,
          (
            MigrationMetadataEntry,
            BaseReferences<
              _$AppDatabase,
              $MigrationMetadataEntriesTable,
              MigrationMetadataEntry
            >,
          ),
          MigrationMetadataEntry,
          PrefetchHooks Function()
        > {
  $$MigrationMetadataEntriesTableTableManager(
    _$AppDatabase db,
    $MigrationMetadataEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MigrationMetadataEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$MigrationMetadataEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MigrationMetadataEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> migratedAt = const Value.absent(),
                Value<int> recordsCount = const Value.absent(),
                Value<String?> verificationHash = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MigrationMetadataEntriesCompanion(
                key: key,
                isCompleted: isCompleted,
                migratedAt: migratedAt,
                recordsCount: recordsCount,
                verificationHash: verificationHash,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> migratedAt = const Value.absent(),
                Value<int> recordsCount = const Value.absent(),
                Value<String?> verificationHash = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MigrationMetadataEntriesCompanion.insert(
                key: key,
                isCompleted: isCompleted,
                migratedAt: migratedAt,
                recordsCount: recordsCount,
                verificationHash: verificationHash,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $MigrationMetadataEntriesTable,
                    MigrationMetadataEntry
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MigrationMetadataEntriesTable,
                    MigrationMetadataEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MigrationMetadataEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MigrationMetadataEntriesTable,
      MigrationMetadataEntry,
      $$MigrationMetadataEntriesTableFilterComposer,
      $$MigrationMetadataEntriesTableOrderingComposer,
      $$MigrationMetadataEntriesTableAnnotationComposer,
      $$MigrationMetadataEntriesTableCreateCompanionBuilder,
      $$MigrationMetadataEntriesTableUpdateCompanionBuilder,
      (
        MigrationMetadataEntry,
        BaseReferences<
          _$AppDatabase,
          $MigrationMetadataEntriesTable,
          MigrationMetadataEntry
        >,
      ),
      MigrationMetadataEntry,
      PrefetchHooks Function()
    >;
typedef $$SleepRecordsEntriesTableCreateCompanionBuilder =
    SleepRecordsEntriesCompanion Function({
      required String id,
      required String date,
      required DateTime bedtime,
      required DateTime wakeTime,
      required int durationMinutes,
      Value<String> source,
      Value<int> efficiencyPercent,
      Value<String?> notes,
      Value<bool> hasStages,
      Value<int?> lightSleepMinutes,
      Value<int?> deepSleepMinutes,
      Value<int?> remSleepMinutes,
      Value<int?> awakeMinutes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$SleepRecordsEntriesTableUpdateCompanionBuilder =
    SleepRecordsEntriesCompanion Function({
      Value<String> id,
      Value<String> date,
      Value<DateTime> bedtime,
      Value<DateTime> wakeTime,
      Value<int> durationMinutes,
      Value<String> source,
      Value<int> efficiencyPercent,
      Value<String?> notes,
      Value<bool> hasStages,
      Value<int?> lightSleepMinutes,
      Value<int?> deepSleepMinutes,
      Value<int?> remSleepMinutes,
      Value<int?> awakeMinutes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SleepRecordsEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SleepRecordsEntriesTable> {
  $$SleepRecordsEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get bedtime => $composableBuilder(
    column: $table.bedtime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get wakeTime => $composableBuilder(
    column: $table.wakeTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get efficiencyPercent => $composableBuilder(
    column: $table.efficiencyPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasStages => $composableBuilder(
    column: $table.hasStages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lightSleepMinutes => $composableBuilder(
    column: $table.lightSleepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deepSleepMinutes => $composableBuilder(
    column: $table.deepSleepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remSleepMinutes => $composableBuilder(
    column: $table.remSleepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get awakeMinutes => $composableBuilder(
    column: $table.awakeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SleepRecordsEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SleepRecordsEntriesTable> {
  $$SleepRecordsEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get bedtime => $composableBuilder(
    column: $table.bedtime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get wakeTime => $composableBuilder(
    column: $table.wakeTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get efficiencyPercent => $composableBuilder(
    column: $table.efficiencyPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasStages => $composableBuilder(
    column: $table.hasStages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lightSleepMinutes => $composableBuilder(
    column: $table.lightSleepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deepSleepMinutes => $composableBuilder(
    column: $table.deepSleepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remSleepMinutes => $composableBuilder(
    column: $table.remSleepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get awakeMinutes => $composableBuilder(
    column: $table.awakeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SleepRecordsEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SleepRecordsEntriesTable> {
  $$SleepRecordsEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get bedtime =>
      $composableBuilder(column: $table.bedtime, builder: (column) => column);

  GeneratedColumn<DateTime> get wakeTime =>
      $composableBuilder(column: $table.wakeTime, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get efficiencyPercent => $composableBuilder(
    column: $table.efficiencyPercent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get hasStages =>
      $composableBuilder(column: $table.hasStages, builder: (column) => column);

  GeneratedColumn<int> get lightSleepMinutes => $composableBuilder(
    column: $table.lightSleepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deepSleepMinutes => $composableBuilder(
    column: $table.deepSleepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remSleepMinutes => $composableBuilder(
    column: $table.remSleepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get awakeMinutes => $composableBuilder(
    column: $table.awakeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SleepRecordsEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SleepRecordsEntriesTable,
          SleepRecordsEntry,
          $$SleepRecordsEntriesTableFilterComposer,
          $$SleepRecordsEntriesTableOrderingComposer,
          $$SleepRecordsEntriesTableAnnotationComposer,
          $$SleepRecordsEntriesTableCreateCompanionBuilder,
          $$SleepRecordsEntriesTableUpdateCompanionBuilder,
          (
            SleepRecordsEntry,
            BaseReferences<
              _$AppDatabase,
              $SleepRecordsEntriesTable,
              SleepRecordsEntry
            >,
          ),
          SleepRecordsEntry,
          PrefetchHooks Function()
        > {
  $$SleepRecordsEntriesTableTableManager(
    _$AppDatabase db,
    $SleepRecordsEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SleepRecordsEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SleepRecordsEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SleepRecordsEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<DateTime> bedtime = const Value.absent(),
                Value<DateTime> wakeTime = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> efficiencyPercent = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> hasStages = const Value.absent(),
                Value<int?> lightSleepMinutes = const Value.absent(),
                Value<int?> deepSleepMinutes = const Value.absent(),
                Value<int?> remSleepMinutes = const Value.absent(),
                Value<int?> awakeMinutes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SleepRecordsEntriesCompanion(
                id: id,
                date: date,
                bedtime: bedtime,
                wakeTime: wakeTime,
                durationMinutes: durationMinutes,
                source: source,
                efficiencyPercent: efficiencyPercent,
                notes: notes,
                hasStages: hasStages,
                lightSleepMinutes: lightSleepMinutes,
                deepSleepMinutes: deepSleepMinutes,
                remSleepMinutes: remSleepMinutes,
                awakeMinutes: awakeMinutes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String date,
                required DateTime bedtime,
                required DateTime wakeTime,
                required int durationMinutes,
                Value<String> source = const Value.absent(),
                Value<int> efficiencyPercent = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> hasStages = const Value.absent(),
                Value<int?> lightSleepMinutes = const Value.absent(),
                Value<int?> deepSleepMinutes = const Value.absent(),
                Value<int?> remSleepMinutes = const Value.absent(),
                Value<int?> awakeMinutes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SleepRecordsEntriesCompanion.insert(
                id: id,
                date: date,
                bedtime: bedtime,
                wakeTime: wakeTime,
                durationMinutes: durationMinutes,
                source: source,
                efficiencyPercent: efficiencyPercent,
                notes: notes,
                hasStages: hasStages,
                lightSleepMinutes: lightSleepMinutes,
                deepSleepMinutes: deepSleepMinutes,
                remSleepMinutes: remSleepMinutes,
                awakeMinutes: awakeMinutes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SleepRecordsEntriesTable, SleepRecordsEntry>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $SleepRecordsEntriesTable,
                    SleepRecordsEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SleepRecordsEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SleepRecordsEntriesTable,
      SleepRecordsEntry,
      $$SleepRecordsEntriesTableFilterComposer,
      $$SleepRecordsEntriesTableOrderingComposer,
      $$SleepRecordsEntriesTableAnnotationComposer,
      $$SleepRecordsEntriesTableCreateCompanionBuilder,
      $$SleepRecordsEntriesTableUpdateCompanionBuilder,
      (
        SleepRecordsEntry,
        BaseReferences<
          _$AppDatabase,
          $SleepRecordsEntriesTable,
          SleepRecordsEntry
        >,
      ),
      SleepRecordsEntry,
      PrefetchHooks Function()
    >;
typedef $$WeeklyReportsEntriesTableCreateCompanionBuilder =
    WeeklyReportsEntriesCompanion Function({
      required String id,
      required String startDate,
      required String endDate,
      required int year,
      required int weekNumber,
      required DateTime generatedAt,
      required int totalSteps,
      required double totalDistanceKm,
      required int totalCalories,
      required int totalActiveMinutes,
      required int totalSleepMinutes,
      required int avgDailySteps,
      required double avgDailyDistanceKm,
      required int avgDailyCalories,
      required int avgDailySleepMinutes,
      required int goalMetDays,
      required String mostActiveDayDate,
      required int mostActiveDaySteps,
      required int recordedDaysCount,
      Value<double?> stepsChangePercent,
      Value<double?> sleepChangePercent,
      Value<double?> caloriesChangePercent,
      Value<double?> distanceChangePercent,
      required String dailyBreakdownJson,
      Value<int> rowid,
    });
typedef $$WeeklyReportsEntriesTableUpdateCompanionBuilder =
    WeeklyReportsEntriesCompanion Function({
      Value<String> id,
      Value<String> startDate,
      Value<String> endDate,
      Value<int> year,
      Value<int> weekNumber,
      Value<DateTime> generatedAt,
      Value<int> totalSteps,
      Value<double> totalDistanceKm,
      Value<int> totalCalories,
      Value<int> totalActiveMinutes,
      Value<int> totalSleepMinutes,
      Value<int> avgDailySteps,
      Value<double> avgDailyDistanceKm,
      Value<int> avgDailyCalories,
      Value<int> avgDailySleepMinutes,
      Value<int> goalMetDays,
      Value<String> mostActiveDayDate,
      Value<int> mostActiveDaySteps,
      Value<int> recordedDaysCount,
      Value<double?> stepsChangePercent,
      Value<double?> sleepChangePercent,
      Value<double?> caloriesChangePercent,
      Value<double?> distanceChangePercent,
      Value<String> dailyBreakdownJson,
      Value<int> rowid,
    });

class $$WeeklyReportsEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyReportsEntriesTable> {
  $$WeeklyReportsEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalSteps => $composableBuilder(
    column: $table.totalSteps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalDistanceKm => $composableBuilder(
    column: $table.totalDistanceKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCalories => $composableBuilder(
    column: $table.totalCalories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalActiveMinutes => $composableBuilder(
    column: $table.totalActiveMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalSleepMinutes => $composableBuilder(
    column: $table.totalSleepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get avgDailySteps => $composableBuilder(
    column: $table.avgDailySteps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgDailyDistanceKm => $composableBuilder(
    column: $table.avgDailyDistanceKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get avgDailyCalories => $composableBuilder(
    column: $table.avgDailyCalories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get avgDailySleepMinutes => $composableBuilder(
    column: $table.avgDailySleepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalMetDays => $composableBuilder(
    column: $table.goalMetDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mostActiveDayDate => $composableBuilder(
    column: $table.mostActiveDayDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mostActiveDaySteps => $composableBuilder(
    column: $table.mostActiveDaySteps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordedDaysCount => $composableBuilder(
    column: $table.recordedDaysCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stepsChangePercent => $composableBuilder(
    column: $table.stepsChangePercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sleepChangePercent => $composableBuilder(
    column: $table.sleepChangePercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caloriesChangePercent => $composableBuilder(
    column: $table.caloriesChangePercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceChangePercent => $composableBuilder(
    column: $table.distanceChangePercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dailyBreakdownJson => $composableBuilder(
    column: $table.dailyBreakdownJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklyReportsEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyReportsEntriesTable> {
  $$WeeklyReportsEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalSteps => $composableBuilder(
    column: $table.totalSteps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalDistanceKm => $composableBuilder(
    column: $table.totalDistanceKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCalories => $composableBuilder(
    column: $table.totalCalories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalActiveMinutes => $composableBuilder(
    column: $table.totalActiveMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalSleepMinutes => $composableBuilder(
    column: $table.totalSleepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get avgDailySteps => $composableBuilder(
    column: $table.avgDailySteps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgDailyDistanceKm => $composableBuilder(
    column: $table.avgDailyDistanceKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get avgDailyCalories => $composableBuilder(
    column: $table.avgDailyCalories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get avgDailySleepMinutes => $composableBuilder(
    column: $table.avgDailySleepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalMetDays => $composableBuilder(
    column: $table.goalMetDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mostActiveDayDate => $composableBuilder(
    column: $table.mostActiveDayDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mostActiveDaySteps => $composableBuilder(
    column: $table.mostActiveDaySteps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordedDaysCount => $composableBuilder(
    column: $table.recordedDaysCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stepsChangePercent => $composableBuilder(
    column: $table.stepsChangePercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sleepChangePercent => $composableBuilder(
    column: $table.sleepChangePercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caloriesChangePercent => $composableBuilder(
    column: $table.caloriesChangePercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceChangePercent => $composableBuilder(
    column: $table.distanceChangePercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dailyBreakdownJson => $composableBuilder(
    column: $table.dailyBreakdownJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklyReportsEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyReportsEntriesTable> {
  $$WeeklyReportsEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalSteps => $composableBuilder(
    column: $table.totalSteps,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalDistanceKm => $composableBuilder(
    column: $table.totalDistanceKm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCalories => $composableBuilder(
    column: $table.totalCalories,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalActiveMinutes => $composableBuilder(
    column: $table.totalActiveMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalSleepMinutes => $composableBuilder(
    column: $table.totalSleepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get avgDailySteps => $composableBuilder(
    column: $table.avgDailySteps,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgDailyDistanceKm => $composableBuilder(
    column: $table.avgDailyDistanceKm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get avgDailyCalories => $composableBuilder(
    column: $table.avgDailyCalories,
    builder: (column) => column,
  );

  GeneratedColumn<int> get avgDailySleepMinutes => $composableBuilder(
    column: $table.avgDailySleepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get goalMetDays => $composableBuilder(
    column: $table.goalMetDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mostActiveDayDate => $composableBuilder(
    column: $table.mostActiveDayDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mostActiveDaySteps => $composableBuilder(
    column: $table.mostActiveDaySteps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordedDaysCount => $composableBuilder(
    column: $table.recordedDaysCount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get stepsChangePercent => $composableBuilder(
    column: $table.stepsChangePercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sleepChangePercent => $composableBuilder(
    column: $table.sleepChangePercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get caloriesChangePercent => $composableBuilder(
    column: $table.caloriesChangePercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceChangePercent => $composableBuilder(
    column: $table.distanceChangePercent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dailyBreakdownJson => $composableBuilder(
    column: $table.dailyBreakdownJson,
    builder: (column) => column,
  );
}

class $$WeeklyReportsEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyReportsEntriesTable,
          WeeklyReportsEntry,
          $$WeeklyReportsEntriesTableFilterComposer,
          $$WeeklyReportsEntriesTableOrderingComposer,
          $$WeeklyReportsEntriesTableAnnotationComposer,
          $$WeeklyReportsEntriesTableCreateCompanionBuilder,
          $$WeeklyReportsEntriesTableUpdateCompanionBuilder,
          (
            WeeklyReportsEntry,
            BaseReferences<
              _$AppDatabase,
              $WeeklyReportsEntriesTable,
              WeeklyReportsEntry
            >,
          ),
          WeeklyReportsEntry,
          PrefetchHooks Function()
        > {
  $$WeeklyReportsEntriesTableTableManager(
    _$AppDatabase db,
    $WeeklyReportsEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyReportsEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyReportsEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WeeklyReportsEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String> endDate = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> weekNumber = const Value.absent(),
                Value<DateTime> generatedAt = const Value.absent(),
                Value<int> totalSteps = const Value.absent(),
                Value<double> totalDistanceKm = const Value.absent(),
                Value<int> totalCalories = const Value.absent(),
                Value<int> totalActiveMinutes = const Value.absent(),
                Value<int> totalSleepMinutes = const Value.absent(),
                Value<int> avgDailySteps = const Value.absent(),
                Value<double> avgDailyDistanceKm = const Value.absent(),
                Value<int> avgDailyCalories = const Value.absent(),
                Value<int> avgDailySleepMinutes = const Value.absent(),
                Value<int> goalMetDays = const Value.absent(),
                Value<String> mostActiveDayDate = const Value.absent(),
                Value<int> mostActiveDaySteps = const Value.absent(),
                Value<int> recordedDaysCount = const Value.absent(),
                Value<double?> stepsChangePercent = const Value.absent(),
                Value<double?> sleepChangePercent = const Value.absent(),
                Value<double?> caloriesChangePercent = const Value.absent(),
                Value<double?> distanceChangePercent = const Value.absent(),
                Value<String> dailyBreakdownJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeeklyReportsEntriesCompanion(
                id: id,
                startDate: startDate,
                endDate: endDate,
                year: year,
                weekNumber: weekNumber,
                generatedAt: generatedAt,
                totalSteps: totalSteps,
                totalDistanceKm: totalDistanceKm,
                totalCalories: totalCalories,
                totalActiveMinutes: totalActiveMinutes,
                totalSleepMinutes: totalSleepMinutes,
                avgDailySteps: avgDailySteps,
                avgDailyDistanceKm: avgDailyDistanceKm,
                avgDailyCalories: avgDailyCalories,
                avgDailySleepMinutes: avgDailySleepMinutes,
                goalMetDays: goalMetDays,
                mostActiveDayDate: mostActiveDayDate,
                mostActiveDaySteps: mostActiveDaySteps,
                recordedDaysCount: recordedDaysCount,
                stepsChangePercent: stepsChangePercent,
                sleepChangePercent: sleepChangePercent,
                caloriesChangePercent: caloriesChangePercent,
                distanceChangePercent: distanceChangePercent,
                dailyBreakdownJson: dailyBreakdownJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String startDate,
                required String endDate,
                required int year,
                required int weekNumber,
                required DateTime generatedAt,
                required int totalSteps,
                required double totalDistanceKm,
                required int totalCalories,
                required int totalActiveMinutes,
                required int totalSleepMinutes,
                required int avgDailySteps,
                required double avgDailyDistanceKm,
                required int avgDailyCalories,
                required int avgDailySleepMinutes,
                required int goalMetDays,
                required String mostActiveDayDate,
                required int mostActiveDaySteps,
                required int recordedDaysCount,
                Value<double?> stepsChangePercent = const Value.absent(),
                Value<double?> sleepChangePercent = const Value.absent(),
                Value<double?> caloriesChangePercent = const Value.absent(),
                Value<double?> distanceChangePercent = const Value.absent(),
                required String dailyBreakdownJson,
                Value<int> rowid = const Value.absent(),
              }) => WeeklyReportsEntriesCompanion.insert(
                id: id,
                startDate: startDate,
                endDate: endDate,
                year: year,
                weekNumber: weekNumber,
                generatedAt: generatedAt,
                totalSteps: totalSteps,
                totalDistanceKm: totalDistanceKm,
                totalCalories: totalCalories,
                totalActiveMinutes: totalActiveMinutes,
                totalSleepMinutes: totalSleepMinutes,
                avgDailySteps: avgDailySteps,
                avgDailyDistanceKm: avgDailyDistanceKm,
                avgDailyCalories: avgDailyCalories,
                avgDailySleepMinutes: avgDailySleepMinutes,
                goalMetDays: goalMetDays,
                mostActiveDayDate: mostActiveDayDate,
                mostActiveDaySteps: mostActiveDaySteps,
                recordedDaysCount: recordedDaysCount,
                stepsChangePercent: stepsChangePercent,
                sleepChangePercent: sleepChangePercent,
                caloriesChangePercent: caloriesChangePercent,
                distanceChangePercent: distanceChangePercent,
                dailyBreakdownJson: dailyBreakdownJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeeklyReportsEntriesTable, WeeklyReportsEntry>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $WeeklyReportsEntriesTable,
                    WeeklyReportsEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklyReportsEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyReportsEntriesTable,
      WeeklyReportsEntry,
      $$WeeklyReportsEntriesTableFilterComposer,
      $$WeeklyReportsEntriesTableOrderingComposer,
      $$WeeklyReportsEntriesTableAnnotationComposer,
      $$WeeklyReportsEntriesTableCreateCompanionBuilder,
      $$WeeklyReportsEntriesTableUpdateCompanionBuilder,
      (
        WeeklyReportsEntry,
        BaseReferences<
          _$AppDatabase,
          $WeeklyReportsEntriesTable,
          WeeklyReportsEntry
        >,
      ),
      WeeklyReportsEntry,
      PrefetchHooks Function()
    >;
typedef $$WeightRecordsEntriesTableCreateCompanionBuilder =
    WeightRecordsEntriesCompanion Function({
      required String id,
      required String date,
      required double weightKg,
      required double bmi,
      Value<String?> notes,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$WeightRecordsEntriesTableUpdateCompanionBuilder =
    WeightRecordsEntriesCompanion Function({
      Value<String> id,
      Value<String> date,
      Value<double> weightKg,
      Value<double> bmi,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$WeightRecordsEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WeightRecordsEntriesTable> {
  $$WeightRecordsEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bmi => $composableBuilder(
    column: $table.bmi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeightRecordsEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightRecordsEntriesTable> {
  $$WeightRecordsEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bmi => $composableBuilder(
    column: $table.bmi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeightRecordsEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightRecordsEntriesTable> {
  $$WeightRecordsEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get bmi =>
      $composableBuilder(column: $table.bmi, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WeightRecordsEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightRecordsEntriesTable,
          WeightRecordsEntry,
          $$WeightRecordsEntriesTableFilterComposer,
          $$WeightRecordsEntriesTableOrderingComposer,
          $$WeightRecordsEntriesTableAnnotationComposer,
          $$WeightRecordsEntriesTableCreateCompanionBuilder,
          $$WeightRecordsEntriesTableUpdateCompanionBuilder,
          (
            WeightRecordsEntry,
            BaseReferences<
              _$AppDatabase,
              $WeightRecordsEntriesTable,
              WeightRecordsEntry
            >,
          ),
          WeightRecordsEntry,
          PrefetchHooks Function()
        > {
  $$WeightRecordsEntriesTableTableManager(
    _$AppDatabase db,
    $WeightRecordsEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightRecordsEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightRecordsEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WeightRecordsEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<double> bmi = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeightRecordsEntriesCompanion(
                id: id,
                date: date,
                weightKg: weightKg,
                bmi: bmi,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String date,
                required double weightKg,
                required double bmi,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => WeightRecordsEntriesCompanion.insert(
                id: id,
                date: date,
                weightKg: weightKg,
                bmi: bmi,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeightRecordsEntriesTable, WeightRecordsEntry>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $WeightRecordsEntriesTable,
                    WeightRecordsEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeightRecordsEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightRecordsEntriesTable,
      WeightRecordsEntry,
      $$WeightRecordsEntriesTableFilterComposer,
      $$WeightRecordsEntriesTableOrderingComposer,
      $$WeightRecordsEntriesTableAnnotationComposer,
      $$WeightRecordsEntriesTableCreateCompanionBuilder,
      $$WeightRecordsEntriesTableUpdateCompanionBuilder,
      (
        WeightRecordsEntry,
        BaseReferences<
          _$AppDatabase,
          $WeightRecordsEntriesTable,
          WeightRecordsEntry
        >,
      ),
      WeightRecordsEntry,
      PrefetchHooks Function()
    >;
typedef $$CoachMessagesEntriesTableCreateCompanionBuilder =
    CoachMessagesEntriesCompanion Function({
      required String id,
      required String sender,
      required String content,
      required DateTime timestamp,
      Value<String?> category,
      Value<int> rowid,
    });
typedef $$CoachMessagesEntriesTableUpdateCompanionBuilder =
    CoachMessagesEntriesCompanion Function({
      Value<String> id,
      Value<String> sender,
      Value<String> content,
      Value<DateTime> timestamp,
      Value<String?> category,
      Value<int> rowid,
    });

class $$CoachMessagesEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CoachMessagesEntriesTable> {
  $$CoachMessagesEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CoachMessagesEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CoachMessagesEntriesTable> {
  $$CoachMessagesEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CoachMessagesEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoachMessagesEntriesTable> {
  $$CoachMessagesEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);
}

class $$CoachMessagesEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CoachMessagesEntriesTable,
          CoachMessagesEntry,
          $$CoachMessagesEntriesTableFilterComposer,
          $$CoachMessagesEntriesTableOrderingComposer,
          $$CoachMessagesEntriesTableAnnotationComposer,
          $$CoachMessagesEntriesTableCreateCompanionBuilder,
          $$CoachMessagesEntriesTableUpdateCompanionBuilder,
          (
            CoachMessagesEntry,
            BaseReferences<
              _$AppDatabase,
              $CoachMessagesEntriesTable,
              CoachMessagesEntry
            >,
          ),
          CoachMessagesEntry,
          PrefetchHooks Function()
        > {
  $$CoachMessagesEntriesTableTableManager(
    _$AppDatabase db,
    $CoachMessagesEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoachMessagesEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoachMessagesEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CoachMessagesEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sender = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoachMessagesEntriesCompanion(
                id: id,
                sender: sender,
                content: content,
                timestamp: timestamp,
                category: category,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sender,
                required String content,
                required DateTime timestamp,
                Value<String?> category = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoachMessagesEntriesCompanion.insert(
                id: id,
                sender: sender,
                content: content,
                timestamp: timestamp,
                category: category,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CoachMessagesEntriesTable, CoachMessagesEntry>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $CoachMessagesEntriesTable,
                    CoachMessagesEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CoachMessagesEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CoachMessagesEntriesTable,
      CoachMessagesEntry,
      $$CoachMessagesEntriesTableFilterComposer,
      $$CoachMessagesEntriesTableOrderingComposer,
      $$CoachMessagesEntriesTableAnnotationComposer,
      $$CoachMessagesEntriesTableCreateCompanionBuilder,
      $$CoachMessagesEntriesTableUpdateCompanionBuilder,
      (
        CoachMessagesEntry,
        BaseReferences<
          _$AppDatabase,
          $CoachMessagesEntriesTable,
          CoachMessagesEntry
        >,
      ),
      CoachMessagesEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DailyActivityEntriesTableTableManager get dailyActivityEntries =>
      $$DailyActivityEntriesTableTableManager(_db, _db.dailyActivityEntries);
  $$SavedRoutesEntriesTableTableManager get savedRoutesEntries =>
      $$SavedRoutesEntriesTableTableManager(_db, _db.savedRoutesEntries);
  $$MigrationMetadataEntriesTableTableManager get migrationMetadataEntries =>
      $$MigrationMetadataEntriesTableTableManager(
        _db,
        _db.migrationMetadataEntries,
      );
  $$SleepRecordsEntriesTableTableManager get sleepRecordsEntries =>
      $$SleepRecordsEntriesTableTableManager(_db, _db.sleepRecordsEntries);
  $$WeeklyReportsEntriesTableTableManager get weeklyReportsEntries =>
      $$WeeklyReportsEntriesTableTableManager(_db, _db.weeklyReportsEntries);
  $$WeightRecordsEntriesTableTableManager get weightRecordsEntries =>
      $$WeightRecordsEntriesTableTableManager(_db, _db.weightRecordsEntries);
  $$CoachMessagesEntriesTableTableManager get coachMessagesEntries =>
      $$CoachMessagesEntriesTableTableManager(_db, _db.coachMessagesEntries);
}
