import 'package:drift/drift.dart';

/// Drift table storing conversational coaching chat messages between user and AI Weight Coach.
class CoachMessagesEntries extends Table {
  /// Unique identifier for the message
  TextColumn get id => text()();

  /// Sender identifier: 'user' or 'coach'
  TextColumn get sender => text()();

  /// Message content body
  TextColumn get content => text()();

  /// Message timestamp
  DateTimeColumn get timestamp => dateTime()();

  /// Optional message topic category (e.g. 'analysis', 'nutrition', 'hydration', 'sleep', 'activity')
  TextColumn get category => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
