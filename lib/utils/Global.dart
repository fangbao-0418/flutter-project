import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Global {
  static BuildContext _context;
  static BuildContext get context => _context;
  static set context(dynamic c) {
    _context = c;
  }

  static bool get isDebugger => kDebugMode;
  static bool get isRelease => kReleaseMode;
}
