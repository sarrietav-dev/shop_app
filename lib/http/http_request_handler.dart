import 'package:shop_app/http/url_handler.dart';

abstract class HTTPRequestHandler {
  final URLHandler urlHandler;

  HTTPRequestHandler(this.urlHandler);

  Future<void> fetchData();
}
