import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool fav;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.fav = true});
  void toggleFavorite(String authToken , String userid){
    fav =!fav;
    final url = Uri.parse(
        'https://shop-540cc-default-rtdb.firebaseio.com/userFavirateStates/$userid/$id.json?auth=$authToken');
    http.put(url,
        body: jsonEncode(fav));
    notifyListeners();
  }
}
