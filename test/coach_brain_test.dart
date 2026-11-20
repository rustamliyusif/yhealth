import 'package:flutter_test/flutter_test.dart';
import 'package:yhealth/core/services/weight_coach_engine.dart';

void main() {
  final analysis = WeightCoachEngine.analyzeProfile(
    currentWeight: 80.0,
    targetWeight: 72.0,
    heightCm: 178.0,
    age: 30,
  );

  CoachIntent intentOf(String q, {CoachIntent? previous}) =>
      CoachBrain.detectIntent(q, previousIntent: previous);

  group('Coach Leo intent detection', () {
    test('Short Azerbaijani words no longer trigger the wrong topic', () {
      expect(intentOf('Bir sualım var'), isNot(CoachIntent.hydration));
      expect(intentOf('Nə qədər su içməliyəm?'), CoachIntent.hydration);
      expect(intentOf('Suyu nə vaxt içim?'), CoachIntent.hydration);
    });

    test('Recognizes the quick prompts in both languages', () {
      expect(intentOf('Tərəqqimi təhlil et'), CoachIntent.progress);
      expect(intentOf('Gündə neçə addım atmalıyam?'), CoachIntent.steps);
      expect(intentOf('Yuxu çəkiyə necə təsir edir?'), CoachIntent.sleep);
      expect(intentOf('Çəkim dayanıb (plato)'), CoachIntent.plateau);
      expect(intentOf('Bu gün necəyəm?'), CoachIntent.today);
      expect(intentOf('Bu həftə necə keçdi?'), CoachIntent.week);
      expect(intentOf('Hədəfə nə vaxt çatacam?'), CoachIntent.timeline);
      expect(intentOf('Nə qədər protein lazımdır?'), CoachIntent.protein);
      expect(intentOf('How much protein do I need?'), CoachIntent.protein);
      expect(intentOf('When will I reach my goal?'), CoachIntent.timeline);
      expect(intentOf('I hit a weight plateau'), CoachIntent.plateau);
    });

    test('Covers new topics', () {
      expect(intentOf('Şirniyyat yeməyi necə azaldım?'), CoachIntent.sugar);
      expect(intentOf('Can I drink beer?'), CoachIntent.alcohol);
      expect(intentOf('16:8 oruc faydalıdır?'), CoachIntent.fasting);
      expect(intentOf('Qaçışa necə başlayım?'), CoachIntent.cardio);
      expect(intentOf('Motivasiyam yoxdur'), CoachIntent.motivation);
      expect(intentOf('Salam'), CoachIntent.greeting);
      expect(intentOf('asdfgh'), CoachIntent.unknown);
    });

    test('Safety topics take priority', () {
      expect(intentOf('Arıqlamaq üçün qusmaq olar?'), CoachIntent.eatingConcern);
      expect(intentOf('Gündə 600 kalori yesəm?'), CoachIntent.eatingConcern);
      expect(intentOf('Diabetim var, nə yeyim?'), CoachIntent.medical);
    });

    test('Follow-up questions continue the previous topic', () {
      expect(intentOf('daha ətraflı', previous: CoachIntent.nutrition), CoachIntent.followUp);
      final reply = CoachBrain.respond(
        query: 'daha ətraflı',
        analysis: analysis,
        isAzerbaijani: true,
        previousIntent: CoachIntent.nutrition,
      );
      expect(reply.intent, CoachIntent.nutrition);
      expect(reply.text, contains('Protein'));
    });
  });

  group('Coach Leo uses real data', () {
    test('Step answers include the user\'s weekly average', () {
      final reply = CoachBrain.respond(
        query: 'Gündə neçə addım atmalıyam?',
        analysis: analysis,
        isAzerbaijani: true,
        context: const CoachContext(todaySteps: 4200, goalSteps: 8000, daysTracked7d: 7, avgSteps7d: 5300, goalHits7d: 1),
      );
      expect(reply.text, contains('5300'));
      expect(reply.text, contains('4200'));
    });

    test('Sleep answers flag short sleep', () {
      final reply = CoachBrain.respond(
        query: 'How is my sleep?',
        analysis: analysis,
        isAzerbaijani: false,
        context: const CoachContext(sleepNights7d: 5, avgSleepMinutes7d: 360),
      );
      expect(reply.text, contains('6h 0m'));
      expect(reply.text, contains('below the recommended 7 hours'));
    });

    test('Eating-concern replies never include calorie numbers', () {
      final reply = CoachBrain.respond(
        query: 'I want to stop eating to lose weight fast',
        analysis: analysis,
        isAzerbaijani: false,
      );
      expect(reply.intent, CoachIntent.eatingConcern);
      expect(RegExp(r'\d').hasMatch(reply.text), isFalse);
    });
  });
}
