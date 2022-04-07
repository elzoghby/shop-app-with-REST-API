import '../widgets/app_drawer.dart';

import 'package:flutter/material.dart';
import '../providers/order.dart' show Orders;
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static String id = 'orderid';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final order = Provider
    //     .of<Orders>(context)
    //     .orders;
    return Scaffold(
      appBar: AppBar(
        title: Text('your order'),

      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrders(),
        builder: (context, datasnapshot) {
          if( datasnapshot.connectionState==ConnectionState.waiting){
            return  Center(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent));}
          else if(datasnapshot.hasError)
            return Text('an error occured');
          else
            return  Consumer<Orders>( builder: (c , order  , child)=>ListView.builder(itemBuilder: (context, i) => OrderItem(order.orders[i]),
              itemCount: order.orders.length,),
            );
        },),

    );
  }
}