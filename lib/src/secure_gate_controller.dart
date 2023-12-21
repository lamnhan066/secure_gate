import 'dart:async';

class SecureGateController {
  static SecureGateController instance = SecureGateController();

  bool _lock = true;

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

  /// Create a new instance for the controller.
  ///
  /// You can use `SecureGateController.instance` to get the singleton instance
  /// of the controller.
  SecureGateController();

  /// Lock the screen.
  ///
  /// This will do nothing if the `SecureGateController` [isOff].
  void lock() {
    if (!_on) return;

    _lock = true;
    _streamController.sink.add(true);
  }

  /// Unlock the screen.
  ///
  /// This will do nothing if the `SecureGateController` [isOff].
  void unlock() {
    if (!_on) return;

    _lock = false;
    _streamController.sink.add(false);
  }

  /// Turn on the securer.
  void on() {
    _on = true;
    lock();
  }

  /// Turn off the securer.
  void off() {
    unlock();
    _on = false;
  }

  @override
  String toString() => 'SecureGateController(lock: $_lock, on: $_on)';
}
