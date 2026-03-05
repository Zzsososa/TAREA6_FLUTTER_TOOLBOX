import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/gender_predictor_screen.dart';
import 'screens/age_predictor_screen.dart';
import 'screens/universities_screen.dart';
import 'screens/weather_screen.dart';
import 'screens/pokemon_screen.dart';
import 'screens/wordpress_screen.dart';
import 'screens/about_screen.dart';

void main() {
  runApp(ToolBoxApp());
}

class ToolBoxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToolBox App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/gender': (context) => GenderPredictorScreen(),
        '/age': (context) => AgePredictorScreen(),
        '/universities': (context) => UniversitiesScreen(),
        '/weather': (context) => WeatherScreen(),
        '/pokemon': (context) => PokemonScreen(),
        '/wordpress': (context) => WordPressScreen(),
        '/about': (context) => AboutScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
