import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:secure_gate/src/listeners/listener.dart';
import 'package:secure_gate/src/listeners/listener_state.dart';

import 'secure_gate_controller.dart';

class SecureGate extends StatefulWidget {
  /// [SecureGate] use a build-in singleton controller to control the state if
  /// you not specify the [controller]. You can get this by using [SecureGateController.instance]
  /// or inside the [overlayBuilder] parameter.
  ///
  /// You can use [overlayBuilder] to put any [Widget] above the blur screen or you
  /// can put the biometric authentication inside it. If you set the `overlayBuilder`
  /// parameter in both SecureGateController and SecureGate, the SecureGate one will be used.
  const SecureGate({
    super.key,
    this.controller,
    required this.child,
    this.onFocus,
    this.overlayBuilder,
    this.color,
    this.blur = 15,
    this.opacity = 0.6,
  });

  /// [SecureGateController].
  ///
  /// Default is [SecureGateController.instance].
  final SecureGateController? controller;

  /// Child widget.
  final Widget child;

  /// Put an overlay widget. You can use the [controller] to `lock` or `unlock`
  /// the screen. You can set the global `overlayBuilder` in `SecureGateController` so
  /// it can be used across pages. If you set the `overlayBuilder` parameter in both
  /// [SecureGateController] and [SecureGate], the [SecureGate] one will be used.
  final Widget Function(BuildContext context, SecureGateController controller)?
      overlayBuilder;

  /// This is a callback that will be called when the device is focused. You can
  /// use something like biometric authentication here. You can set the global `onFocus`
  /// in `SecureGateController` so it can be used across pages. If you set the `overlayBuilder` parameter
  /// in both [SecureGateController] and [SecureGate], the [SecureGate] one will be used.
  final FutureOr<void> Function(
      BuildContext context, SecureGateController controller)? onFocus;

  /// Blur of the blur screen.
  final double blur;

  /// Opacity of the blur screen.
  final double opacity;

  /// Defalt color is `Colors.grey.shade200`.
  final Color? color;

  @override
  State<SecureGate> createState() => _SecureGateState();
}

class _SecureGateState extends State<SecureGate>
    with SingleTickerProviderStateMixin {
  late AnimationController _gateVisibility;
  late StreamSubscription<bool> _sub;
  late SecureGateController _controller;
  late Color _color;
  FutureOr<void> Function(
      BuildContext context, SecureGateController controller)? _onFocus;

  final _secureGateListener = SecureGateListener();
  late StreamSubscription _secureGateSub;

  bool _needStopListenToEvent = false;

  @override
  void initState() {
    _controller = widget.controller ?? SecureGateController.instance;
    _color = widget.color ?? Colors.grey.shade200;
    _onFocus = widget.onFocus ?? _controller.onFocus;

    _secureGateListener.init();
    _secureGateSub = _secureGateListener.stream.listen((event) async {
      if (_needStopListenToEvent) return;
      _needStopListenToEvent = true;

      switch (event) {
        case SecureGateListenerState.blur:
          if (_controller.isUnlocked) {
            setState(() {
              _controller.lock();
            });
          }
        case SecureGateListenerState.focus:
          if (_controller.isLocked) {
            await _onFocusCallback();
          }
      }
      _needStopListenToEvent = false;
    });

    _gateVisibility =
        AnimationController(vsync: this, duration: kThemeAnimationDuration * 2)
          ..addListener(_updateState);
    _sub = _controller.stream.listen(_callback);

    _callback(_controller.isLocked);
    if (_controller.isLocked && _onFocus != null) {
      _needStopListenToEvent = true;
      _onFocusCallback().then((value) {
        _needStopListenToEvent = false;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _sub.cancel();
    _gateVisibility.dispose();
    _secureGateSub.cancel();
    _secureGateListener.dispose();
    super.dispose();
  }

  Future<void> _onFocusCallback() async {
    Completer completer = Completer();
    if (_onFocus != null) {
      completer.complete(_onFocus!(context, _controller));
    } else {
      completer.complete();
    }
    await completer.future;
  }

  void _callback(bool lock) {
    if (lock) {
      _gateVisibility.value = 1;
    } else {
      _gateVisibility.animateBack(0).orCancel;
    }
  }

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          widget.child,
          if (_gateVisibility.value != 0)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: widget.blur * _gateVisibility.value,
                  sigmaY: widget.blur * _gateVisibility.value,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: _color.withOpacity(
                      widget.opacity * _gateVisibility.value,
                    ),
                  ),
                  child: widget.overlayBuilder != null ||
                          _controller.overlayBuilder != null
                      ? Overlay(
                          initialEntries: [
                            OverlayEntry(
                              builder: (context) => widget.overlayBuilder !=
                                      null
                                  ? widget.overlayBuilder!(context, _controller)
                                  : _controller.overlayBuilder!(
                                      context, _controller),
                            ),
                          ],
                        )
                      : null,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
