import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kRemember = "remember";

class AppState extends ChangeNotifier {
  static final _instance = AppState._internal();

  static SharedPreferences? _prefs;

  AppState._internal();

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  factory AppState() {
    return _instance;
  }

  SharedPreferences? get prefs {
    if (_prefs == null) {
      throw Exception("SharedPreferencesManager is not initialized");
    }
    return _prefs;
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  // Add your custom getter and setter methods here

  // Example getter method
  List<String>? get remember {
    return prefs?.getStringList("remember");
  }

  // Example setter method
  set remember(List<String>? list) {
    prefs?.setStringList("remember", list!);
  }
}
