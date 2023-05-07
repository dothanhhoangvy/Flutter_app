import "dart:convert";

import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:http/http.dart" as http;
import "package:logger/logger.dart";

var logger = Logger();

class NetworkHandler {
  String baseurl = "https://realnodedjshv.up.railway.app";
  FlutterSecureStorage storage = const FlutterSecureStorage();
  Future get(String url) async {
    url = formater(url);
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200 || response.statusCode == 201) {
      logger.i(response.body);
      return json.decode(response.body);
    }
    logger.i(response.body);
    logger.i(response.statusCode);
  }

  Future<http.Response> post(String url, Map<String, String> body) async {
    String? token = await storage.read(key: "token");
    url = formater(url);
    logger.d(body);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(body),
    );
    return response;
  }

  String formater(String url) {
    return baseurl + url;
  }
}

  // Future Login(String username, String password) async {
  // String baseur1l = "https://servernodejs.up.railway.app";
  // String urlLogin = "${baseur1l}/login";
  //   var response = await http.post(Uri.parse(urlLogin),
  //     headers: {"Accept": "application/json"},
  //     body: {'username':username,'password':password},
  //   );
  //   var decodedData = jsonDecode(response.body);
  //       print(decodedData['token']);
  //   return decodedData;
  // }

