import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/models/product_listing.dart';
import 'package:shop_app/utils/show_error_dialog.dart';

class EditProductPage extends StatefulWidget {
  static const routeName = "/edit-product";

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> with ErrorDialog {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  ProductBuilder _editedProduct = ProductBuilder();
  bool _isLoading = false;
  Product routeArgs;

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) return;

    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    Product finalProduct = _editedProduct.build();

    if (routeArgs != null) {
      updateData(finalProduct);
    } else {
      saveData(finalProduct);
    }
  }

  void updateData(Product product) {
    handleError(() async {
      await Provider.of<ProductListing>(context, listen: false)
          .updateProduct(product);
    });
  }

  void saveData(Product product) {
    handleError(() async {
      await Provider.of<ProductListing>(context, listen: false)
          .addProduct(product);
    });
  }

  void handleError(Function callback) async {
    try {
      await callback();
    } catch (error) {
      showErrorDialog(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    routeArgs = ModalRoute.of(context).settings.arguments as Product;
    if (routeArgs != null) {
      _editedProduct = ProductBuilder.existing(routeArgs);
      _imageUrlController.text = _editedProduct.imageUrl;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.check,
              ),
              onPressed: saveForm)
        ],
      ),
      body: _isLoading
          ? const Center(
              child: const CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: "Title"),
                        textInputAction: TextInputAction.next,
                        initialValue: _editedProduct.title,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) return "Please provide a value";
                          return null;
                        },
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_priceFocusNode),
                        onSaved: _editedProduct.setTitle,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Price"),
                        textInputAction: TextInputAction.next,
                        initialValue: _editedProduct.price.toString(),
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode),
                        onSaved: (value) =>
                            _editedProduct.setPrice(double.parse(value)),
                        validator: (value) {
                          if (value.isEmpty) return "Please provide a value";

                          if (double.tryParse(value) == null)
                            return "Please enter a valid number";

                          if (double.parse(value) <= 0)
                            return "Please enter a positive number";

                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Description"),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        initialValue: _editedProduct.description,
                        focusNode: _descriptionFocusNode,
                        onSaved: _editedProduct.setDescription,
                        validator: (value) {
                          if (value.isEmpty) return "Please provide a value";

                          if (value.length <= 10)
                            return "Should be at least 10 characters long";

                          return null;
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(top: 8, right: 10),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: _imageUrlController.text.isEmpty
                                  ? Text("Enter an Url")
                                  : Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: "Image URL"),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                onFieldSubmitted: (_) => saveForm(),
                                onSaved: _editedProduct.setImageUrl,
                                onEditingComplete: () {
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value.isEmpty)
                                    return "Please provide a value";

                                  if (!value.startsWith("http://") &&
                                      !value.startsWith("https://"))
                                    return "Please enter a valid url";

                                  if (!value.endsWith(".png") &&
                                      !value.endsWith(".jpeg") &&
                                      !value.endsWith(".jpg"))
                                    return "Please enter a valid image URL";

                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
    );
  }
}
