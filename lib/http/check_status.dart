import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

mixin StatusChecker {
  @protected
  void checkStatus(Response response) {
    if (response.statusCode >= 400) throw HttpException("Something went wrong");
  }

  @protected
  void checkErrorInData(Map<String, dynamic> data) {
    if (data.containsKey("error")) throw HttpException(data["message"]);
  }
}
