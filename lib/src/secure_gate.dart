import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'secure_gate_controller.dart';

class SecureGate extends StatefulWidget {
  /// [SecureGate] use a build-in singleton controller to control the state if
  /// you not specify the [controller]. You can get this by using [SecureGateController.instance]
  /// or inside the [overlays] parameter.
  ///
  /// You can use [overlays] to put any [Widget] above the blur screen or you
  /// can put the biometric authentication inside it.
  const SecureGate({
    super.key,
    this.controller,
    required this.child,
    this.overlays,
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
  /// the screen.
  final Widget Function(BuildContext context, SecureGateController controller)?
      overlays;

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
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late AnimationController _gateVisibility;
  late StreamSubscription<bool> _sub;
  late SecureGateController _controller;
  late Color _color;

  @override
  void initState() {
    _color = widget.color ?? Colors.grey.shade200;
    _controller = widget.controller ?? SecureGateController.instance;
    _controller.lock();

    WidgetsBinding.instance.addObserver(this);
    _gateVisibility =
        AnimationController(vsync: this, duration: kThemeAnimationDuration * 2)
          ..addListener(() {
            setState(() {});
          });
    _sub = _controller.stream.listen(_callback);

    _callback(_controller.isLocked);
    super.initState();
  }

  @override
  void dispose() {
    _sub.cancel();
    _gateVisibility.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _controller.lock();
    });
    super.didChangeAppLifecycleState(state);
  }

  void _callback(bool lock) {
    if (lock) {
      _gateVisibility.value = 1;
    } else {
      _gateVisibility.animateBack(0).orCancel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          widget.child,
          if (_gateVisibility.value != 0) ...[
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
                ),
              ),
            ),
            if (widget.overlays != null)
              Overlay(
                initialEntries: [
                  OverlayEntry(
                    builder: (_) => widget.overlays!(context, _controller),
                  ),
                ],
              ),
          ],
        ],
      ),
    );
  }
}
