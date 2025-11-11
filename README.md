# Lab 1: Consumo de API REST de Clima (Flutter)

Este proyecto es una aplicación de Flutter que consume la API de OpenWeatherMap para obtener y mostrar el pronóstico del clima de una ciudad específica.

El objetivo es demostrar la integración segura de una API REST, incluyendo el manejo de secretos (API keys), la gestión de estados (cargando, error, datos) y la implementación de buenas prácticas de red.

## Características

* Búsqueda de clima por nombre de ciudad.
* Manejo de estado asíncrono (Cargando, Error, Vacío, Datos).
* Manejo de errores comunes de red (Timeouts, 404, 401, etc.).
* Gestión segura de la API Key usando `flutter_dotenv`.

## Dependencias Utilizadas

* `http`: Para realizar las peticiones GET a la API.
* `flutter_dotenv`: Para cargar y leer la API key desde un archivo `.env` de forma segura.

---

## Configuración Obligatoria (API Key)

Esta aplicación requiere una API Key de OpenWeatherMap (OWM) para funcionar.

**IMPORTANTE:** El archivo `.env` donde se almacena la clave está deliberadamente ignorado por Git (vía `.gitignore`) para no exponer secretos en el repositorio.

Sigue estos pasos para configurar tu entorno local:

1.  **Crea una cuenta** en [OpenWeatherMap](https://openweathermap.org/) y obtén tu API Key gratuita.
2.  **Crea un archivo `.env`** en la raíz de este proyecto (al mismo nivel que `pubspec.yaml`).
3.  **Añade tu API Key** dentro del archivo `.env` con el siguiente formato:

    ```
    API_KEY=TU_LLAVE_SECRETA_COPIADA_DE_OWM
    ```

4.  Reemplaza `TU_LLAVE_SECRETA_COPIADA_DE_OWM` con la clave que generaste.

---

## Ejecución del Proyecto

Una vez que el archivo `.env` esté configurado, puedes correr la aplicación.

1.  **Instalar dependencias:**
    Asegúrate de tener todas las dependencias del proyecto ejecutando:
    ```bash
    flutter pub get
    ```

2.  **Ejecutar la aplicación:**
    Conecta un dispositivo o inicia un emulador y ejecuta:
    ```bash
    flutter run
    ```