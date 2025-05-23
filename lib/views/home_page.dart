import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:g_feather_forecast/view_models/location_view_model.dart';
import 'package:g_feather_forecast/view_models/weather_view_model.dart';
import 'package:g_feather_forecast/widgets/daily_weather.dart';
import 'package:g_feather_forecast/widgets/forecast.dart';
import 'package:g_feather_forecast/widgets/history_location.dart';
import 'package:g_feather_forecast/widgets/weather.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final SearchController _searchController = SearchController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  final int _forecastDays = 4;

  @override
  void initState() {
    final weatherVM = context.read<WeatherViewModel>();
    final locationVM = context.read<LocationViewModel>();
    fetchInitialData(weatherVM, locationVM);
    super.initState();
  }

  Future<void> fetchInitialData(
    WeatherViewModel weatherVM,
    LocationViewModel locationVM,
  ) async {
    try {
      await weatherVM.fetchWeather();
      await weatherVM.forecastWeather(days: _forecastDays);
      await locationVM.getHistoryLocation();
      setState(() {});
    } catch (e) {
      debugPrint('Error fetching initial data: $e');
    }
  }

  void _onSearchChanged(String query, LocationViewModel locationVM) {
    if (query.isEmpty) return;

    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      await locationVM.fetchLocation(query);
      rebuildSuggestions();
      setState(() {});
    });
  }

  void _onFetchWeather(WeatherViewModel weatherVM) async {
    if (_controller.text.isEmpty) return;

    await weatherVM.fetchWeather(location: _controller.text);
    await weatherVM.forecastWeather(
      location: _controller.text,
      days: _forecastDays,
    );
    setState(() {});
  }

  void _onFetchWeatherCurrentLocation(WeatherViewModel weatherVM) async {
    await weatherVM.fetchWeather();
    await weatherVM.forecastWeather(days: _forecastDays);
    setState(() {});
  }

  void _onSaveHistory(LocationViewModel locationVM, int index) async {
    if (_controller.text.isEmpty) return;
    if (index < 0 || index >= locationVM.locations.length) return;

    locationVM.saveHistoryLocation(locationVM.locations[index]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });

    setState(() {});
  }

  void rebuildSuggestions() {
    final previousText = _searchController.text;
    _searchController.text = '';
    _searchController.text = previousText;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 700;
    final weatherVM = context.watch<WeatherViewModel>();
    final locationVM = context.watch<LocationViewModel>();
    final locations = locationVM.locations;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(
          child: const Text(
            'Weather Dashboard',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
      body: Container(
        padding: isMobile ? const EdgeInsets.all(16) : const EdgeInsets.all(40),
        color: const Color(0xFFE3F3FD),
        child: Center(
          child: Builder(
            builder: (context) {
              final content = Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                children: [
                  Builder(builder: (context) {
                    final col = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Enter a City Name",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 8),

                        SearchAnchor.bar(
                          constraints: const BoxConstraints(minHeight: 40),
                          searchController: _searchController,
                          barHintText: "Eg., New York, London, Tokyo",
                          barLeading: null,
                          barBackgroundColor: const WidgetStatePropertyAll(
                            Colors.white,
                          ),
                          barTextStyle: const WidgetStatePropertyAll(
                            TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          barShape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                          ),
                          barPadding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          ),
                          barElevation: const WidgetStatePropertyAll(0),
                          suggestionsBuilder: (context, controller) {
                            return locations
                                .where(
                                  (loc) => loc.name.toLowerCase().contains(
                                    controller.text.toLowerCase(),
                                  ),
                                )
                                .map(
                                  (location) {
                                    final index = locationVM.locations.indexOf(location);
                                    return ListTile(
                                      title: Text(location.name),
                                      onTap: () {
                                        _controller.text = location.name;
                                        _onFetchWeather(weatherVM);
                                        _onSaveHistory(locationVM, index);
                                        setState(() {
                                          controller.closeView(location.name);
                                        });
                                      },
                                    );
                                  }
                                )
                                .toList();
                          },
                          onChanged: (value) => {
                            _onSearchChanged(value, locationVM),
                          },
                        ),

                        const SizedBox(height: 8),

                        SizedBox(
                          width: width,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              _onFetchWeather(weatherVM);
                              _onSaveHistory(locationVM, 0);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            child: const Text(
                              "Search",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                "or",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 128, 128, 128),
                                ),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),

                        const SizedBox(height: 8),

                        SizedBox(
                          width: width,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () =>
                                _onFetchWeatherCurrentLocation(weatherVM),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                128,
                                128,
                                128,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            child: const Text(
                              "Use Current Location",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        if (!isMobile)
                          SizedBox(
                            height: locationVM.historyLocations.isNotEmpty
                              ? min(
                                  locationVM.historyLocations.length * 70,
                                  200.0,
                                )
                              : 0,
                            child: HistoryLocation(
                              onFetchWeather: _onFetchWeather,
                              searchController: _controller,
                            ),
                          ),

                        if (!isMobile) const SizedBox(height: 16),

                        if (!isMobile)
                          const Text(
                            "Enter your email",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                        if (!isMobile) const SizedBox(height: 8),

                        if (!isMobile)
                          DailyWeather(),
                      ],
                    );

                    if (isMobile) {
                      return SingleChildScrollView(
                        controller: _scrollController,
                        child: col,
                      );
                    }
                    return Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: col,
                      ),
                    );
                  }),

                  if (!isMobile) const SizedBox(width: 40),

                  Builder(builder: (context) {
                    final col = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Weather(),

                        if (isMobile)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: SizedBox(
                              height: locationVM.historyLocations.isNotEmpty
                                ? min(
                                    locationVM.historyLocations.length * 70,
                                    200.0,
                                  )
                                : 0,
                              child: HistoryLocation(
                                onFetchWeather: _onFetchWeather,
                                searchController: _controller,
                              ),
                            ),
                          ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            "4-Days Forecast",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        Forecast(
                          controller: _controller,
                          weatherVM: weatherVM,
                          forecastDays: _forecastDays,
                        ),

                        if (isMobile) const SizedBox(height: 16),

                        if (isMobile)
                          const Text(
                            "Enter your email",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                        if (isMobile) const SizedBox(height: 8),

                        if (isMobile)
                          DailyWeather(),
                      ],
                    );

                    if (isMobile) return col;
                    return Expanded(
                      flex: 2,
                      child: col,
                    );
                  })
                
                ],
              );
              if (isMobile) return SingleChildScrollView(child: content);
              return content;
            },
          ),
        ),
      ),
    );
  }
}
