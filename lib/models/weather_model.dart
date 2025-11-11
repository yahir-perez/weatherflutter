class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String iconCode; // <-- AÑADE ESTA LÍNEA

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.iconCode, // <-- AÑADE ESTA LÍNEA
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'], // <-- AÑADE ESTA LÍNEA
    );
  }
}
