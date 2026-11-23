import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yhealth/core/providers/water_provider.dart';
import 'package:yhealth/core/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Water intake adds, subtracts, persists and resets per day', () async {
    SharedPreferences.setMockInitialValues({'user_weight': 70.0});
    final storage = await StorageService.init();
    var now = DateTime(2026, 11, 24, 9);
    final water = WaterProvider(storage, clock: () => now);

    expect(water.todayMl, 0);
    expect(water.goalMl, 2300);

    await water.add(250);
    await water.add(500);
    expect(water.todayMl, 750);

    await water.add(-1000);
    expect(water.todayMl, 0);

    await water.add(250);
    expect(WaterProvider(storage, clock: () => now).todayMl, 250);

    now = DateTime(2026, 11, 25, 8);
    expect(water.todayMl, 0);
    expect(water.lastDays(2), [250, 0]);
  });

  test('Custom water goal overrides weight-based recommendation', () async {
    SharedPreferences.setMockInitialValues({'user_weight': 90.0});
    final storage = await StorageService.init();
    final water = WaterProvider(storage);

    expect(water.goalMl, 2950);
    await water.setGoal(2000);
    expect(water.goalMl, 2000);
    expect(water.recommendedGoalMl, 2950);

    await water.add(2000);
    expect(water.goalReached, isTrue);
  });
}
