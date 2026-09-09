import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weather_controller.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WeatherController weatherController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('5-Day Forecast'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
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

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: forecast.list.length,
          itemBuilder: (context, index) {
            final item = forecast.list[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Image.network(
                      weatherController.getWeatherIcon(item.icon),
                      width: 60,
                      height: 60,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.cloud, size: 60),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.dateTime.toString().split('.')[0],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.mainCondition,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${item.temperature.toStringAsFixed(1)}°C',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Humidity: ${item.humidity}%',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
