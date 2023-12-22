import 'dart:async';

import 'package:flutter/material.dart';
import 'package:secure_gate/src/listeners/listener.dart';
import 'package:secure_gate/src/listeners/listener_state.dart';

class SecureGateListenerImplement
    with WidgetsBindingObserver
    implements SecureGateListener {
  final _controller = StreamController<SecureGateListenerState>();

  SecureGateListenerImplement();

  @override
  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller.sink.add(SecureGateListenerState.focus);
    } else {
      _controller.sink.add(SecureGateListenerState.blur);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Stream<SecureGateListenerState> get stream => _controller.stream;
}
