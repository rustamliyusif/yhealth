import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ShareService {
  static const MethodChannel _channel = MethodChannel('com.rustamliyusif.yhealth/share');

  static Future<bool> sharePdf(String path, {String title = ''}) =>
      shareFile(path, mimeType: 'application/pdf', title: title);

  static Future<bool> shareFile(String path, {required String mimeType, String title = ''}) async {
    try {
      final shared = await _channel.invokeMethod<bool>('shareFile', {
        'path': path,
        'mimeType': mimeType,
        'title': title,
      });
      return shared ?? false;
    } catch (e) {
      debugPrint('ShareService.shareFile error: $e');
      return false;
    }
  }

  static Future<String?> pickFile() async {
    try {
      return await _channel.invokeMethod<String>('pickFile');
    } catch (e) {
      debugPrint('ShareService.pickFile error: $e');
      return null;
    }
  }
}
