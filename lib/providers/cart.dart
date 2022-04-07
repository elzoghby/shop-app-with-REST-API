import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(String productid, String title, double price) {
    if (_items.containsKey(productid)) {
      _items.update(
          productid,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              quantity: value.quantity + 1,
              price: value.price));
    } else
      _items.putIfAbsent(
          productid,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    notifyListeners();
  }

  double get total {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  int get itemCount {
    return _items.length;
  }

  Future<void> removeItem(String key) async {
    _items.remove(key);
    notifyListeners();
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final File image = (await _picker.pickImage(source: ImageSource.gallery)) as File;
  }

  void removeSingleItem(String key) {
    if (!_items.containsKey(key)) return;
    if (_items[key].quantity > 1) {
      _items.update(
          key,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              quantity: value.quantity - 1,
              price: value.price));
    }
    else
      _items.remove(key);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
