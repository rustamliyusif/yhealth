import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yhealth/core/providers/reminder_provider.dart';
import 'package:yhealth/core/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Reminder settings default on with 22:00-08:00 quiet hours and persist', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = await StorageService.init();
    final reminders = ReminderProvider(storage);

    expect(reminders.water, isTrue);
    expect(reminders.move, isTrue);
    expect(ReminderProvider.formatMinutes(reminders.quietStart), '22:00');
    expect(ReminderProvider.formatMinutes(reminders.quietEnd), '08:00');

    await reminders.setQuietStart(23 * 60 + 30);
    await storage.setReminderMove(false);

    final reloaded = ReminderProvider(await StorageService.init());
    expect(ReminderProvider.formatMinutes(reloaded.quietStart), '23:30');
    expect(reloaded.move, isFalse);
    expect(StorageService.backupPreferenceKeys, containsAll(['reminder_water', 'quiet_end']));
  });
}
