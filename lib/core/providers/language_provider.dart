import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class LanguageProvider extends ChangeNotifier {
  final StorageService _storageService;
  late Locale _locale;
  bool _hasSelectedInitialLanguage = false;

  LanguageProvider(this._storageService) {
    _initLocale();
  }

  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;
  bool get isAzerbaijani => _locale.languageCode == 'az';
  bool get hasSelectedInitialLanguage => _hasSelectedInitialLanguage;

  void _initLocale() {
    _hasSelectedInitialLanguage = _storageService.hasSelectedLanguage;
    final savedCode = _storageService.languageCode;
    // Azerbaijani is default as required
    if (savedCode == 'en') {
      _locale = const Locale('en');
    } else {
      _locale = const Locale('az');
    }
  }

  Future<void> setLanguage(String languageCode) async {
    if (languageCode != 'az' && languageCode != 'en') return;
    _locale = Locale(languageCode);
    await _storageService.setLanguageCode(languageCode);
    await _storageService.setHasSelectedLanguage(true);
    _hasSelectedInitialLanguage = true;
    notifyListeners();
  }

  Future<void> completeInitialLanguageSelection(String languageCode) async {
    await setLanguage(languageCode);
  }
}
