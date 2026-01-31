import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app_practice/providers/cities_provider.dart';
import 'package:weather_app_practice/providers/location_provider.dart';
import 'UI/widgets/home_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocationProvider()..loadLocationWeather(),
        ),
        ChangeNotifierProvider(create: (_) => CitiesProvider()),
      ],
      child: WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Weather App", home: HomeScreen());
  }
}
