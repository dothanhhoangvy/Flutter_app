import "dart:convert";

import "package:http/http.dart" as http;
import "package:logger/logger.dart";

var logger = Logger();

class NetworkOTA {
  String username =
      '46890D00-C308-4473-9D2F-DCCB6847091F\\8661961a-ea25-4fb7-a81a-ead21d4a8da2';
  String password = '50c2f8e3-79d6-404e-aa5a-6c30af2d9856';
  String basicAuth = 'Basic ' +
      base64.encode(utf8.encode(
          '46890D00-C308-4473-9D2F-DCCB6847091F\\8661961a-ea25-4fb7-a81a-ead21d4a8da2:50c2f8e3-79d6-404e-aa5a-6c30af2d9856'));

  Future get(String url) async {
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{'authorization': basicAuth},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      logger.i(response.body);
      return json.decode(response.body);
    }
    logger.i(response.body);
    logger.i(response.statusCode);
  }
}
