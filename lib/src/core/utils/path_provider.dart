import 'package:path_provider/path_provider.dart' as path_provider;

class AppPathProvider {
  AppPathProvider._();

  static String? _path;

  static String get path {
    if (_path != null) {
      return _path!;
    } else {
      throw Exception('path not initialized');
    }
  }

  static Future<void> initPath() async {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    _path = dir.path;
  }
}
