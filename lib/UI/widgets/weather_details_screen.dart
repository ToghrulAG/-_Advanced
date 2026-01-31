import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_practice/providers/cities_provider.dart';
import 'package:weather_app_practice/services/weather_service.dart';
import '../../models/weather_model.dart';

class WeatherDetailsScreen extends StatefulWidget {
  final String cityName;

  const WeatherDetailsScreen({super.key, required this.cityName});

  @override
  State<WeatherDetailsScreen> createState() => _WeatherDetailsState();
}

class _WeatherDetailsState extends State<WeatherDetailsScreen> {
  final WeatherService _weatherService = WeatherService();

  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final weather = await _weatherService.getWeather(widget.cityName);

      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error to fetch data ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final citiesProvider = context.watch<CitiesProvider>();
    final isAdded = citiesProvider.cities.contains(widget.cityName);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cityName),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            if(isAdded) {
              citiesProvider.removeCity(widget.cityName);
            } else {
              citiesProvider.addCity(widget.cityName);
            }
          }, icon: Icon(isAdded ? Icons.delete : Icons.add)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                children: [
                  Text(_error!, style: const TextStyle(color: Colors.red)),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadWeather,
                    child: const Icon(Icons.restart_alt),
                  ),
                ],
              ),
            )
          : _buildWeatherContent(),
    );
  }

  Widget _buildWeatherContent() {
    if (_weather == null) return const SizedBox();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          
         //

          Image.network(
            'https://openweathermap.org/img/wn/${_weather!.icon}@2x.png',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 16.0),
          Text(
            '${_weather!.temperature.toStringAsFixed(1)}C',
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Text(_weather!.description),

          const SizedBox(height: 32),
          Card(
            elevation: 4,
            child: Column(
              children: [
                _buildInfoRow(
                  'Влажность',
                  '${_weather!.humidity}%',
                  Icons.water_drop,
                ),
                const Divider(),
                _buildInfoRow('Ветер', '${_weather!.windSpeed} м/с', Icons.air),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue),
              SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 18)),
            ],
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
