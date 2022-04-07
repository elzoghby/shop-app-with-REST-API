import 'package:flutter/material.dart';
import '../models/products.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [];

  //[
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];
  final String authToken;

  final String userId;

  Products(this.authToken, this.userId, this._items);

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItem {
    return _items.where((element) => element.fav).toList();
  }

  Future<void> fetchAndsetproducts([bool filterbyseller = false]) async {
    var urlsec = filterbyseller? 'orderBy="creatorId"&equalTo="$userId"':'';

    var url = Uri.parse(
        'https://shop-540cc-default-rtdb.firebaseio.com/products.json?auth=$authToken&$urlsec');
    try {
      final response = await http.get(url);
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      url = Uri.parse(
          'https://shop-540cc-default-rtdb.firebaseio.com/userFavirateStates/$userId.json?auth=$authToken');
      final favResponse = await http.get(url);
      final favData = jsonDecode(favResponse.body);
      final List<Product> loaded = [];
      extractedData.forEach((prodid, proddata) {
        loaded.add(
          Product(
            id: prodid,
            title: proddata['title'],
            description: proddata['description'],
            price: proddata['price'],
            imageUrl: proddata['imageUrl'],
            fav: favData == null ? false : favData[prodid] ?? false,
          ),
        );
      });
      _items = loaded;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addproduct(String id, String title, String description,
      String imageUrl, double price) async {
    if (_items.any((element) => element.title.contains(title))) {
      Fluttertoast.showToast(
          msg: "Product already added ",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      final url = Uri.parse(
          'https://shop-540cc-default-rtdb.firebaseio.com/products.json?auth=$authToken');
      try {
        final response = await http.post(url,
            body: jsonEncode({
              'title': title,
              'description': description,
              'imageUrl': imageUrl,
              'price': price,
              'fav': false,
              'creatorId':userId,
            }));
        _items.add(Product(
            id: jsonDecode(response.body)['name'],
            title: title,
            description: description,
            price: price,
            imageUrl: imageUrl));
      } catch (error) {
        throw error;
      }
    }

    notifyListeners();
  }

  Future<void> update(String id, String title, String description,
      String imageUrl, double price) async {
    if (_items.any((element) => element.id.contains(id))) {
      final productIndex = _items.indexWhere((element) => element.id == id);
      final url = Uri.parse(
          'https://shop-540cc-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: jsonEncode({
            'title': title,
            'description': description,
            'imageUrl': imageUrl,
            'price': price,
          }));
      _items[productIndex] = new Product(
          id: id,
          title: title,
          description: description,
          price: price,
          imageUrl: imageUrl);
      Fluttertoast.showToast(
          msg: "Product was updated successfully ",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    notifyListeners();
  }

  Future<void> removeProduct(String id) async {
    final url = Uri.parse(
        'https://shop-540cc-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final productIndex = _items.indexWhere((element) => element.id == id);
    var product = _items[productIndex];

    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(productIndex, product);
      notifyListeners();
      throw 'JHGFD';
    } else
      product = null;
  }
}
