import 'dart:async';

import 'package:flutter/material.dart';
import 'package:secure_gate/src/listeners/listener.dart';

class SecureGateListenerImplement
    with WidgetsBindingObserver
    implements SecureGateListener {
  final StreamController _controller = StreamController.broadcast();

  SecureGateListenerImplement();

  @override
  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _controller.sink.add(true);
    super.didChangeAppLifecycleState(state);
  }

  @override
  Stream<void> get stream => _controller.stream;
}
