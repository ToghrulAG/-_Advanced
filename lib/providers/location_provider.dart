import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import '../services/weather_service.dart';

class LocationProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  Weather? weather;
  bool isLoading = false;
  String? error;

  Future<void> loadLocationWeather() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      final position = await _determinePosition();

      weather =  await _weatherService.getWeatherByCoords(lat: position.latitude, lon: position.longitude);

    } 
    catch (e) {
      error = e.toString();
    } 
    finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location service is disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission is parmanently denied');
    }
    return Geolocator.getCurrentPosition();
  }
}
