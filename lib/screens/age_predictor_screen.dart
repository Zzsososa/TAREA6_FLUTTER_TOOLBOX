import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/custom_drawer.dart';

class AgePredictorScreen extends StatefulWidget {
  @override
  _AgePredictorScreenState createState() => _AgePredictorScreenState();
}

class _AgePredictorScreenState extends State<AgePredictorScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  int? _age;
  bool _isLoading = false;

  void _predictAge() async {
    if (_controller.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final result = await _apiService.getAge(_controller.text);
      setState(() {
        _age = result['age'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  String get _category {
    if (_age == null) return '';
    if (_age! < 18) return 'Joven';
    if (_age! < 60) return 'Adulto';
    return 'Anciano';
  }

  String get _imageUrl {
    if (_age == null) return '';
    if (_age! < 18) return 'https://cdn-icons-png.flaticon.com/512/3048/3048127.png'; // Boy icon
    if (_age! < 60) return 'https://cdn-icons-png.flaticon.com/512/3048/3048122.png'; // Adult man
    return 'https://cdn-icons-png.flaticon.com/512/3048/3048135.png'; // Old man
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Predecir Edad')),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Ingresa un nombre',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _predictAge,
                ),
              ),
              onSubmitted: (_) => _predictAge(),
            ),
            SizedBox(height: 30),
            if (_isLoading) CircularProgressIndicator(),
            if (_age != null && !_isLoading)
              Column(
                children: [
                  Text('Edad estimada: $_age', style: TextStyle(fontSize: 22)),
                  SizedBox(height: 10),
                  Text('Estado: $_category', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Image.network(_imageUrl, height: 150),
                ],
              ),
            if (_age == null && !_isLoading && _controller.text.isNotEmpty)
              Text('No se pudo determinar la edad.')
          ],
        ),
      ),
    );
  }
}
