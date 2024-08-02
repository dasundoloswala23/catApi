import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/images.dart';

class CatService {
  static const String _apiKey = 'live_lGGh383MzUSP9MdgqvAHcs3IC8CUfHyQnXQ4ySAmagb0uHSJQucWIto5pqfR2EZb';
  static const String _baseUrl = 'https://api.thecatapi.com/v1/images/search';

  static Future<List<Images>> fetchCats(int page, int limit, String type) async {
    String mimeTypes = type == 'images'
        ? 'jpg,png'
        : type == 'gifs'
        ? 'gif'
        : 'jpg,png,gif';

    final url = '$_baseUrl?limit=$limit&page=$page&mime_types=$mimeTypes&order=random&api_key=$_apiKey';

    print('Fetching cats from: $url');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('Received data: $data');

      final List<Images> cats = data
          .where((item) =>
      item['categories'] == null ||
          !item['categories'].any((cat) => cat['name'] == 'hat'))
          .map((json) => Images.fromJson(json))
          .toList();
      return cats;
    } else {
      print('Failed to load cats with status code: ${response.statusCode}');
      throw Exception('Failed to load cats');
    }
  }
}
