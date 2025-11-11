import 'dart:convert';
import 'dart:async'; // Para TimeoutException
import 'dart:io'; // Para SocketException
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather_model.dart'; // Importa tu modelo

class WeatherService {
  final String _baseUrl = 'api.openweathermap.org';
  final String _apiKey = dotenv.env['API_KEY']!; // Accede a la key desde .env

  Future<Weather> getWeather(String city) async {
    // Criterio: Validación de entrada
    if (city.trim().isEmpty) {
      throw Exception('La ciudad no puede estar vacía.');
    }

    // Criterio: Sanitización de entrada (simple)
    final String sanitizedCity = city.trim();

    final uri = Uri.https(_baseUrl, '/data/2.5/weather', {
      'q': sanitizedCity,
      'appid': _apiKey,
      'units': 'metric',
      'lang': 'es', // Pedir descripción en español
    });

    try {
      // Criterio: Petición GET con Timeout
      final response = await http.get(uri).timeout(const Duration(seconds: 8));

      // Criterio: Manejo de errores (429, etc.)
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return Weather.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('Ciudad no encontrada.');
      } else if (response.statusCode == 401) {
        throw Exception('API Key inválida o no autorizada.');
      } else if (response.statusCode == 429) {
        throw Exception('Límite de peticiones alcanzado. Intenta más tarde.');
      } else {
        throw Exception('Error desconocido: ${response.statusCode}');
      }
    } on TimeoutException {
      // Criterio: Manejo de Timeout
      throw Exception('La petición tardó demasiado (timeout).');
    } on SocketException {
      // Criterio: Manejo de error de red
      throw Exception('Error de conexión. Revisa tu internet.');
    } on Exception catch (e) {
      // Re-lanzar otras excepciones
      throw Exception('Error al obtener el clima: $e');
    }
  }
}
