import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../view_models/weather_view_model.dart';

// ignore: must_be_immutable
class Forecast extends StatefulWidget {
  Forecast({
    super.key,
    required this.weatherVM,
    required this.forecastDays,
    required this.controller,
  });

  final TextEditingController controller;
  int forecastDays = 4;
  final WeatherViewModel weatherVM;

  @override
  State<Forecast> createState() => _ForecastState();
}

class _ForecastState extends State<Forecast> {
  void _onViewMoreForecast(WeatherViewModel weatherVM) async {
    widget.forecastDays += 4;

    if (widget.controller.text.isEmpty) {
      await weatherVM.forecastWeather(days: widget.forecastDays);
    } else {
      await weatherVM.forecastWeather(
        location: widget.controller.text,
        days: widget.forecastDays,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherVM = context.watch<WeatherViewModel>();

    return Builder(
      builder: (context) {
        if (weatherVM.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SizedBox(
          height: 180,
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: weatherVM.forecast.length + 1, // +1 để thêm nút
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (BuildContext context, int index) {
              if (index == weatherVM.forecast.length) {
                // Nút View More
                return ElevatedButton(
                  onPressed: () => _onViewMoreForecast(weatherVM),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: const Text(
                    "View More",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              // Dự báo thời tiết
              final forecast = weatherVM.forecast[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C757D),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    fontFamily: GoogleFonts.rubik().fontFamily,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "(${forecast.localtime.split(" ")[0]})",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Image(
                        height: 50,
                        image: NetworkImage(forecast.weatherIcon),
                      ),
                      Text("Temperature: ${forecast.temperature} °C"),
                      Text("Wind: ${forecast.wind} M/S"),
                      Text("Humidity: ${forecast.humidity}%"),
                    ],
                  ),
                ),
              );
            },
          ),
        );

        // return Column(
        //   children: [

        //     // SizedBox(
        //     //   height: 200,
        //     //   child: GridView.builder(
        //     //     physics: const BouncingScrollPhysics(),
        //     //     scrollDirection: Axis.horizontal,
        //     //     itemCount: weatherVM.forecast.length,
        //     //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //     //       crossAxisCount: 1,
        //     //       mainAxisSpacing: 16,
        //     //     ),
        //     //     itemBuilder: (BuildContext context, int index) {
        //     //       final forecast = weatherVM.forecast[index];
        //     //       return Container(
        //     //         padding: const EdgeInsets.all(16),
        //     //         decoration: BoxDecoration(
        //     //           color: const Color(0xFF6C757D),
        //     //           borderRadius: BorderRadius.circular(4),
        //     //         ),
        //     //         child: DefaultTextStyle(
        //     //           style: TextStyle(
        //     //             color: Colors.white,
        //     //             fontSize: 14,
        //     //             fontWeight: FontWeight.w300,
        //     //             fontFamily: GoogleFonts.rubik().fontFamily,
        //     //           ),
        //     //           child: Column(
        //     //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     //             crossAxisAlignment: CrossAxisAlignment.start,
        //     //             children: [
        //     //               Text(
        //     //                 "(${forecast.localtime.split(" ")[0]})",
        //     //                 style: const TextStyle(
        //     //                   fontSize: 16,
        //     //                   fontWeight: FontWeight.w600,
        //     //                 ),
        //     //               ),
        //     //               Image(
        //     //                 height: 50,
        //     //                 image: NetworkImage(
        //     //                   forecast.weatherIcon,
        //     //                 ),
        //     //               ),
        //     //               Text("Temperature: ${forecast.temperature} °C"),
        //     //               Text("Wind: ${forecast.wind} M/S"),
        //     //               Text("Humidity: ${forecast.humidity}%"),
        //     //             ],
        //     //           ),
        //     //         ),
        //     //       );
        //     //     },
        //     //   ),
        //     // ),

        //     // const SizedBox(height: 16),

        //     // if (weatherVM.forecast.isNotEmpty)
        //     //   ElevatedButton(
        //     //     onPressed: () => _onViewMoreForecast(weatherVM),
        //     //     style: ElevatedButton.styleFrom(
        //     //       backgroundColor: Theme.of(context).primaryColor,
        //     //       shape: RoundedRectangleBorder(
        //     //         borderRadius: BorderRadius.circular(2),
        //     //       ),
        //     //     ),
        //     //     child: const Text(
        //     //       "View More",
        //     //       style: TextStyle(color: Colors.white),
        //     //     ),
        //     //   ),
        //   ],
        // );
      },
    );
  }
}
