import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' show parse;
import '../services/api_service.dart';
import '../widgets/custom_drawer.dart';

class WordPressScreen extends StatefulWidget {
  @override
  _WordPressScreenState createState() => _WordPressScreenState();
}

class _WordPressScreenState extends State<WordPressScreen> {
  final ApiService _apiService = ApiService();
  final String _siteUrl = 'https://kinsta.com'; // User: You can change this to any WP site
  List<dynamic> _news = [];
  String? _logoUrl;
  String _siteName = 'Cargando...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      final info = await _apiService.getWordPressSiteInfo(_siteUrl);
      final news = await _apiService.getWordPressNews(_siteUrl);
      
      setState(() {
        _siteName = info['name'] ?? 'Sitio WordPress';
        // Some sites provide the icon/logo URL in the root JSON
        _logoUrl = info['site_icon_url'] ?? 'https://kinsta.com/wp-content/uploads/2020/09/kinsta-logo.png';
        _news = news;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al cargar datos: $e')));
    }
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  String _stripHtml(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body?.text).documentElement?.text ?? '';
    return parsedString.length > 150 ? parsedString.substring(0, 150) + '...' : parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Noticias WP')),
      drawer: CustomDrawer(),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (_logoUrl != null)
                  Image.network(
                    _logoUrl!,
                    height: 80,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.web, size: 80),
                  ),
                SizedBox(height: 10),
                Text(
                  _siteName,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Divider(height: 40),
                Text(
                  'Últimas 3 Noticias',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                ..._news.map((item) {
                  final title = parse(item['title']['rendered'] ?? 'Sin título').documentElement?.text ?? 'N/A';
                  final excerpt = _stripHtml(item['excerpt']['rendered'] ?? 'Sin resumen');
                  final link = item['link'];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                          ),
                          SizedBox(height: 10),
                          Text(
                            excerpt,
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () => _launchUrl(link),
                              icon: Icon(Icons.arrow_forward),
                              label: Text('Visitar Noticia'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade50,
                                foregroundColor: Colors.blue.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
    );
  }
}
