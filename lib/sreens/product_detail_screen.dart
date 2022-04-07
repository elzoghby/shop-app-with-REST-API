
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductDetail extends StatelessWidget {
  String id;

  ProductDetail(this.id);

  @override
  Widget build(BuildContext context) {
    final loudedproduct =
        Provider.of<Products>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(loudedproduct.title),
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            child: Hero(

              tag: loudedproduct.id,
              child: Image.network(
                loudedproduct.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            width: double.infinity,
          ),
          SizedBox(height: 15),
          Text(
            '\$${loudedproduct.price}',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          SizedBox(height: 15),
          Container(width: double.infinity,
            padding:  EdgeInsets.symmetric(horizontal: 10),
            child:  Text(loudedproduct.description, textAlign: TextAlign.center,softWrap: true,),)

        ],
      ),
    );
  }
}
