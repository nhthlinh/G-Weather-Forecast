import 'package:flutter/material.dart';
import 'package:g_feather_forecast/view_models/daily_weather_view_model.dart';
import 'package:g_feather_forecast/view_models/location_view_model.dart';
import 'package:g_feather_forecast/view_models/weather_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:g_feather_forecast/firebase_options.dart';
import 'package:g_feather_forecast/views/home_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocationViewModel()),
        ChangeNotifierProvider(create: (context) => WeatherViewModel()),
        ChangeNotifierProvider(create: (context) => DailyWeatherViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'G Weather Forecast',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        primaryColor: const Color(0xFF5372F0),
        useMaterial3: true,
        textTheme: GoogleFonts.rubikTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
