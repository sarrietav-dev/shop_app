import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';

class ProductDetailPage extends StatelessWidget {
  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    Product product = (ModalRoute.of(context).settings.arguments
        as Map<String, Product>)["product"];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 10,
            ),
            Text(
              "\$${product.price}",
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: const TextStyle(fontSize: 20),
                )),
            SizedBox(
              height: 1000,
            ),
          ])),
        ],
      ),
    );
  }
}
