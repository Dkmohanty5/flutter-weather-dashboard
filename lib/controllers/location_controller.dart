import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationController extends GetxController {
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString cityName = 'Loading...'.obs;
  RxString countryName = ''.obs;
  RxBool isLocationAvailable = false.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        errorMessage.value = 'Location services are disabled';
        isLoading.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          errorMessage.value = 'Location permission denied';
          isLoading.value = false;
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;
      isLocationAvailable.value = true;

      await getAddressFromLatLng();
    } catch (e) {
      errorMessage.value = 'Error getting location: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude.value,
        longitude.value,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        cityName.value = place.locality ?? 'Unknown';
        countryName.value = place.country ?? '';
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  Future<void> setLocation(double lat, double lon) async {
    latitude.value = lat;
    longitude.value = lon;
    await getAddressFromLatLng();
  }
}
