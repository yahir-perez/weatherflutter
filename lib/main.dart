// En tu archivo main.dart
import 'package:flutter/material.dart';
import 'package:lab_api_clima/screens/weather_screen.dart';
import 'package:flutter/services.dart'; // <-- IMPORTA ESTO
import 'package:flutter_dotenv/flutter_dotenv.dart'; // <-- IMPORTA ESTO

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  // --- AÑADE ESTO ---
  // Para asegurar que los estilos de la UI del sistema se apliquen
  WidgetsFlutterBinding.ensureInitialized();
  // Establece el estilo de la barra de estado en claro (para fondos oscuros)
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  // --- FIN DE AÑADIDO ---

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'App del Clima',
      debugShowCheckedModeBanner: false, // Quita la cinta de "Debug"
      home: WeatherScreen(),
    );
  }
}
