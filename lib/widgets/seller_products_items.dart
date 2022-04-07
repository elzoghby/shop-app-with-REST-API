import 'package:flutter/material.dart';
import '../sreens/add_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
class SellerProductItem extends StatelessWidget {
final String title;
final String imageUrl;
final String id;

SellerProductItem(this.title,this.imageUrl,this.id);
  @override
  Widget build(BuildContext context) {
    final scafold=   ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage:NetworkImage(imageUrl),),
      trailing: Container(
        width: 100,
        height: 100,
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.edit), onPressed:(){ Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProductScreen(
                      swich: true,productId: id,
                    )));}),
            IconButton(icon: Icon(Icons.delete), onPressed:(){showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Are you sure?'),
                  content:
                  Text('Do you want to remove this product?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('No')),
                    TextButton(
                        onPressed: () async{
                          try {
                           await Provider.of<Products>(context, listen: false)
                                .removeProduct(id);
                          }catch(_){
                         scafold.showSnackBar(SnackBar(content: Text('deleting failed',textAlign: TextAlign.center,),



                         ));
                          }
                          Navigator.of(context).pop();

                        },
                        child: Text('Yes')),
                  ],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ));

            })
          ],
        ),
      ),
    );
  }
}
