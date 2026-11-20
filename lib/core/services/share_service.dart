import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ShareService {
  static const MethodChannel _channel = MethodChannel('com.rustamliyusif.yhealth/share');

  static Future<bool> sharePdf(String path, {String title = ''}) async {
    try {
      final shared = await _channel.invokeMethod<bool>('shareFile', {
        'path': path,
        'mimeType': 'application/pdf',
        'title': title,
      });
      return shared ?? false;
    } catch (e) {
      debugPrint('ShareService.sharePdf error: $e');
      return false;
    }
  }
}
