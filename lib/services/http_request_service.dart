import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpRequestService {
  /// Get HTTP request
  static Future<dynamic> getRequest({required String url}) async {
    http.Response response = await http.get(Uri.parse(url));

    try {
      if (response.statusCode == 200) {
        String data = response.body;

        var decodedData = jsonDecode(data);

        return decodedData;
      } else {
        return "Failed Request";
      }
    } catch (error) {
      return "Failed Request";
    }
  }
}
