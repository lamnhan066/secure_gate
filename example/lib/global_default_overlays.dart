import 'package:flutter/material.dart';
import 'package:secure_gate/secure_gate.dart';

class GlobalDefaultOvelays extends StatefulWidget {
  const GlobalDefaultOvelays({super.key});

  @override
  State<GlobalDefaultOvelays> createState() => _GlobalDefaultOvelaysState();
}

class _GlobalDefaultOvelaysState extends State<GlobalDefaultOvelays> {
  @override
  void initState() {
    // Set the global overlayBuilder
    SecureGateController.instance.overlayBuilder = (context, controller) {
      return Center(
        child: ElevatedButton(
          onPressed: () {
            controller.unlock();
          },
          child: const Text('Global Default Secure Gate'),
        ),
      );
    };
    super.initState();
  }

  @override
  void dispose() {
    SecureGateController.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Global Default Overlays'),
      ),
      body: SecureGate(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Global default overlays',
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
