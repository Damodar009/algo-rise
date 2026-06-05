import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart' show Locale;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

enum Flavour { development, staging, production }

class AppLocale {
  static const Locale en = Locale("en");
  static const locales = [en];
}

bool get isIOS => Platform.isIOS;
final DateTime currentDate = DateTime.now();
final int currentMonth = currentDate.month;
final int currentYear = currentDate.year;

typedef JsonMap = Map<String, dynamic>;

void onError(e, [Function(Response dynamic)? select]) {
  if (e is DioException) {
    final res = e.response;

    final message = res != null
        ? select != null
              ? select(res)
              : res.data["error"]["error"]
        : e.message ?? e.error.toString();

    if (DioExceptionType.receiveTimeout == e.type ||
        DioExceptionType.connectionTimeout == e.type) {
      // do whateever need to do while error
    } else if (e.type == DioExceptionType.unknown) {
      if (message?.contains('SocketException')) {
        if (message?.contains('Connection reset by peer')) {
          // do whateever need to do while error
        } else {
          // do whateever need to do while error
        }
      }
    }
    return;
  }
}

Future<File> loadAssetAsFile(String path, String fileName) async {
  try {
    // Load the asset from the root bundle
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = data.buffer.asUint8List();

    // Get the temporary directory
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/$fileName');

    // Write the bytes to the file
    await file.writeAsBytes(bytes);

    return file;
  } catch (e) {
    rethrow;
  }
}
