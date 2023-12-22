import 'listener_stub.dart' if (dart.library.html) 'listener_web.dart';

class SecureGateListener {
  final _delegate = SecureGateListenerImplement();

  /// Get the `stream` of this Listener.
  Stream<void> get stream => _delegate.stream;

  /// Initialize.
  void init() => _delegate.init();

  /// Dispose.
  void dispose() => _delegate.dispose();
}
