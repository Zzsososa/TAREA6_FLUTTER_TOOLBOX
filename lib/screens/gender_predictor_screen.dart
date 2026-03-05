import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/custom_drawer.dart';

class GenderPredictorScreen extends StatefulWidget {
  @override
  _GenderPredictorScreenState createState() => _GenderPredictorScreenState();
}

class _GenderPredictorScreenState extends State<GenderPredictorScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  String? _gender;
  bool _isLoading = false;

  void _predictGender() async {
    if (_controller.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final result = await _apiService.getGender(_controller.text);
      setState(() {
        _gender = result['gender'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    if (_gender == 'male') backgroundColor = Colors.blue.shade100;
    if (_gender == 'female') backgroundColor = Colors.pink.shade100;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: Text('Predecir Género')),
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
                  onPressed: _predictGender,
                ),
              ),
              onSubmitted: (_) => _predictGender(),
            ),
            SizedBox(height: 30),
            if (_isLoading) CircularProgressIndicator(),
            if (_gender != null && !_isLoading)
              Column(
                children: [
                  Text(
                    'Género: ${_gender == 'male' ? 'Masculino' : 'Femenino'}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    _gender == 'male' ? Icons.male : Icons.female,
                    size: 100,
                    color: _gender == 'male' ? Colors.blue : Colors.pink,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
