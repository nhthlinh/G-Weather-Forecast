class WeatherModel {
  final String location;
  final String localtime;
  final String temperature;
  final String wind;
  final String humidity;
  final String weather;
  final String weatherIcon;

  WeatherModel({
    required this.location,
    required this.localtime,
    required this.temperature,
    required this.wind,
    required this.humidity,
    required this.weather,
    required this.weatherIcon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      location: json['location']['name'] as String,
      localtime: json['location']['localtime'] as String,
      temperature: json['current']['temp_c'].toString(),
      wind: json['current']['wind_mph'].toString(),
      humidity: json['current']['humidity'].toString(),
      weather: json['current']['condition']['text'] as String,
      weatherIcon: json['current']['condition']['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'localtime': localtime,
      'temperature': temperature,
      'wind': wind,
      'humidity': humidity,
      'weather': weather,
      'weatherIcon': weatherIcon,
    };
  }

  WeatherModel copyWith({
    String? location,
    String? localtime,
    String? temperature,
    String? wind,
    String? humidity,
    String? weather,
    String? weatherIcon,
  }) {
    return WeatherModel(
      location: location ?? this.location,
      localtime: localtime ?? this.localtime,
      temperature: temperature ?? this.temperature,
      wind: wind ?? this.wind,
      humidity: humidity ?? this.humidity,
      weather: weather ?? this.weather,
      weatherIcon: weatherIcon ?? this.weatherIcon,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is WeatherModel &&
            location == other.location &&
            localtime == other.localtime &&
            temperature == other.temperature &&
            wind == other.wind &&
            humidity == other.humidity &&
            weather == other.weather &&
            weatherIcon == other.weatherIcon);
  }

  @override
  int get hashCode => Object.hash(
        location,
        localtime,
        temperature,
        wind,
        humidity,
        weather,
        weatherIcon,
      );

  @override
  String toString() {
    return 'WeatherModel(location: $location, localtime: $localtime, temperature: $temperature, wind: $wind, humidity: $humidity, weather: $weather, weatherIcon: $weatherIcon)';
  }
}
