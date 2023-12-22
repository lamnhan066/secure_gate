import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

Future<bool> isBiometricAuthenticated() async {
  await Future.delayed(const Duration(seconds: 1));
  if (kIsWeb || !await _authenticateIsAvailable()) {
    return false;
  }

  var localAuth = LocalAuthentication();
  return await localAuth.authenticate(
    localizedReason: 'Please confirm to continue..',
  );
}

Future<bool> _authenticateIsAvailable() async {
  var localAuth = LocalAuthentication();
  final isDeviceSupported = await localAuth.isDeviceSupported();
  if (!isDeviceSupported) return false;

  final isAvailable = await localAuth.canCheckBiometrics;
  return isAvailable;
}
