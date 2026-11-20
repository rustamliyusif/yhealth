import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BMI calculation test', () {
    // Height: 180cm, Weight: 81kg -> BMI = 81 / (1.8 * 1.8) = 25.0 (Overweight boundary)
    final heightInMeters = 180 / 100.0;
    final bmi = 81.0 / (heightInMeters * heightInMeters);
    expect(bmi, closeTo(25.0, 0.01));

    // Height: 175cm, Weight: 70kg -> BMI = 70 / (1.75 * 1.75) = 22.857 (Normal)
    final normalBmi = 70.0 / (1.75 * 1.75);
    expect(normalBmi, closeTo(22.86, 0.05));
    expect(normalBmi >= 18.5 && normalBmi < 25.0, isTrue);
  });
}
