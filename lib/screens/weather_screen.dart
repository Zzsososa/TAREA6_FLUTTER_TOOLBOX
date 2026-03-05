import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/custom_drawer.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _weather;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() async {
    try {
      final result = await _apiService.getWeather();
      setState(() {
        _weather = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    String temp = 'N/A';
    String desc = 'N/A';
    if (_weather != null) {
      final current = _weather!['current_condition'][0];
      temp = current['temp_C'];
      desc = current['lang_es'] != null ? current['lang_es'][0]['value'] : current['weatherDesc'][0]['value'];
    }

    return Scaffold(
      appBar: AppBar(title: Text('Clima en RD')),
      drawer: CustomDrawer(),
      body: Center(
        child: _isLoading 
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wb_sunny, size: 100, color: Colors.orange),
                SizedBox(height: 20),
                Text(
                  'Santo Domingo, RD',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '$temp °C',
                  style: TextStyle(fontSize: 48),
                ),
                Text(
                  desc,
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _fetchWeather,
                  child: Text('Actualizar'),
                ),
              ],
            ),
      ),
    );
  }
}
