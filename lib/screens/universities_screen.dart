import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../widgets/custom_drawer.dart';

class UniversitiesScreen extends StatefulWidget {
  @override
  _UniversitiesScreenState createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  List<dynamic> _universities = [];
  bool _isLoading = false;

  void _searchUniversities() async {
    if (_controller.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final result = await _apiService.getUniversities(_controller.text);
      setState(() {
        _universities = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No se puede abrir el enlace: $url')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Universidades')),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Ingresa un país (en inglés)',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchUniversities,
                ),
              ),
              onSubmitted: (_) => _searchUniversities(),
            ),
            SizedBox(height: 20),
            if (_isLoading) CircularProgressIndicator(),
            Expanded(
              child: ListView.builder(
                itemCount: _universities.length,
                itemBuilder: (context, index) {
                  final uni = _universities[index];
                  final name = uni['name'] ?? 'N/A';
                  final domain = (uni['domains'] as List).isNotEmpty ? uni['domains'][0] : 'N/A';
                  final webPages = (uni['web_pages'] as List).isNotEmpty ? uni['web_pages'][0] : null;

                  return Card(
                    child: ListTile(
                      title: Text(name),
                      subtitle: Text('Dominio: $domain'),
                      trailing: webPages != null 
                        ? IconButton(
                            icon: Icon(Icons.open_in_new),
                            onPressed: () => _launchUrl(webPages),
                          )
                        : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
