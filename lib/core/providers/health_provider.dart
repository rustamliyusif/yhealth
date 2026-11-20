import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

enum BmiCategory {
  underweight,
  normal,
  overweight,
  obese,
}

class HealthProvider extends ChangeNotifier {
  final StorageService _storageService;

  double _height; // cm
  double _weight; // kg

  HealthProvider(this._storageService)
      : _height = _storageService.userHeight,
        _weight = _storageService.userWeight;

  double get height => _height;
  double get weight => _weight;

  double get bmi {
    if (_height <= 0) return 0.0;
    final heightInMeters = _height / 100.0;
    return _weight / (heightInMeters * heightInMeters);
  }

  BmiCategory get category {
    final value = bmi;
    if (value < 18.5) {
      return BmiCategory.underweight;
    } else if (value < 25.0) {
      return BmiCategory.normal;
    } else if (value < 30.0) {
      return BmiCategory.overweight;
    } else {
      return BmiCategory.obese;
    }
  }

  double get minHealthyWeight {
    final heightInMeters = _height / 100.0;
    return 18.5 * (heightInMeters * heightInMeters);
  }

  double get maxHealthyWeight {
    final heightInMeters = _height / 100.0;
    return 24.9 * (heightInMeters * heightInMeters);
  }

  /// Normalized value from 0.0 to 1.0 for a visual gauge (scale 15 to 35)
  double get gaugeProgress {
    final current = bmi;
    return ((current - 15.0) / 20.0).clamp(0.02, 0.98);
  }

  Future<void> updateValues(double newHeight, double newWeight) async {
    _height = newHeight.clamp(50.0, 260.0);
    _weight = newWeight.clamp(20.0, 300.0);
    await _storageService.setUserHeight(_height);
    await _storageService.setUserWeight(_weight);
    notifyListeners();
  }
}
