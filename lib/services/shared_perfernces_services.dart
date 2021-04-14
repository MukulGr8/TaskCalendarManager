import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class SharedPrefrenceService {
  static SharedPreferences sharedPreferences;

  static initPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    print("HELLO");
  }

  //counter for the
  set notifyIdCount(int val) {
    sharedPreferences.setInt("notifyIdCount", val);
  }

  int get notifyIdCount {
    return sharedPreferences.getInt("notifyIdCount") ?? 0;
  }
}
