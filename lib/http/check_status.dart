import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

mixin StatusChecker {
  @protected
  void checkStatus(Response response) {
    print(response.body);
    if (response.statusCode >= 400) {
      final data = json.decode(response.body);
      if (data.containsKey("error"))
        throw HttpException(data["error"]["message"]);
      throw HttpException("Something went wrong");
    }
  }
}
