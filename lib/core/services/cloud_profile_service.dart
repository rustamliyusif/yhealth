import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'storage_service.dart';

class CloudProfileService {
  final StorageService _storage;
  bool _ready = false;

  CloudProfileService(this._storage);

  bool get isAvailable => _ready;

  static Future<CloudProfileService> init(StorageService storage) async {
    final service = CloudProfileService(storage);
    try {
      await Firebase.initializeApp();
      service._ready = true;
    } catch (e) {
      debugPrint('CloudProfileService: Firebase unavailable: $e');
    }
    return service;
  }

  Future<void> sync() async {
    if (!_ready) return;
    try {
      final auth = FirebaseAuth.instance;
      if (!_storage.shareProfile) {
        final user = auth.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
        }
        return;
      }

      final name = _storage.userName.trim();
      if (name.isEmpty) return;

      final user = auth.currentUser ?? (await auth.signInAnonymously()).user;
      if (user == null) return;

      final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final snapshot = await ref.get();
      await ref.set({
        'fullName': name,
        'age': _storage.userAge,
        'language': _storage.languageCode,
        'updatedAt': FieldValue.serverTimestamp(),
        if (!snapshot.exists) 'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('CloudProfileService.sync: $e');
    }
  }
}
