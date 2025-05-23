import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/location_view_model.dart';
import '../view_models/weather_view_model.dart';

class HistoryLocation extends StatefulWidget {
  const HistoryLocation(
      {super.key,
      required this.onFetchWeather,
      required this.searchController});

  final void Function(WeatherViewModel weatherVM) onFetchWeather;
  final TextEditingController searchController;

  @override
  State<HistoryLocation> createState() => _HistoryState();
}

class _HistoryState extends State<HistoryLocation> {
  @override
  Widget build(BuildContext context) {
    // Using Provider to access the LocationViewModel and WeatherViewModel
    // to get the history locations and fetch weather data.
    final locationVM = context.watch<LocationViewModel>();
    final weatherVM = context.watch<WeatherViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "History",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: locationVM.historyLocations.length,
            itemBuilder: (BuildContext context, int index) {
              final history = locationVM.historyLocations[index];
              return ListTile(
                title: Text('${history.name} (${history.country})'),
                onTap: () {
                  widget.searchController.text = history.name;
                  widget.onFetchWeather(weatherVM);
                },
              );
            },
          ),
        )
      ],
    );
  }
}
