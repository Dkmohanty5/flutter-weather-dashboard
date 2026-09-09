import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather_model.dart';
import 'location_controller.dart';

class WeatherController extends GetxController {
  static const String apiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  final LocationController locationController = Get.find();

  RxBool isLoading = false.obs;
  RxBool isLoadingForecast = false.obs;
  RxString errorMessage = ''.obs;
  Rx<WeatherModel?> currentWeather = Rx<WeatherModel?>(null);
  Rx<ForecastModel?> forecast = Rx<ForecastModel?>(null);
  RxList<WeatherModel> weatherHistory = <WeatherModel>[].obs;
  RxList<String> favoriteLocations = <String>[].obs;

  @override
  void onInit() async {
    super.onInit();
    ever(locationController.latitude, (_) {
      if (locationController.isLocationAvailable.value) {
        fetchCurrentWeather();
        fetchForecast();
      }
    });
  }

  Future<void> fetchCurrentWeather() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = Uri.parse(
        '$baseUrl/weather?lat=${locationController.latitude.value}&lon=${locationController.longitude.value}&units=metric&appid=$apiKey',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        currentWeather.value = WeatherModel.fromJson(data);
        weatherHistory.add(currentWeather.value!);
        if (weatherHistory.length > 20) {
          weatherHistory.removeAt(0);
        }
      } else {
        errorMessage.value = 'Failed to fetch weather data';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchForecast() async {
    try {
      isLoadingForecast.value = true;

      final url = Uri.parse(
        '$baseUrl/forecast?lat=${locationController.latitude.value}&lon=${locationController.longitude.value}&units=metric&appid=$apiKey',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        forecast.value = ForecastModel.fromJson(data);
      } else {
        errorMessage.value = 'Failed to fetch forecast';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoadingForecast.value = false;
    }
  }

  Future<void> searchWeatherByCity(String cityName) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = Uri.parse(
        '$baseUrl/weather?q=$cityName&units=metric&appid=$apiKey',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        currentWeather.value = WeatherModel.fromJson(data);
        weatherHistory.add(currentWeather.value!);

        await locationController.setLocation(
          currentWeather.value!.latitude,
          currentWeather.value!.longitude,
        );

        await fetchForecast();
      } else {
        errorMessage.value = 'City not found';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchWeatherByCoordinates(double lat, double lon) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await locationController.setLocation(lat, lon);
      await fetchCurrentWeather();
      await fetchForecast();
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void addToFavorites(String location) {
    if (!favoriteLocations.contains(location)) {
      favoriteLocations.add(location);
    }
  }

  void removeFromFavorites(String location) {
    favoriteLocations.remove(location);
  }

  String getWeatherIcon(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@4x.png';
  }

  String getWindDirection(int degree) {
    if (degree >= 337.5 || degree < 22.5) return 'N';
    if (degree >= 22.5 && degree < 67.5) return 'NE';
    if (degree >= 67.5 && degree < 112.5) return 'E';
    if (degree >= 112.5 && degree < 157.5) return 'SE';
    if (degree >= 157.5 && degree < 202.5) return 'S';
    if (degree >= 202.5 && degree < 247.5) return 'SW';
    if (degree >= 247.5 && degree < 292.5) return 'W';
    return 'NW';
  }
}
