// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html';

import 'package:secure_gate/src/listeners/listener.dart';

class SecureGateListenerImplement implements SecureGateListener {
  StreamSubscription? _sub;
  final StreamController _controller = StreamController.broadcast();

  SecureGateListenerImplement();

  @override
  Stream<void> get stream => _controller.stream;

  @override
  void init() {
    _sub = window.onBlur.listen((event) {
      _controller.sink.add(true);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}
