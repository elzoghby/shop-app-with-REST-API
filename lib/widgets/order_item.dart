import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/providers/order.dart' as ad;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ad.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool expand = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: expand?min(widget.order.products.length * 20.0 + 1170, 200):95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(expand ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    expand = !expand;
                  });
                },
              ),
            ),

              AnimatedContainer(
                duration: Duration(milliseconds: 300),


                padding: EdgeInsets.symmetric(horizontal: 15 ,vertical: 4),
                height: expand? min(widget.order.products.length * 20.0 + 10, 100):0,
                child: ListView(
                  children: widget.order.products
                      .map(
                        (pro) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              pro.title,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text('${pro.quantity}x \$${pro.price}', style: TextStyle(fontSize: 18 ,color: Colors.grey),)
                          ],
                        ),
                      )
                      .toList(),
                ),
              )
          ],
        ),
      ),
    );
  }
}
