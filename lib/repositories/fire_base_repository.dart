import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum RegistrationResult {
  verificationEmailSent,
  alreadyRegistered,
  emailConflict,
  error,
  invalidEmail,
  tooManyRequests,
}

enum UnsubscribeResult { success, error, tooManyRequests, userNotFound }

class FirebaseRepository {
  final acs = ActionCodeSettings(
    url: 'https://g-weather-forecast-43115.web.app',
    handleCodeInApp: true,
    iOSBundleId: 'com.example.ios',
    androidPackageName: 'com.example.android', // Thay bằng đúng package
    androidInstallApp: true,
    androidMinimumVersion: '12',
  );

  Future<RegistrationResult> registerForWeatherEmail(String email) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: email);

      await credential.user?.sendEmailVerification(acs);
      log('Verification email sent to $email');

      return RegistrationResult.verificationEmailSent;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        log('User already registered.');
        return RegistrationResult.alreadyRegistered;
      } else if (e.code == 'invalid-email') {
        log('Invalid email format.');
        return RegistrationResult.invalidEmail;
      } else if (e.code == 'wrong-password') {
        log('Email is already in use with a different password.');
        return RegistrationResult.emailConflict;
      } else if (e.code == 'too-many-requests') {
        log('Too many attempts, please try again later.');
        return RegistrationResult.error;
      } else {
        log('Firebase auth error: ${e.code} | ${e.message}');
        return RegistrationResult.error;
      }
    } catch (e) {
      log('Unexpected error: $e');
      return RegistrationResult.error;
    }
  }

  Future<bool> isEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    await user.reload();
    return user.emailVerified;
  }

  Future<UnsubscribeResult> unsubscribeFromWeatherEmail(
    TextEditingController emailController,
  ) async {
    try {
      final email = emailController.text.trim();

      // Đăng nhập với email và mật khẩu
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email,
            password: email, // nếu dùng email làm password
          );

      final user = userCredential.user;

      if (user == null) {
        log("User vẫn null sau khi đăng nhập");
        return UnsubscribeResult.userNotFound;
      }

      // Xoá document trong Firestore (subscriptions) theo email
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('subscriptions')
          .where('email', isEqualTo: email)
          .get();

      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
        log('Đã xoá document subscriptions/${doc.id}');
      }

      // Xác thực lại người dùng trước khi xóa
      await user.delete();
      emailController.clear();
      log('User $email đã được hủy đăng ký (unsubscribed)');
      return UnsubscribeResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        log('Không tìm thấy người dùng (có thể đã bị xóa).');
        return UnsubscribeResult.userNotFound;
      } else if (e.code == 'wrong-password') {
        log('Sai mật khẩu.');
        return UnsubscribeResult.error;
      } else if (e.code == 'too-many-requests') {
        log('Too many requests.');
        return UnsubscribeResult.tooManyRequests;
      } else {
        log('Firebase auth error: ${e.code} | ${e.message}');
        return UnsubscribeResult.error;
      }
    } catch (e) {
      log('Unexpected error: $e');
      return UnsubscribeResult.error;
    }
  }

  Future<void> checkEmailVerification(String email, String ip) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    for (int i = 0; i < 50; i++) {
      // Đăng nhập lại để đảm bảo trạng thái mới được lấy từ server
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: email, // hoặc mật khẩu thật sự nếu có
      );

      var user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      
      log('Đã reload lần $i. Trạng thái xác minh: ${user?.emailVerified}');

      if (user != null && user.emailVerified) {
        log('Email verified');

        await FirebaseFirestore.instance.collection('subscriptions').add({
          'email': email,
          'location': ip,
        });
        log('Đã thêm vào Firestore');
        return;
      }

      await Future.delayed(const Duration(seconds: 5));
    }
    log('Email not verified after waiting.');
  }

}
