/// Clean model representing a sleep record in YHealth.
class SleepRecordModel {
  final String id;
  final String date; // "YYYY-MM-DD"
  final DateTime bedtime;
  final DateTime wakeTime;
  final int durationMinutes;
  final String source; // 'manual', 'health_connect', 'estimated'
  final int efficiencyPercent;
  final String? notes;

  // Genuine sleep stages (never fabricated)
  final bool hasStages;
  final int? lightSleepMinutes;
  final int? deepSleepMinutes;
  final int? remSleepMinutes;
  final int? awakeMinutes;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SleepRecordModel({
    required this.id,
    required this.date,
    required this.bedtime,
    required this.wakeTime,
    required this.durationMinutes,
    this.source = 'manual',
    this.efficiencyPercent = 85,
    this.notes,
    this.hasStages = false,
    this.lightSleepMinutes,
    this.deepSleepMinutes,
    this.remSleepMinutes,
    this.awakeMinutes,
    this.createdAt,
    this.updatedAt,
  });

  double get durationHours => durationMinutes / 60.0;
  String get formattedDuration => '${durationMinutes ~/ 60}h ${durationMinutes % 60}m';
  bool get isOvernight => bedtime.day != wakeTime.day || bedtime.month != wakeTime.month;
  bool get isManual => source == 'manual';
  bool get isHealthConnect => source == 'health_connect';

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'bedtime': bedtime.toIso8601String(),
        'wakeTime': wakeTime.toIso8601String(),
        'durationMinutes': durationMinutes,
        'source': source,
        'efficiencyPercent': efficiencyPercent,
        'notes': notes,
        'hasStages': hasStages,
        'lightSleepMinutes': lightSleepMinutes,
        'deepSleepMinutes': deepSleepMinutes,
        'remSleepMinutes': remSleepMinutes,
        'awakeMinutes': awakeMinutes,
      };

  factory SleepRecordModel.fromJson(Map<String, dynamic> json) {
    return SleepRecordModel(
      id: json['id'] as String,
      date: json['date'] as String,
      bedtime: DateTime.parse(json['bedtime'] as String),
      wakeTime: DateTime.parse(json['wakeTime'] as String),
      durationMinutes: json['durationMinutes'] as int,
      source: (json['source'] as String?) ?? 'manual',
      efficiencyPercent: (json['efficiencyPercent'] as int?) ?? 85,
      notes: json['notes'] as String?,
      hasStages: (json['hasStages'] as bool?) ?? false,
      lightSleepMinutes: json['lightSleepMinutes'] as int?,
      deepSleepMinutes: json['deepSleepMinutes'] as int?,
      remSleepMinutes: json['remSleepMinutes'] as int?,
      awakeMinutes: json['awakeMinutes'] as int?,
    );
  }

  SleepRecordModel copyWith({
    String? id,
    String? date,
    DateTime? bedtime,
    DateTime? wakeTime,
    int? durationMinutes,
    String? source,
    int? efficiencyPercent,
    String? notes,
    bool? hasStages,
    int? lightSleepMinutes,
    int? deepSleepMinutes,
    int? remSleepMinutes,
    int? awakeMinutes,
  }) {
    return SleepRecordModel(
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
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
