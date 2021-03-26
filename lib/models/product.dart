import 'package:flutter/foundation.dart';
import 'package:shop_app/http/product_listing_handler.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false});

  Future<void> toggleFavouriteStatus() async {
    isFavourite = !isFavourite;
    try {
      await ProductListingHTTPHandler(resourceId: id, body: toJSON)
          .updateProduct();
    } catch (error) {
      isFavourite = !isFavourite;
      throw error;
    }
    notifyListeners();
  }

  get toJSON => {
        "title": this.title,
        "description": this.description,
        "price": this.price,
        "imageUrl": this.imageUrl,
        "isFavourite": this.isFavourite,
      };

  @override
  String toString() {
    return "Id: $id, title: $title, price: $price, ImageUrl: $imageUrl";
  }
}

class ProductBuilder {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavourite;

  ProductBuilder() {
    title = "";
    description = "";
    price = 0;
    imageUrl = "";
    isFavourite = false;
  }

  ProductBuilder.existing(Product product) {
    id = product.id;
    title = product.title;
    description = product.description;
    price = product.price;
    imageUrl = product.imageUrl;
    isFavourite = product.isFavourite;
  }

  ProductBuilder.json({String id, Map<String, dynamic> data}) {
    this.id = id;
    title = data["title"];
    description = data["description"];
    price = data["price"];
    imageUrl = data["imageUrl"];
    isFavourite = data["isFavourite"];
  }

  ProductBuilder setId(String id) {
    this.id = id;
    return this;
  }

  ProductBuilder setTitle(String title) {
    this.title = title;
    return this;
  }

  ProductBuilder setDescription(String description) {
    this.description = description;
    return this;
  }

  ProductBuilder setPrice(double price) {
    this.price = price;
    return this;
  }

  ProductBuilder setImageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
    return this;
  }

  ProductBuilder setIsFavourite(bool isFavourite) {
    this.isFavourite = isFavourite;
    return this;
  }

  Product build() {
    return Product(
        id: id,
        title: title,
        description: description,
        price: price,
        imageUrl: imageUrl,
        isFavourite: isFavourite);
  }

  @override
  String toString() {
    return "Id: $id, title: $title, price: $price, ImageUrl: $imageUrl";
  }
}
