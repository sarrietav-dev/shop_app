import 'dart:io';

import 'package:http/http.dart';

mixin StatusChecker {
  void checkStatus(Response response) {
    if (response.statusCode >= 400) throw HttpException("Something went wrong");
  }
}
