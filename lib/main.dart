import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String _weather = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    final apiKey = dotenv.env['OPENWEATHERMAP_API_KEY'];
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=Tokyo&appid=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _weather =
            "${data['weather'][0]['description']}, ${data['main']['temp']}K";
      });
    } else {
      setState(() {
        _weather = "Failed to fetch weather data.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Center(
        child: Text(_weather),
      ),
    );
  }
}
