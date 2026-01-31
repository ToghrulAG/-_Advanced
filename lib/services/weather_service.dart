import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather_model.dart';

class WeatherService {
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  String get apiKey => dotenv.env["APIKEY"] ?? '';

  Future<Weather> getWeather(String cityName) async {
    final url = Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception('Error to fetch weather data');
    }
  }

  Future<Weather> getWeatherByCoords({
    required double lat,
    required double lon,
  }) async {
    final url = Uri.parse(
      '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception('Error to fetch data by coords');
    }
  }
}
