import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String genderizeUrl = 'https://api.genderize.io/';
  static const String agifyUrl = 'https://api.agify.io/';
  static const String universitiesUrl = 'https://adamix.net/proxy.php';
  static const String pokeApiUrl = 'https://pokeapi.co/api/v2/pokemon/';
  // Using OpenWeatherMap (requires key) or a free alternative. 
  // For this task, let's use a simpler way or ask. 
  // Actually, I'll use a free one that doesn't need a key if possible, or a placeholder.
  // wttr.in is great for simple text/json.
  static const String weatherUrl = 'https://wttr.in/Santo+Domingo?format=j1';

  Future<Map<String, dynamic>> getGender(String name) async {
    final response = await http.get(Uri.parse('$genderizeUrl?name=$name'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load gender data');
  }

  Future<Map<String, dynamic>> getAge(String name) async {
    final response = await http.get(Uri.parse('$agifyUrl?name=$name'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load age data');
  }

  Future<List<dynamic>> getUniversities(String country) async {
    final response = await http.get(Uri.parse('$universitiesUrl?country=$country'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load universities');
  }

  Future<Map<String, dynamic>> getWeather() async {
    final response = await http.get(Uri.parse(weatherUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load weather data');
  }

  Future<Map<String, dynamic>> getPokemon(String name) async {
    final cleanName = name.trim().toLowerCase();
    if (cleanName.isEmpty) throw Exception('El nombre no puede estar vacio');
    
    final response = await http.get(Uri.parse('$pokeApiUrl$cleanName'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Pokemon no encontrado. Verifica el nombre.');
    }
    throw Exception('Error del servidor: ${response.statusCode}');
  }

  Future<List<dynamic>> getWordPressNews(String siteUrl) async {
    // Basic WP API endpoint for latest posts with thumbnails
    final response = await http.get(Uri.parse('$siteUrl/wp-json/wp/v2/posts?per_page=3&_embed'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load wordpress news');
  }

  Future<Map<String, dynamic>> getWordPressSiteInfo(String siteUrl) async {
    final response = await http.get(Uri.parse('$siteUrl/wp-json/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load site info');
  }
}
