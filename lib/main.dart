import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/home_screen.dart';
import 'screens/forecast_screen.dart';
import 'screens/search_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/details_screen.dart';
import 'routes/app_routes.dart';
import 'themes/app_theme.dart';
import 'controllers/weather_controller.dart';
import 'controllers/location_controller.dart';
import 'controllers/app_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WeatherDashboardApp());
}

class WeatherDashboardApp extends StatelessWidget {
  const WeatherDashboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Weather Dashboard',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
      getPages: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
      initialBindings: BindingsBuilder(() {
        Get.put(AppController(), permanent: true);
        Get.put(LocationController(), permanent: true);
        Get.put(WeatherController(), permanent: true);
      }),
    );
  }
}
