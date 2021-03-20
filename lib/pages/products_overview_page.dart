import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/models/product_listing.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsOverviewPage extends StatefulWidget {
  final bool showFavourites;

  const ProductsOverviewPage({Key key, this.showFavourites}) : super(key: key);

  @override
  _ProductsOverviewPageState createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _isLoading = false;
  bool _isFetch = false;

  @override
  void initState() {
    if (!_isFetch) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<ProductListing>(context, listen: false)
          .fetchProducts()
          .then((value) => setState(() {
                _isLoading = false;
                _isFetch = true;
              }));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _ProductsGrid(
                showFavourites: widget.showFavourites,
              ),
      ),
    );
  }

  Future<void> _refreshProducts() async {
    await Provider.of<ProductListing>(context, listen: false).fetchProducts();
  }
}

class _ProductsGrid extends StatelessWidget {
  final bool showFavourites;

  const _ProductsGrid({Key key, this.showFavourites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Product> loadedProducts = Provider.of<ProductListing>(context).items;

    if (showFavourites)
      loadedProducts =
          loadedProducts.where((element) => element.isFavourite).toList();

    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: loadedProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
              value: loadedProducts[index],
              child: ProductItem(),
            ));
  }
}
