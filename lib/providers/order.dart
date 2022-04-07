import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/sreens/add_product_screen.dart';
import './cart.dart';
import 'package:http/http.dart' as http;

class OrderItem with ChangeNotifier {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  Orders(this._orders , this.authToken,this.userId);
  final authToken;
  final userId;
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        Uri.parse('https://shop-540cc-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final time = DateTime.now();
    try {
      final response = await http.post(url,
          body: jsonEncode({
            'amount': total,
            'products': cartProducts
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'price': e.price,
                      'quantity': e.quantity
                    })
                .toList(),
            'dateTime': time.toIso8601String(),
          }));

      _orders.add(OrderItem(
        id: jsonDecode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: time,
      ));
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final url =
        Uri.parse('https://shop-540cc-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final exorders = jsonDecode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loaded = [];
      if (exorders == null) return;
      exorders.forEach((orderid, orderdata) {
        loaded.add(OrderItem(
            id: orderid,
            amount: orderdata['amount'],
            products: (orderdata['products'] as List<dynamic>)
                .map((item) => CartItem(
                      id: item['id'],
                      title: item['title'],
                      quantity: item['quantity'],
                      price: item['price'],
                    ))
                .toList(),
            dateTime: DateTime.parse(orderdata['dateTime']  )));
      });
      _orders = loaded;
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }
}
