import 'package:flutter/material.dart';
import 'dart:math';

Color generateRandomColor() {
  final random = Random();
  final r = random.nextInt(256);
  final g = random.nextInt(256);
  final b = random.nextInt(256);
  return Color.fromRGBO(r, g, b, 1.0);
}
