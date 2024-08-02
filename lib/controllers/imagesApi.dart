// apiController/imagesApi.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/images.dart';

class CatService {
  static const String _apiKey = 'live_lGGh383MzUSP9MdgqvAHcs3IC8CUfHyQnXQ4ySAmagb0uHSJQucWIto5pqfR2EZb';
  static const String _url = 'https://api.thecatapi.com/v1/images/search?limit=100&breed_ids=beng&api_key=$_apiKey';

  static Future<List<Images>> fetchCats(int page, int limit) async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Images> cats = data.map((json) => Images.fromJson(json)).toList();
      return cats;
    } else {
      throw Exception('Failed to load cats');
    }
  }
}
