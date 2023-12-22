import 'package:flutter/material.dart';
import 'package:secure_gate/secure_gate.dart';

class GlobalOverlays extends StatelessWidget {
  static final secureGateController = SecureGateController(
    overlays: (context, controller) {
      return Center(
        child: ElevatedButton(
          onPressed: () {
            controller.unlock();
          },
          child: const Text('Global Overlays Secure Gate'),
        ),
      );
    },
  );

  const GlobalOverlays({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Global Overlays'),
      ),
      body: SecureGate(
        controller: secureGateController,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Global Overlays',
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const Page2()));
                },
                child: const Text('Go to page 2'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return SecureGate(
      controller: GlobalOverlays.secureGateController,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Page 2'),
        ),
        body: const Center(
          child: Text('This is the page 2'),
        ),
      ),
    );
  }
}
