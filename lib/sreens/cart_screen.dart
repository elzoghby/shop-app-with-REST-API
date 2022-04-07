

import 'package:provider/provider.dart';
import 'package:shop/sreens/order%20_screen.dart';
import '../providers/cart.dart' show Cart;
import 'package:flutter/material.dart';
import '../widgets/cart_item.dart';
import '../providers/order.dart';

class CartScreen extends StatelessWidget {
  static String id = 'cartid';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItem = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Your card'),
      ),
      body: Column(
        children: [
          Card(
            shadowColor: Colors.black,
            elevation: 4,
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.total.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, i) => CartItem(
                cartItem[i].id,
                cart.items.keys.toList()[i],
                cartItem[i].title,
                cartItem[i].quantity,
                cartItem[i].price),
            itemCount: cart.itemCount,
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}
bool spiner =false;
class _OrderButtonState extends State<OrderButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: ()async {
          setState(() {
            spiner= true;
          });
          if (widget.cart.total != 0) {
          await Provider.of<Orders>(context, listen: false)
                .addOrder(widget.cart.items.values.toList(), widget.cart.total);
            widget.cart.clear();
            Navigator.pushNamed(context, OrdersScreen.id);
          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: new Text("The cart is empty",style: TextStyle(fontSize: 30),),

            ));
          }
          setState(() {
            spiner= false;
          });
        },
        child: spiner?Center(
          child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent),
        ):Text('Check out'));
  }
}
