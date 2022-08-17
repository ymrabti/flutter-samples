import 'package:flutter/foundation.dart';

void consoleLog(text, {int color = 37}) {
  debugPrint('\x1B[${color}m $text\x1B[0m');
}
