import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkHelper{

  NetworkHelper(this.url);

  String url;

  Future getData() async {
    Uri url = Uri.parse(this.url);
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

     return data;
    } else {
      print('Failed to load weather data: ${response.statusCode}');
    }

  }

}