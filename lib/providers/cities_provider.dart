import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CitiesProvider extends ChangeNotifier {
  static const _citiesKey = 'cities';
  List<String> _cities = [];

  List<String> get cities => _cities;

  CitiesProvider() {
    loadCities();
  }

  void saveCities() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('cities', _cities);
  }

  Future<void> loadCities() async {
    final prefs = await SharedPreferences.getInstance();
    _cities = prefs.getStringList(_citiesKey) ?? [];
    notifyListeners();
  }

  Future<void> addCity(String city) async {
    _cities.add(city);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_citiesKey, _cities);
  }

  Future<void> removeCity(String city) async {
    _cities.remove(city);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_citiesKey, _cities);
  }
  void dragAndDrop(int oldIndex, int newIndex) {
    final city = _cities.removeAt(oldIndex);
    _cities.insert(newIndex, city);

  }
}
