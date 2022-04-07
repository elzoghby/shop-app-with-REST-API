import 'package:flutter/material.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/seller_products_items.dart';
import '../sreens/add_product_screen.dart';

class SellerProducts extends StatelessWidget {
  static const id = 'sellerpro';

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndsetproducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProductScreen(
                            swich: false,
                          )));
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refresh(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.redAccent
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refresh(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer<Products>(
                        builder: (context, product, child) => ListView.builder(
                            itemCount: product.items.length,
                            itemBuilder: (context, i) => SellerProductItem(
                                  product.items[i].title,
                                  product.items[i].imageUrl,
                                  product.items[i].id,
                                )),
                      ),
                    ),
                  ),
      ),
      drawer: AppDrawer(),
    );
  }
}
