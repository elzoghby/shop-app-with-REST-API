import 'package:flutter/material.dart';
import 'package:shop/helper/custom_route.dart';
import 'package:shop/sreens/order%20_screen.dart';
import 'package:shop/sreens/seller_products.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello user'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('shop'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/');
            },

          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('orders'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(OrdersScreen.id);
            },

          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage products'),
            onTap: (){
              Navigator.of(context).pushReplacement(CustomRoute(builder: (context)=>SellerProducts()));
            },

          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Logout'),
            onTap: (){
              Provider.of<Auth>(context, listen: false).logOut();
              Navigator.pop(context);
            },

          )
        ],
      ),
    );
  }
}
