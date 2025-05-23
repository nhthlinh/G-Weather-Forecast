import 'package:flutter/material.dart';
import 'package:g_feather_forecast/view_models/daily_weather_view_model.dart';
import 'package:provider/provider.dart';

class DailyWeather extends StatefulWidget {
  const DailyWeather({super.key});

  @override
  State<DailyWeather> createState() => _DailyWeatherState();
}

class _DailyWeatherState extends State<DailyWeather> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Invalid email';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DailyWeatherViewModel>();
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;
    final isTabletOnly = width >= 700 && width < 1300;
    final boxWidth = isMobile
        ? double.infinity
        : isTabletOnly
            ? 135.0
            : 150.0;

    return Column(
      children: [
        SizedBox(
          width: width,
          height: 60,
          child: Form(
            key: _formKey,
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email to register daily weather',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(2),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              validator: _validateEmail,
              readOnly: vm.emailRegister.isNotEmpty,
            ),
          ),
        ),

        const SizedBox(height: 8),

        Flex(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          children: [
            SizedBox(
              width: boxWidth,
              height: 40,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: vm.emailRegister.isEmpty
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          vm.sendEmailVerification(
                            _emailController.text,
                            context,
                          );
                        }
                      }
                    : null,
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: boxWidth,
              height: 40,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                    const Color.fromARGB(255, 128, 128, 128),
                  ),
                ),
                onPressed: vm.emailRegister.isEmpty
                    ? () {
                        vm.unSubscribeEmail(_emailController, context);
                    }
                    : null, 
                child: const Text(
                  'Unsubscribe',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
