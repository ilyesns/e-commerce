import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kCart = "cart";
const String kCartSum = "cart_sum";
const String kFavorite = "favorite";

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

// ###### favorite list
  List<DocumentReference> _favorite = [];
  List<DocumentReference> get favorite => _favorite;
  set favorite(List<DocumentReference> _value) {
    _favorite = _value;
    prefs!.setStringList(kFavorite, _value.map((x) => x.path).toList());
  }

  void deleteFavorite() {
    prefs!.setStringList(kFavorite, []);
  }

  void addToFavorite(DocumentReference _value) {
    _favorite.add(_value);
    prefs!.setStringList(kFavorite, _favorite.map((x) => x.path).toList());
  }

  void removeFromFavorite(DocumentReference _value) {
    _favorite.remove(_value);
    prefs!.setStringList(kFavorite, _favorite.map((x) => x.path).toList());
  }

  void removeAtIndexFromFavorite(int _index) {
    _favorite.removeAt(_index);
    prefs!.setStringList(kFavorite, _favorite.map((x) => x.path).toList());
  }

  List<DocumentReference> _RecentlyViewed = [];
  List<DocumentReference> get RecentlyViewed => _RecentlyViewed;
  set RecentlyViewed(List<DocumentReference> _value) {
    _RecentlyViewed = _value;
  }

  void addToRecentlyViewed(DocumentReference _value) {
    _RecentlyViewed.add(_value);
  }

  void removeFromRecentlyViewed(DocumentReference _value) {
    _RecentlyViewed.remove(_value);
  }

  void removeAtIndexFromRecentlyViewed(int _index) {
    _RecentlyViewed.removeAt(_index);
  }

// ###### cart list

  List<DocumentReference> _cart = [];
  List<DocumentReference> get cart => _cart;
  set cart(List<DocumentReference> _value) {
    _cart = _value;
    prefs!.setStringList(kCart, _value.map((x) => x.path).toList());
  }

  void deleteCart() {
    prefs!.setStringList(kCart, []);
  }

  void addToCart(DocumentReference _value) {
    _cart.add(_value);
    prefs!.setStringList(kCart, _cart.map((x) => x.path).toList());
  }

  void removeFromCart(DocumentReference _value) {
    _cart.remove(_value);
    prefs!.setStringList(kCart, _cart.map((x) => x.path).toList());
  }

  void removeAtIndexFromCart(int _index) {
    _cart.removeAt(_index);
    prefs!.setStringList(kCart, _cart.map((x) => x.path).toList());
  }
// ###### cart sum

  double _cartsum = 0;
  double get cartsum => _cartsum;
  set cartsum(double _value) {
    _cartsum = _value;
    prefs!.setDouble(kCartSum, _value);
  }

  void deleteCartsum() {
    prefs!.setDouble(kCartSum, 0.0);
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }
}
