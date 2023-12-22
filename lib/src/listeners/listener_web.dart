// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html';

import 'package:secure_gate/src/listeners/listener.dart';
import 'package:secure_gate/src/listeners/listener_state.dart';

class SecureGateListenerImplement implements SecureGateListener {
  StreamSubscription? _subBlur;
  StreamSubscription? _subFocus;
  final _controller = StreamController<SecureGateListenerState>();

  SecureGateListenerImplement();

  @override
  Stream<SecureGateListenerState> get stream => _controller.stream;

  @override
  void init() {
    _subBlur = window.onBlur.listen((event) {
      _controller.sink.add(SecureGateListenerState.blur);
    });

    _subFocus = window.onFocus.listen((event) {
      _controller.sink.add(SecureGateListenerState.focus);
    });
  }

  @override
  void dispose() {
    _subBlur?.cancel();
    _subFocus?.cancel();
    _controller.close();
  }
}
