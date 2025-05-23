import 'package:g_feather_forecast/configs/config.dart';
import 'package:g_feather_forecast/models/weather_model.dart';

class WeatherRepository {
  Future<WeatherModel> fetchWeather(String location) async {
    final response = await DioConfig.dio.get('/current.json?q=$location');
    return WeatherModel.fromJson(response.data);
  }

  Future<List<WeatherModel>> forecastWeather(String location, int days) async {
    final response = await DioConfig.dio
        .get('/forecast.json?q=$location&days=$days&alerts=no&aqi=no&hour=0');
    final locationResult = response.data['location'];
    final forecastResult = response.data['forecast']['forecastday'];
    forecastResult.removeAt(0);
    return forecastResult
        .map<WeatherModel>((json) => WeatherModel(
            location: locationResult['name'],
            localtime: json['date'],
            temperature: json['day']['avgtemp_c'].toString(),
            wind: json['day']['maxwind_mph'].toString(),
            humidity: json['day']['avghumidity'].toString(),
            weather: json['day']['condition']['text'],
            weatherIcon: json['day']['condition']['icon']))
        .toList();
  }
}
