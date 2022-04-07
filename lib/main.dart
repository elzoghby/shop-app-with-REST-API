import 'package:flutter/material.dart';
import './providers/auth.dart';
import './providers/order.dart';
import './sreens/seller_products.dart';
import './sreens/product_overview_screen.dart';
import 'package:provider/provider.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './sreens/cart_screen.dart';
import './sreens/order _screen.dart';
import './sreens/add_product_screen.dart';
import './sreens/auth_screen.dart';
import './sreens/splash_screen.dart';
import './helper/custom_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Auth>(create: (context) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products(null, null, []),
            update: (context, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items),
          ),
          ChangeNotifierProvider<Cart>(create: (context) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) => Orders([], null, null),
            update: (context, auth, prev) =>
                Orders(prev.orders, auth.token, auth.userId),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, c) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android:CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              }),
                primarySwatch: Colors.purple, accentColor: Colors.tealAccent),
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            routes: {
              CartScreen.id: (context) => CartScreen(),
              OrdersScreen.id: (context) => OrdersScreen(),
              SellerProducts.id: (context) => SellerProducts(),
              EditProductScreen.id: (context) => EditProductScreen()
            },
          ),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: Text('Let\'s build a shop!'),
      ),
    );
  }
}
