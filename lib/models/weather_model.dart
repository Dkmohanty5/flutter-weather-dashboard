class WeatherModel {
  final String cityName;
  final String countryCode;
  final double latitude;
  final double longitude;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final int windDegree;
  final int cloudiness;
  final String mainCondition;
  final String description;
  final String icon;
  final int sunrise;
  final int sunset;
  final double visibility;
  final double rainVolume;
  final double snowVolume;
  final DateTime dateTime;
  final int timezone;
  final int cod;

  WeatherModel({
    required this.cityName,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.windDegree,
    required this.cloudiness,
    required this.mainCondition,
    required this.description,
    required this.icon,
    required this.sunrise,
    required this.sunset,
    required this.visibility,
    required this.rainVolume,
    required this.snowVolume,
    required this.dateTime,
    required this.timezone,
    required this.cod,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? 'Unknown',
      countryCode: json['sys']['country'] ?? '',
      latitude: (json['coord']['lat'] ?? 0.0).toDouble(),
      longitude: (json['coord']['lon'] ?? 0.0).toDouble(),
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']['feels_like'] ?? 0).toDouble(),
      tempMin: (json['main']['temp_min'] ?? 0).toDouble(),
      tempMax: (json['main']['temp_max'] ?? 0).toDouble(),
      pressure: json['main']['pressure'] ?? 0,
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      windDegree: json['wind']['deg'] ?? 0,
      cloudiness: json['clouds']['all'] ?? 0,
      mainCondition: json['weather'][0]['main'] ?? 'Unknown',
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      sunrise: json['sys']['sunrise'] ?? 0,
      sunset: json['sys']['sunset'] ?? 0,
      visibility: (json['visibility'] ?? 0).toDouble(),
      rainVolume: (json['rain']?['1h'] ?? 0).toDouble(),
      snowVolume: (json['snow']?['1h'] ?? 0).toDouble(),
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      timezone: json['timezone'] ?? 0,
      cod: json['cod'] is String ? int.parse(json['cod']) : json['cod'] ?? 200,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'sys': {'country': countryCode, 'sunrise': sunrise, 'sunset': sunset},
      'coord': {'lat': latitude, 'lon': longitude},
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'pressure': pressure,
        'humidity': humidity,
      },
      'wind': {'speed': windSpeed, 'deg': windDegree},
      'clouds': {'all': cloudiness},
      'weather': [{'main': mainCondition, 'description': description, 'icon': icon}],
      'visibility': visibility,
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'timezone': timezone,
      'cod': cod,
    };
  }
}

class ForecastModel {
  final List<ForecastItem> list;
  final int cnt;
  final String cod;
  final String city;
  final double latitude;
  final double longitude;

  ForecastModel({
    required this.list,
    required this.cnt,
    required this.cod,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      list: List<ForecastItem>.from(
        (json['list'] as List).map((x) => ForecastItem.fromJson(x)),
      ),
      cnt: json['cnt'] ?? 0,
      cod: json['cod'] ?? '',
      city: json['city']['name'] ?? 'Unknown',
      latitude: (json['city']['coord']['lat'] ?? 0.0).toDouble(),
      longitude: (json['city']['coord']['lon'] ?? 0.0).toDouble(),
    );
  }
}

class ForecastItem {
  final int dt;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final String mainCondition;
  final String description;
  final String icon;
  final double windSpeed;
  final double rainVolume;
  final DateTime dateTime;

  ForecastItem({
    required this.dt,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.mainCondition,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.rainVolume,
    required this.dateTime,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dt: json['dt'] ?? 0,
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      tempMin: (json['main']['temp_min'] ?? 0).toDouble(),
      tempMax: (json['main']['temp_max'] ?? 0).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      mainCondition: json['weather'][0]['main'] ?? 'Unknown',
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      rainVolume: (json['rain']?['3h'] ?? 0).toDouble(),
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    );
  }
}
