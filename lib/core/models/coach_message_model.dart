import 'package:drift/drift.dart' as drift;
import '../database/app_database.dart';

/// Domain model representing a message in the conversational Weight Coach session.
class CoachMessageModel {
  final String id;
  final String sender; // 'user' or 'coach'
  final String content;
  final DateTime timestamp;
  final String? category; // 'analysis', 'nutrition', 'hydration', 'sleep', 'activity'

  CoachMessageModel({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
    this.category,
  });

  bool get isUser => sender == 'user';
  bool get isCoach => sender == 'coach';

  factory CoachMessageModel.fromEntity(CoachMessagesEntry entity) {
    return CoachMessageModel(
      id: entity.id,
      sender: entity.sender,
      content: entity.content,
      timestamp: entity.timestamp,
      category: entity.category,
    );
  }

  CoachMessagesEntriesCompanion toCompanion() {
    return CoachMessagesEntriesCompanion(
      id: drift.Value(id),
      sender: drift.Value(sender),
      content: drift.Value(content),
      timestamp: drift.Value(timestamp),
      category: drift.Value(category),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sender': sender,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'category': category,
      };

  factory CoachMessageModel.fromJson(Map<String, dynamic> json) {
    return CoachMessageModel(
      id: json['id'] as String? ?? '',
      sender: json['sender'] as String? ?? 'user',
      content: json['content'] as String? ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
      category: json['category'] as String?,
    );
  }
}
