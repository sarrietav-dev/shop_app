import 'package:flutter/foundation.dart';
import 'package:shop_app/http/api_handlers/favourites_http_handler.dart';
import 'package:shop_app/http/api_handlers/product_listing_handler.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  UserFavouriteData isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite});

  Future<void> toggleFavouriteStatus() async {
    await isFavourite.toggleFavouriteStatus();
    notifyListeners();
  }

  get toJSON => {
        "title": this.title,
        "description": this.description,
        "price": this.price,
        "imageUrl": this.imageUrl,
      };

  @override
  String toString() {
    return "Id: $id, title: $title, price: $price, ImageUrl: $imageUrl";
  }
}

class UserFavouriteData {
  final String id;
  bool isFavourite;
  final String productId;

  UserFavouriteData(
      {@required this.id,
      @required this.isFavourite,
      @required this.productId});

  Future<void> toggleFavouriteStatus() async {
    isFavourite = !isFavourite;
    await FavouritesHttpHandler(resourceId: id, body: toJson).addFavourite();
  }

  get toJson => {
        "isFavourite": isFavourite,
        "productId": productId,
      };
}

class ProductBuilder {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  UserFavouriteData isFavourite;

  ProductBuilder() {
    title = "";
    description = "";
    price = 0;
    imageUrl = "";
    isFavourite = UserFavouriteData(id: "", isFavourite: false, productId: "");
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

  ProductBuilder setIsFavourite(UserFavouriteData isFavourite) {
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
