import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppController appController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Units',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Temperature Unit'),
                      Obx(() => RadioListTile<String>(
                            title: const Text('Celsius (°C)'),
                            value: 'C',
                            groupValue: appController.temperatureUnit.value,
                            onChanged: (value) {
                              appController.setTemperatureUnit(value!);
                            },
                          )),
                      Obx(() => RadioListTile<String>(
                            title: const Text('Fahrenheit (°F)'),
                            value: 'F',
                            groupValue: appController.temperatureUnit.value,
                            onChanged: (value) {
                              appController.setTemperatureUnit(value!);
                            },
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Wind Speed Unit'),
                      Obx(() => RadioListTile<String>(
                            title: const Text('m/s'),
                            value: 'm/s',
                            groupValue: appController.windSpeedUnit.value,
                            onChanged: (value) {
                              appController.setWindSpeedUnit(value!);
                            },
                          )),
                      Obx(() => RadioListTile<String>(
                            title: const Text('km/h'),
                            value: 'km/h',
                            groupValue: appController.windSpeedUnit.value,
                            onChanged: (value) {
                              appController.setWindSpeedUnit(value!);
                            },
                          )),
                      Obx(() => RadioListTile<String>(
                            title: const Text('mph'),
                            value: 'mph',
                            groupValue: appController.windSpeedUnit.value,
                            onChanged: (value) {
                              appController.setWindSpeedUnit(value!);
                            },
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Obx(() => SwitchListTile(
                        title: const Text('Enable Notifications'),
                        value: appController.showNotifications.value,
                        onChanged: (value) {
                          appController.setNotifications(value);
                        },
                      )),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'About',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Weather Dashboard',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Version: 1.0.0'),
                      SizedBox(height: 4),
                      Text('API: OpenWeatherMap'),
                      SizedBox(height: 4),
                      Text('Flutter Weather Application'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
