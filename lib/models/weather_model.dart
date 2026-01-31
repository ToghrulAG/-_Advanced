class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;        // ✅ строка
  final int humidity;
  final double windSpeed;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],

      temperature: (json['main']['temp'] as num).toDouble(),

      description: json['weather'][0]['description'],

      icon: json['weather'][0]['icon'],  // "04d"

      humidity: (json['main']['humidity'] as num).toInt(),

      windSpeed: (json['wind']['speed'] as num).toDouble(),
    );
  }
}