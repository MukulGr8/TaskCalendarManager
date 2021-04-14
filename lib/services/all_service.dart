import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AllServices {
  Map<DateTime, List<dynamic>> eventsMap = new Map();
}
