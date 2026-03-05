import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/api_service.dart';
import '../widgets/custom_drawer.dart';

class PokemonScreen extends StatefulWidget {
  @override
  _PokemonScreenState createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  Map<String, dynamic>? _pokemon;
  bool _isLoading = false;

  void _searchPokemon() async {
    if (_controller.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final result = await _apiService.getPokemon(_controller.text);
      setState(() {
        _pokemon = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _playCry() async {
    if (_pokemon != null && _pokemon!['cries'] != null) {
      final url = _pokemon!['cries']['latest'];
      await _audioPlayer.play(UrlSource(url));
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pokemon')),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nombre del Pokemon',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchPokemon,
                ),
              ),
              onSubmitted: (_) => _searchPokemon(),
            ),
            SizedBox(height: 20),
            if (_isLoading) CircularProgressIndicator(),
            if (_pokemon != null && !_isLoading)
              Column(
                children: [
                  Image.network(
                    _pokemon!['sprites']['front_default'],
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    _pokemon!['name'].toString().toUpperCase(),
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Experiencia base: ${_pokemon!['base_experience']}'),
                  SizedBox(height: 10),
                  Text('Habilidades:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...(_pokemon!['abilities'] as List).map((a) => Text(a['ability']['name'])).toList(),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _playCry,
                    icon: Icon(Icons.volume_up),
                    label: Text('Escuchar Sonido'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
