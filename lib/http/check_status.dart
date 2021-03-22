import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

mixin StatusChecker {
  @protected
  void checkStatus(Response response) {
    if (response.statusCode >= 400) throw HttpException("Something went wrong");
  }
}
