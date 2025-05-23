import 'package:flutter/material.dart';
import 'package:g_feather_forecast/view_models/weather_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final weatherVM = context.watch<WeatherViewModel>();
    final weather = weatherVM.weather;

    return Builder(builder: (context) {
      if (weatherVM.isLoading) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Theme.of(context).primaryColor,
          ),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        );
      }
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Theme.of(context).primaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w300,
                fontFamily: GoogleFonts.rubik().fontFamily,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${weather.location} (${weather.localtime.split(" ")[0]})',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text("Temperature: ${weather.temperature} °C"),
                  const SizedBox(height: 8),
                  Text("Wind: ${weather.wind} M/S"),
                  const SizedBox(height: 8),
                  Text("Humidity: ${weather.humidity}%"),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Image(
                    image: NetworkImage(
                      weather.weatherIcon,
                    ),
                  ),
                  Text(
                    weather.weather,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    maxLines: null,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            
          ],
        ),
      );
    });
  }
}
