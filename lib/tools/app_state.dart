import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/schema/color/color_record.dart';
import 'package:blueraymarket/backend/schema/discount/discount_record.dart';
import 'package:blueraymarket/backend/schema/product/product_record.dart';
import 'package:blueraymarket/backend/schema/size/size_record.dart';
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
        // Initialize an empty cart with products and variants
        cart = {};

        // Loop through the stored paths and parse them into product and variant references
        for (String path in cartPaths) {
          final docRef = FirebaseFirestore.instance.doc(path);
          final List<String> parts = path.split(':');
          if (parts.length == 2) {
            final productRef = FirebaseFirestore.instance.doc(parts[0]);
            final variantRef = FirebaseFirestore.instance.doc(parts[1]);

            // Add the product and variant to the cart with an initial quantity of 1
            addToCart(productRef, variantRef, 1);
          }
        }
      } else {
        cart = {}; // Initialize an empty map if no cartPaths are found
      }
    });

    products = await queryProductsRecordOnce();
    discounts = await queryDiscountsRecordOnce();
    variants = await queryVariantsRecordOnce();
    colors = await queryColorsRecordOnce();
    sizes = await querySizesRecordOnce();
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

  List<ColorRecord?> _colors = [];
  List<ColorRecord?> get colors => _colors;
  set colors(List<ColorRecord?> _value) => _colors = _value;

  List<SizeRecord?> _sizes = [];
  List<SizeRecord?> get sizes => _sizes;
  set sizes(List<SizeRecord?> _value) => _sizes = _value;

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
  Map<DocumentReference, Map<DocumentReference, int>> _cart = {};
  Map<DocumentReference, Map<DocumentReference, int>> get cart => _cart;

  set cart(Map<DocumentReference, Map<DocumentReference, int>> _value) {
    _cart = _value;
    prefs!.setStringList(
      kCart,
      _value.entries.map((entry) {
        var productPath = entry.key.path;
        var variantQuantities = entry.value.entries
            .map((variantEntry) =>
                "${variantEntry.key.path}:${variantEntry.value}")
            .join(',');
        return "$productPath:{$variantQuantities}";
      }).toList(),
    );
  }

  void deleteCart() {
    _cart.clear(); // Clear the cart map
    prefs!.remove(kCart); // Remove the cart data from shared preferences
  }

  void addToCart(DocumentReference productReference,
      DocumentReference variantReference, int quantity) {
    _cart.putIfAbsent(
      productReference,
      () => {variantReference: quantity},
    ); // Add an item with the product and variant references along with quantity
    _updateCartInPrefs();
  }

  void removeFromCart(DocumentReference productReference) {
    if (_cart.containsKey(productReference)) {
      _cart.remove(productReference);

      _updateCartInPrefs();
    }
  }

  void increaseQuantity(
      DocumentReference productReference, DocumentReference variantReference) {
    if (_cart.containsKey(productReference)) {
      var productCart = _cart[productReference];
      if (productCart!.containsKey(variantReference)) {
        productCart[variantReference] = productCart[variantReference]! + 1;
        _updateCartInPrefs();
      }
    }
  }

  void decreaseQuantity(
      DocumentReference productReference, DocumentReference variantReference) {
    if (_cart.containsKey(productReference)) {
      var productCart = _cart[productReference];
      if (productCart!.containsKey(variantReference)) {
        if (productCart[variantReference]! > 1) {
          productCart[variantReference] = productCart[variantReference]! - 1;
          _updateCartInPrefs();
        } else if (productCart[variantReference]! == 1) {
          removeFromCart(productReference);
        }
      }
    }
  }

  void _updateCartInPrefs() {
    prefs!.setStringList(
      kCart,
      _cart.entries.map((entry) {
        var productPath = entry.key.path;
        var variantQuantities = entry.value.entries
            .map((variantEntry) =>
                "${variantEntry.key.path}:${variantEntry.value}")
            .join(',');
        return "$productPath:{$variantQuantities}";
      }).toList(),
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
