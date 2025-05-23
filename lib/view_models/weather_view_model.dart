
import 'package:flutter/material.dart';
import 'package:g_feather_forecast/models/weather_model.dart';
import 'package:g_feather_forecast/repositories/weather_repository.dart';
import 'package:dart_ipify/dart_ipify.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository _weatherRepository = WeatherRepository();
  WeatherModel _weather = WeatherModel(
      location: '',
      temperature: '',
      wind: '',
      humidity: '',
      weather: '',
      weatherIcon: 'https://cdn.weatherapi.com/weather/64x64/day/113.png',
      localtime: '');
  final List<WeatherModel> _forecast = [];
  bool _isLoading = false;

  WeatherModel get weather => _weather;
  List<WeatherModel> get forecast => _forecast;
  bool get isLoading => _isLoading;

  Future<void> fetchWeather({String? location}) async {
    _isLoading = true;
    notifyListeners();
    if (location == null) {
      final ip = await Ipify.ipv4();
      _weather = await _weatherRepository.fetchWeather(ip);
      notifyListeners();
      return;
    }
    _weather = await _weatherRepository.fetchWeather(location);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> forecastWeather({String? location, required int days}) async {
    _isLoading = true;
    notifyListeners();
    _forecast.clear();
    if (location == null) {
      final ip = await Ipify.ipv4();
      final forecast = await _weatherRepository.forecastWeather(ip, days + 1);
      _forecast.addAll(forecast);
      _isLoading = false;
      notifyListeners();
      return;
    }
    final forecast =
        await _weatherRepository.forecastWeather(location, days + 1);
    _forecast.addAll(forecast);
    _isLoading = false;
    notifyListeners();
  }
}
