import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  final WeatherService _weatherService = WeatherService();

  Future<Weather>? _weatherFuture;

  void _fetchWeather() {
    if (_cityController.text.trim().isEmpty) {
      // Opcional: Mostrar SnackBar si está vacío
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa una ciudad')),
      );
      return;
    }
    setState(() {
      _weatherFuture = _weatherService.getWeather(_cityController.text.trim());
    });
  }

  // --- NUEVO WIDGET DE ICONO ---
  // Método para obtener la URL del icono de OWM
  String _getWeatherIconUrl(String iconCode) {
    // Usamos @4x para la mejor calidad de imagen
    return 'https://openweathermap.org/img/wn/$iconCode@4x.png';
  }

  // --- WIDGET DE FONDO ---
  // Widget para el fondo degradado
  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E335A), Color(0xFF1C1B33)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usamos un Stack para poner el fondo detrás del contenido
    return Stack(
      children: [
        _buildBackground(), // Fondo degradado
        Scaffold(
          // Hacemos el Scaffold y AppBar transparentes
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0, // Sin sombra
            title: const Text(
              'Pronóstico del Clima',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SafeArea(
            // SafeArea para evitar la barra de estado y el notch
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // --- CAMPO DE BÚSQUEDA REDISEÑADO ---
                  TextField(
                    controller: _cityController,
                    // Cambiamos el estilo para que coincida con el fondo oscuro
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Ingresa una ciudad...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: _fetchWeather,
                      ),
                      // Estilo de "vidrio"
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none, // Sin borde
                      ),
                    ),
                    onSubmitted: (_) => _fetchWeather(),
                  ),
                  const SizedBox(height: 20),

                  // El FutureBuilder maneja el resto
                  Expanded(child: buildWeatherDisplay()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget para mostrar los estados (con mejor diseño)
  Widget buildWeatherDisplay() {
    // --- ESTADO VACÍO (INICIAL) MEJORADO ---
    if (_weatherFuture == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80, color: Colors.white54),
            SizedBox(height: 10),
            Text(
              'Busca una ciudad para empezar',
              style: TextStyle(color: Colors.white54, fontSize: 18),
            ),
          ],
        ),
      );
    }

    return FutureBuilder<Weather>(
      future: _weatherFuture,
      builder: (context, snapshot) {
        // --- ESTADO CARGANDO MEJORADO ---
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Un indicador más grande y de color blanco
          return const Center(
            child: SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 5,
              ),
            ),
          );
        }

        // --- ESTADO DE ERROR MEJORADO ---
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 10),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // --- ESTADO DE DATOS (ÉXITO) REDISEÑADO ---
        if (snapshot.hasData) {
          final weather = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- TARJETA DE "VIDRIO" ---
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        weather.cityName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // --- ICONO DEL CLIMA ---
                      Image.network(
                        _getWeatherIconUrl(weather.iconCode),
                        width: 150,
                        height: 150,
                        // Placeholder y manejo de error para la imagen
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(
                            width: 150,
                            height: 150,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.cloud_off,
                            color: Colors.white,
                            size: 150,
                          );
                        },
                      ),

                      Text(
                        '${weather.temperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.w200, // Fuente ligera
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        // Capitalizar la primera letra
                        weather.description.isNotEmpty
                            ? '${weather.description[0].toUpperCase()}${weather.description.substring(1)}'
                            : '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Estado vacío (por si acaso)
        return const Center(
          child: Text(
            'Ingresa una ciudad para ver el clima.',
            style: TextStyle(color: Colors.white54),
          ),
        );
      },
    );
  }
}
