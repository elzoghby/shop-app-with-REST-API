import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/sreens/cart_screen.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/ product_items.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';

enum filterOptions { Favorite, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

bool filter = false;
bool spiner = false;

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  @override
  void initState() {
    setState(() {
      spiner=true;
    });
    Provider.of<Products>(context, listen: false)
        .fetchAndsetproducts()
        .then((value) {
      setState(() {
        spiner = false;
      });
    }).catchError((onError) {
      setState(() {
        spiner = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final products = !filter
        ? Provider.of<Products>(context).items
        : Provider.of<Products>(context).favoriteItem;
    return Scaffold(
      appBar: AppBar(
        title: Text('my shop'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: filterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('All Products'),
                value: filterOptions.All,
              ),
            ],
            onSelected: (filterOptions value) {
              setState(() {
                if (value == filterOptions.Favorite)
                  filter = true;
                else
                  filter = false;
              });
            },
            icon: Icon(Icons.more_vert_outlined),
          ),
          Consumer<Cart>(
            builder: (key, cart, c) => Badge(
              child: c,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.id);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: spiner
          ? Center(
              child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, i) => ChangeNotifierProvider.value(
                value: products[i],
                //  create:(context)=>products[i],v
                child: ProductItem(),
              ),
            ),
    );
  }
}
