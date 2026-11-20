import 'package:drift/drift.dart' as drift;
import '../database/app_database.dart';

/// Domain model representing a verified historical body weight measurement.
class WeightRecordModel {
  final String id;
  final String date; // yyyy-MM-dd
  final double weightKg;
  final double bmi;
  final String? notes;
  final DateTime createdAt;

  WeightRecordModel({
    required this.id,
    required this.date,
    required this.weightKg,
    required this.bmi,
    this.notes,
    required this.createdAt,
  });

  String get formattedWeight => '${weightKg.toStringAsFixed(1)} kg';
  String get formattedBmi => bmi.toStringAsFixed(1);

  factory WeightRecordModel.fromEntity(WeightRecordsEntry entity) {
    return WeightRecordModel(
      id: entity.id,
      date: entity.date,
      weightKg: entity.weightKg,
      bmi: entity.bmi,
      notes: entity.notes,
      createdAt: entity.createdAt,
    );
  }

  WeightRecordsEntriesCompanion toCompanion() {
    return WeightRecordsEntriesCompanion(
      id: drift.Value(id),
      date: drift.Value(date),
      weightKg: drift.Value(weightKg),
      bmi: drift.Value(bmi),
      notes: drift.Value(notes),
      createdAt: drift.Value(createdAt),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'weightKg': weightKg,
        'bmi': bmi,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
      };

  factory WeightRecordModel.fromJson(Map<String, dynamic> json) {
    return WeightRecordModel(
      id: json['id'] as String? ?? '',
      date: json['date'] as String? ?? '',
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0.0,
      bmi: (json['bmi'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
