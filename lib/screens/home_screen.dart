import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weather_controller.dart';
import '../controllers/location_controller.dart';
import '../controllers/app_controller.dart';
import 'forecast_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherController weatherController = Get.find();
  final LocationController locationController = Get.find();
  final AppController appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.to(() => const SearchScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.to(() => const SettingsScreen()),
          ),
        ],
      ),
      body: Obx(() {
        if (weatherController.isLoading.value && weatherController.currentWeather.value == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (weatherController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(weatherController.errorMessage.value),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => weatherController.fetchCurrentWeather(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final weather = weatherController.currentWeather.value;
        if (weather == null) {
          return const Center(
            child: Text('No weather data available'),
          );
        }

        return RefreshIndicator(
          onRefresh: () => weatherController.fetchCurrentWeather(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLocationCard(weather),
                  const SizedBox(height: 20),
                  _buildCurrentWeatherCard(weather),
                  const SizedBox(height: 20),
                  _buildWeatherDetailsGrid(weather),
                  const SizedBox(height: 20),
                  _buildForecastPreview(),
                  const SizedBox(height: 20),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLocationCard(dynamic weather) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.location_on, size: 32, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              '${weather.cityName}, ${weather.countryCode}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Lat: ${weather.latitude.toStringAsFixed(2)}, Lon: ${weather.longitude.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentWeatherCard(dynamic weather) {
    final temp = appController.convertTemperature(weather.temperature);
    final feelsLike = appController.convertTemperature(weather.feelsLike);
    final tempUnit = appController.temperatureUnit.value;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  weatherController.getWeatherIcon(weather.icon),
                  width: 100,
                  height: 100,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.cloud, size: 100),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${temp.toStringAsFixed(1)}°$tempUnit',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Feels like ${feelsLike.toStringAsFixed(1)}°$tempUnit',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              weather.mainCondition,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              weather.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetailsGrid(dynamic weather) {
    final windSpeed = appController.convertWindSpeed(weather.windSpeed);
    final windUnit = appController.windSpeedUnit.value;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildDetailCard(
          'Humidity',
          '${weather.humidity}%',
          Icons.water_drop,
        ),
        _buildDetailCard(
          'Wind Speed',
          '${windSpeed.toStringAsFixed(1)} $windUnit',
          Icons.wind_power,
        ),
        _buildDetailCard(
          'Pressure',
          '${weather.pressure} hPa',
          Icons.compress,
        ),
        _buildDetailCard(
          'Cloudiness',
          '${weather.cloudiness}%',
          Icons.cloud,
        ),
        _buildDetailCard(
          'Visibility',
          '${(weather.visibility / 1000).toStringAsFixed(1)} km',
          Icons.visibility,
        ),
        _buildDetailCard(
          'Wind Direction',
          weatherController.getWindDirection(weather.windDegree),
          Icons.navigation,
        ),
      ],
    );
  }

  Widget _buildDetailCard(
    String label,
    String value,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Forecast',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (weatherController.isLoadingForecast.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final forecast = weatherController.forecast.value;
          if (forecast == null || forecast.list.isEmpty) {
            return const Center(
              child: Text('No forecast data available'),
            );
          }

          return SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: forecast.list.length > 8 ? 8 : forecast.list.length,
              itemBuilder: (context, index) {
                final item = forecast.list[index];
                return _buildForecastCard(item);
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildForecastCard(dynamic item) {
    final temp = appController.convertTemperature(item.temperature);
    final tempUnit = appController.temperatureUnit.value;

    return Card(
      margin: const EdgeInsets.only(right: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${item.dateTime.hour}:00',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Image.network(
              weatherController.getWeatherIcon(item.icon),
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.cloud, size: 40),
            ),
            const SizedBox(height: 4),
            Text(
              '${temp.toStringAsFixed(0)}°$tempUnit',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () => Get.to(() => const ForecastScreen()),
          icon: const Icon(Icons.calendar_today),
          label: const Text('5-Day Forecast'),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => weatherController.addToFavorites(
            '${weatherController.currentWeather.value!.cityName}, ${weatherController.currentWeather.value!.countryCode}',
          ),
          icon: const Icon(Icons.favorite_border),
          label: const Text('Add to Favorites'),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => Get.to(() => const DetailsScreen()),
          icon: const Icon(Icons.info),
          label: const Text('View Details'),
        ),
      ],
    );
  }
}
