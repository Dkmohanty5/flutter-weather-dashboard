import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weather_controller.dart';
import '../controllers/app_controller.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WeatherController weatherController = Get.find();
    final AppController appController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final weather = weatherController.currentWeather.value;
        if (weather == null) {
          return const Center(
            child: Text('No weather data available'),
          );
        }

        final temp = appController.convertTemperature(weather.temperature);
        final feelsLike =
            appController.convertTemperature(weather.feelsLike);
        final tempMin = appController.convertTemperature(weather.tempMin);
        final tempMax = appController.convertTemperature(weather.tempMax);
        final windSpeed = appController.convertWindSpeed(weather.windSpeed);
        final tempUnit = appController.temperatureUnit.value;
        final windUnit = appController.windSpeedUnit.value;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailSection('Temperature', [
                  _buildDetailItem('Current', '$temp°$tempUnit'),
                  _buildDetailItem('Feels Like', '$feelsLike°$tempUnit'),
                  _buildDetailItem('Min', '$tempMin°$tempUnit'),
                  _buildDetailItem('Max', '$tempMax°$tempUnit'),
                ]),
                const SizedBox(height: 24),
                _buildDetailSection('Wind Information', [
                  _buildDetailItem('Speed', '$windSpeed $windUnit'),
                  _buildDetailItem(
                    'Direction',
                    '${weather.windDegree}° ${weatherController.getWindDirection(weather.windDegree)}',
                  ),
                ]),
                const SizedBox(height: 24),
                _buildDetailSection('Atmospheric', [
                  _buildDetailItem('Pressure', '${weather.pressure} hPa'),
                  _buildDetailItem('Humidity', '${weather.humidity}%'),
                  _buildDetailItem('Cloudiness', '${weather.cloudiness}%'),
                  _buildDetailItem(
                    'Visibility',
                    '${(weather.visibility / 1000).toStringAsFixed(1)} km',
                  ),
                ]),
                const SizedBox(height: 24),
                _buildDetailSection('Rain & Snow', [
                  _buildDetailItem('Rain Volume', '${weather.rainVolume} mm'),
                  _buildDetailItem('Snow Volume', '${weather.snowVolume} mm'),
                ]),
                const SizedBox(height: 24),
                _buildDetailSection('Coordinates', [
                  _buildDetailItem(
                    'Latitude',
                    weather.latitude.toStringAsFixed(4),
                  ),
                  _buildDetailItem(
                    'Longitude',
                    weather.longitude.toStringAsFixed(4),
                  ),
                ]),
                const SizedBox(height: 24),
                _buildDetailSection('Time', [
                  _buildDetailItem(
                    'Current Time',
                    weather.dateTime.toString().split('.')[0],
                  ),
                  _buildDetailItem(
                    'Sunrise',
                    DateTime.fromMillisecondsSinceEpoch(weather.sunrise * 1000)
                        .toString()
                        .split('.')[0],
                  ),
                  _buildDetailItem(
                    'Sunset',
                    DateTime.fromMillisecondsSinceEpoch(weather.sunset * 1000)
                        .toString()
                        .split('.')[0],
                  ),
                ]),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDetailSection(
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
