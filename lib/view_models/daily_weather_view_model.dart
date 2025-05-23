import 'package:dart_ipify/dart_ipify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g_feather_forecast/repositories/fire_base_repository.dart';

class DailyWeatherViewModel extends ChangeNotifier {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  String _emailRegister = '';

  String get emailRegister => _emailRegister;

  bool get isEmailVerified =>
      FirebaseAuth.instance.currentUser?.emailVerified ?? false;

  Future<void> sendEmailVerification(String email, BuildContext context) async {
    final result = await _firebaseRepository.registerForWeatherEmail(email);

    if (!context.mounted) return;

    switch (result) {
      case RegistrationResult.verificationEmailSent:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check your email to verify.')),
        );
        break;
      case RegistrationResult.alreadyRegistered:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email already registered.')),
        );
        break;
      case RegistrationResult.emailConflict:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email is registered with a different password.'),
          ),
        );
        break;
      case RegistrationResult.error:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error during email registration.')),
        );
        break;
      case RegistrationResult.invalidEmail:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Invalid email format.')));
        break;
      case RegistrationResult.tooManyRequests:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Too many attempts, please try again later.'),
          ),
        );
        break;
    }

    await _firebaseRepository.checkEmailVerification(email,  await Ipify.ipv4());
  }

  Future<void> unSubscribeEmail(
    TextEditingController emailController,
    BuildContext context,
  ) async {
    try {
      final result = await _firebaseRepository.unsubscribeFromWeatherEmail(
        emailController,
      );
      _emailRegister = '';
      emailController.clear();
      notifyListeners();

      switch (result) {
        case UnsubscribeResult.success:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unsubscribed successfully.')),
          );
          break;
        case UnsubscribeResult.userNotFound:
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('User not found.')));
          break;
        case UnsubscribeResult.error:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error during unsubscription.')),
          );
          break;
        case UnsubscribeResult.tooManyRequests:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Too many requests, please try again later.'),
            ),
          );
          break;
      }
    } catch (e) {
      debugPrint('Error when unsubscribing: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to unsubscribe: $e')));
      }
    }
  }
}
