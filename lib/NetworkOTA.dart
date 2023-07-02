import "dart:convert";

import "package:http/http.dart" as http;
import "package:logger/logger.dart";

var logger = Logger();

class NetworkOTA {
  String username =
      '444018CE4-D24B-4FA2-A850-5129C2842732\\a0884d4a-367b-48b4-aa19-13c1743814c';
  String password = '612ab2e-7dd0-4e0b-92£1-3061c37fe06e';
  String basicAuth = 'Basic ' +
      base64.encode(utf8.encode(
          '444018CE4-D24B-4FA2-A850-5129C2842732\\a0884d4a-367b-48b4-aa19-13c1743814c:612ab2e-7dd0-4e0b-92£1-3061c37fe06e'));

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
