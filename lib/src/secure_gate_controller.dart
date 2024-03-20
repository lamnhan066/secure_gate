import 'dart:async';

import 'package:flutter/material.dart';

class SecureGateController {
  /// Build-in instance for [SecureGateController]
  static SecureGateController? _instance;
  static SecureGateController get instance {
    // If there is a valid instance.
    if (_instance != null && !_instance!._streamController.isClosed) {
      return _instance!;
    }

    // If there is a valid instance but the `_streamController` is closed.
    if (_instance != null && _instance!._streamController.isClosed) {
      _instance = SecureGateController(
        lockOnStart: _instance!._lockOnStart,
        overlayBuilder: _instance!.overlayBuilder,
      );
      return _instance!;
    }

    _instance = SecureGateController();
    return _instance!;
  }

  bool _lock = true;
  final bool _lockOnStart;

  /// `true` if the screen is locked, otherwise is `false`.
  bool get isLocked => _lock;

  /// `true` if the screen is unlocked, otherwise is `false`.
  bool get isUnlocked => !_lock;

  bool _on = true;

  /// `true` if the securer is active, otherwise is `false`.
  ///
  /// You can not use [lock] or [unlock] method when this value is `false`.
  bool get isOn => _on;

  /// `true` if the securer is inactive, otherwise is `false`.
  ///
  /// You can not use [lock] or [unlock] method when this value is `true`.
  bool get isOff => !_on;

  final StreamController<bool> _streamController = StreamController.broadcast();
  Stream<bool> get stream => _streamController.stream;

  /// A global overlay widget, this is a default overlay for all `SecureGate`
  /// that use the same `controller`. You can use the `controller` to `lock` or `unlock`
  /// the screen.  If you set the `overlayBuilder` parameter in both [SecureGateController]
  /// and `SecureGate`, the `SecureGate` one will be used.
  Widget Function(BuildContext context, SecureGateController controller)?
      overlayBuilder;

  /// This is a global callback that will be called when the device is focused. You can
  /// use something like biometric authentication here. If you set the `overlayBuilder` parameter
  /// in both [SecureGateController] and `SecureGate`, the `SecureGate` one will be used.
  final FutureOr<void> Function(
      BuildContext context, SecureGateController controller)? onFocus;

  /// Create a new instance for the controller. The SecureGate will automatically
  /// locked when it starts if [lockOnStart] is `true`.
  ///
  /// You can use the same overlayBuilder across pages by setting the [overlayBuilder] Widget.
  /// If you set the `overlayBuilder` parameter in both SecureGateController and SecureGate,
  /// the SecureGate one will be used.
  ///
  /// You can use [SecureGateController.instance] to get the singleton instance
  /// of the controller.
  SecureGateController({
    bool lockOnStart = true,
    this.overlayBuilder,
    this.onFocus,
  }) : _lockOnStart = lockOnStart {
    _lock = lockOnStart;
  }

  /// Dispose this controller. You should call this when there is no `SecureGate`
  /// is needed to use.
  void dispose() {
    _streamController.close();
  }

  /// Lock the screen.
  ///
  /// This will do nothing if the `SecureGateController` [isOff].
  void lock() {
    _setLock(true);
  }

  /// Unlock the screen.
  ///
  /// This will do nothing if the `SecureGateController` [isOff].
  void unlock() {
    _setLock(false);
  }

  void _setLock(bool isLock) {
    if (!_on) return;

    if (isLock) {
      _lock = true;
      _streamController.sink.add(true);
    } else {
      _lock = false;
      _streamController.sink.add(false);
    }
  }

  /// Turn on the controller.
  ///
  /// If [isLock] is `true`, the screen will be locked after turning on.
  void on({bool isLock = true}) {
    _on = true;

    if (isLock) lock();
  }

  /// Turn off the controller. You cannot `lock()` and `unlock()` when the controller
  /// is turned off.
  ///
  /// If [isUnlock] is `true`, the screen will be unlocked before turning off.
  void off({bool isUnlock = true}) {
    if (isUnlock) unlock();

    _on = false;
  }

  @override
  String toString() => 'SecureGateController(lock: $_lock, on: $_on)';
}
