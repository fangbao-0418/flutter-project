import 'package:flutter/material.dart';
class Global {
  static BuildContext _context;
  static BuildContext get context => _context;
  static set context (dynamic c) {
    _context = c;
  }
}