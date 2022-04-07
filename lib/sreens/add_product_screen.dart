import 'package:flutter/material.dart';
import 'package:shop/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
   EditProductScreen({@required this.swich, this.productId});

  final bool swich;
  final String productId;
  static const id = 'addproduct';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final pricenode = FocusNode();
  final descriptionenode = FocusNode();
  final imagecotroller = TextEditingController();
  final imagenode = FocusNode();
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  String title;
  String description;
  double price;
  String imageUrl;
  bool isLoading = false;

  @override
  void initState() {
    imagenode.addListener(updateimage);
    super.initState();
  }

  @override
  void dispose() {
    imagenode.removeListener(updateimage);
    pricenode.dispose();
    descriptionenode.dispose();
    imagecotroller.dispose();
    super.dispose();
  }

  void updateimage() {
    if (!imagenode.hasFocus) setState(() {});
  }

  void getcurrent() {
    if (widget.swich) {
      final loudedproduct = Provider.of<Products>(context, listen: false)
          .findById(widget.productId);
      title = loudedproduct.title;
      price = loudedproduct.price;
      description = loudedproduct.description;
      imagecotroller.text = loudedproduct.imageUrl;
    } else
      return;
  }

  void saveform() async {
    bool vatlidate = key.currentState.validate();

    if (vatlidate) {
      key.currentState.save();
      setState(() {
        isLoading = true;
      });
      if (widget.swich) {
      await  Provider.of<Products>(context, listen: false)
            .update(widget.productId, title, description, imageUrl, price);

      } else{
        try {

          await Provider.of<Products>(context, listen: false)
              .addproduct('JHG', title, description, imageUrl, price);
        } catch (error) {

          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('ops error!!'),
              content: Text('something went wrong'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('okay'),
                ),
              ],
            ),
          );
        }
      }
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    getcurrent();
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit product'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                saveform();
              })
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent),
            )
          : Padding(
              padding: const EdgeInsets.all(14),
              child: Form(
                key: key,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      widget.swich
                          ? Center(child: Text('CURRENT PRODUCT DATA'))
                          : Center(child: Text('add new')),
                      TextFormField(
                        initialValue: widget.swich ? title : null,
                        validator: (value) {
                          if (value.isEmpty)
                            return 'required*';
                          else
                            return null;
                        },
                        onSaved: (value) {
                          title = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'title',
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      TextFormField(
                        initialValue: widget.swich ? price.toString() : null,
                        validator: (value) {
                          if (value.isEmpty)
                            return ' enter a price';
                          else if (double.tryParse(value) <= 0)
                            return 'enter  a real price';
                          else
                            return null;
                        },
                        onFieldSubmitted: (m) {
                          FocusScope.of(context).requestFocus(descriptionenode);
                        },
                        onSaved: (value) {
                          price = double.parse(value);
                        },
                        decoration: InputDecoration(
                          labelText: 'price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        initialValue: widget.swich ? description : null,
                        validator: (value) {
                          if (value.isEmpty)
                            return 'please enter a describtion';
                          if (value.length < 15)
                            return 'please describe your prodcut in detail';
                          else
                            return null;
                        },
                        onSaved: (value) {
                          description = value;
                        },
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          labelText: 'description',
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: imagecotroller.text.isEmpty
                                ? Text('Enter image url')
                                : FittedBox(
                                    child: Image.network(
                                      imagecotroller.text,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              focusNode: imagenode,
                              decoration: InputDecoration(
                                labelText: 'enter image url',
                              ),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.url,
                              controller: imagecotroller,
                              onFieldSubmitted: (value) {
                                imageUrl = value;
                                saveform();
                              },
                              onSaved: (value) {
                                imageUrl = value;
                              },
                              onEditingComplete: () {
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
