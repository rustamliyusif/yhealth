import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yhealth/core/app_info.dart';

void main() {
  test('AppInfo.version matches pubspec.yaml', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final match = RegExp(r'^version:\s*([0-9.]+)', multiLine: true).firstMatch(pubspec);
    expect(match?.group(1), AppInfo.version);
  });
}
