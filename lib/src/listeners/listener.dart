import 'listener_stub.dart' if (dart.library.html) 'listener_web.dart';

class SecureGateListener {
  final _delegate = SecureGateListenerImplement();

  Stream<void> get stream => _delegate.stream;
  void init() => _delegate.init();
  void dispose() => _delegate.dispose();
}
