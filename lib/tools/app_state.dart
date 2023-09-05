import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/schema/discount/discount_record.dart';
import 'package:blueraymarket/backend/schema/product/product_record.dart';
import 'package:blueraymarket/backend/schema/variant/variant_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kCart = "cart";
const String kCartSum = "cart_sum";
const String kFavorite = "favorite";
const String kRecentViewed = "recentView";

class AppState extends ChangeNotifier {
  static final _instance = AppState._internal();

  static SharedPreferences? _prefs;

  AppState._internal() {
    initialize();
  }

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();

    await _safeInitAsync(() async {
      final favoritePaths = _prefs!.getStringList(kFavorite);

      if (favoritePaths != null) {
        _favorite = favoritePaths
            .map((path) => FirebaseFirestore.instance
                .doc(path)) // Assuming you're using FirebaseFirestore
            .toList();
      } else {
        _favorite = [];
      }
    });
    await _safeInitAsync(() async {
      final cartPaths = _prefs!.getStringList(kCart);

      if (cartPaths != null) {
        cart = Map.fromEntries(cartPaths.map((path) {
          final docRef = FirebaseFirestore.instance.doc(path);
          return MapEntry<DocumentReference<Object?>, int>(
              docRef, 1); // Set initial quantity as 1
        }));
      } else {
        cart = {}; // Initialize an empty map if no cartPaths are found
      }
    });

    products = await queryProductsRecordOnce();
    discounts = await queryDiscountsRecordOnce();
    variants = await queryVariantsRecordOnce();
  }

  Future _safeInitAsync(Function() initializeField) async {
    try {
      await initializeField();
    } catch (_) {}
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

  List<DiscountRecord?> _discounts = [];
  List<DiscountRecord?> get discounts => _discounts;
  set discounts(List<DiscountRecord?> _value) => _discounts = _value;

  List<ProductRecord?> _products = [];
  List<ProductRecord?> get products => _products;
  set products(List<ProductRecord?> _value) => _products = _value;

  List<VariantRecord?> _variants = [];
  List<VariantRecord?> get variants => _variants;
  set variants(List<VariantRecord?> _value) => _variants = _value;

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

  List<DocumentReference> _recentlyViewed = [];
  List<DocumentReference> get recentlyViewed => _recentlyViewed;
  set recentlyViewed(List<DocumentReference> _value) =>
      _recentlyViewed = _value;

  void addToRecentlyViewed(DocumentReference _value) {
    _recentlyViewed.add(_value);
    prefs!.setStringList(
        kRecentViewed, _recentlyViewed.map((x) => x.path).toList());
  }

  void removeFromRecentlyViewed(DocumentReference _value) {
    _recentlyViewed.remove(_value);
    prefs!.setStringList(
        kRecentViewed, _recentlyViewed.map((x) => x.path).toList());
  }

  void removeAtIndexFromRecentlyViewed(int _index) {
    _recentlyViewed.removeAt(_index);
    prefs!.setStringList(
        kRecentViewed, _recentlyViewed.map((x) => x.path).toList());
  }

// ###### cart list

  Map<DocumentReference, int> _cart = {};
  Map<DocumentReference, int> get cart => _cart;
  set cart(Map<DocumentReference, int> _value) {
    _cart = _value;
    prefs!.setStringList(
      kCart,
      _value.entries
          .map((entry) => "${entry.key.path}:${entry.value}")
          .toList(),
    );
  }

  void deleteCart() {
    _cart.clear(); // Clear the cart map
    prefs!.remove(kCart); // Remove the cart data from shared preferences
  }

  void addToCart(DocumentReference _value, int quantity) {
    _cart.putIfAbsent(
        _value, () => quantity); // Add an item with a quantity of 1
    _updateCartInPrefs();
  }

  void removeFromCart(DocumentReference _value) {
    _cart.remove(_value); // Remove the item from the cart map
    _updateCartInPrefs();
  }

  void removeAtIndexFromCart(int _index) {
    if (_index >= 0 && _index < _cart.length) {
      _cart.remove(_cart.keys
          .elementAt(_index)); // Remove the item at the specified index
      _updateCartInPrefs();
    }
  }

  void increaseQuantity(DocumentReference itemReference) {
    if (_cart.containsKey(itemReference)) {
      _cart[itemReference] = _cart[itemReference]! + 1;
      _updateCartInPrefs();
    }
  }

  void decreaseQuantity(DocumentReference itemReference) {
    if (_cart.containsKey(itemReference) && _cart[itemReference]! > 1) {
      _cart[itemReference] = _cart[itemReference]! - 1;

      _updateCartInPrefs();
    } else if (_cart.containsKey(itemReference) && _cart[itemReference]! == 1) {
      removeFromCart(itemReference);
    }
  }

  void _updateCartInPrefs() {
    prefs!.setStringList(
      kCart,
      _cart.entries.map((entry) => "${entry.key.path}:${entry.value}").toList(),
    );
  }

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
