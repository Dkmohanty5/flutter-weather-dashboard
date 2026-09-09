import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController extends GetxController {
  RxString temperatureUnit = 'C'.obs; // C or F
  RxString windSpeedUnit = 'm/s'.obs; // m/s or km/h or mph
  RxBool isDarkMode = false.obs;
  RxBool showNotifications = true.obs;
  late SharedPreferences prefs;

  @override
  void onInit() async {
    super.onInit();
    await initializePreferences();
  }

  Future<void> initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    loadPreferences();
  }

  void loadPreferences() {
    temperatureUnit.value = prefs.getString('temp_unit') ?? 'C';
    windSpeedUnit.value = prefs.getString('wind_unit') ?? 'm/s';
    isDarkMode.value = prefs.getBool('dark_mode') ?? false;
    showNotifications.value = prefs.getBool('notifications') ?? true;
  }

  Future<void> setTemperatureUnit(String unit) async {
    temperatureUnit.value = unit;
    await prefs.setString('temp_unit', unit);
  }

  Future<void> setWindSpeedUnit(String unit) async {
    windSpeedUnit.value = unit;
    await prefs.setString('wind_unit', unit);
  }

  Future<void> setDarkMode(bool value) async {
    isDarkMode.value = value;
    await prefs.setBool('dark_mode', value);
  }

  Future<void> setNotifications(bool value) async {
    showNotifications.value = value;
    await prefs.setBool('notifications', value);
  }

  double convertTemperature(double celsius) {
    if (temperatureUnit.value == 'F') {
      return (celsius * 9 / 5) + 32;
    }
    return celsius;
  }

  double convertWindSpeed(double mps) {
    if (windSpeedUnit.value == 'km/h') {
      return mps * 3.6;
    } else if (windSpeedUnit.value == 'mph') {
      return mps * 2.237;
    }
    return mps;
  }
}
