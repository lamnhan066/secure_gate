import 'package:example/biometric.dart';
import 'package:example/global_default_overlays.dart';
import 'package:example/global_overlays.dart';
import 'package:example/local_overlays.dart';
import 'package:flutter/material.dart';
import 'package:secure_gate/secure_gate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SecureGateController _controller;

  @override
  void initState() {
    _controller = SecureGateController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      builder: (context, child) {
        /// This secure gate will cover across pages
        return SecureGate(
          controller: _controller,
          child: child!,
          onFocus: (context, controller) async {
            if (await isBiometricAuthenticated()) {
              controller.unlock();
            }
          },
          overlayBuilder: (context, controller) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  controller.unlock();
                },
                child: const Text('Main Secure Gate'),
              ),
            );
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const GlobalDefaultOvelays(),
                  ),
                );
              },
              child: const Text('Global Default Overlays'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const GlobalOverlays(),
                  ),
                );
              },
              child: const Text('Global Ovelays'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LocalOverlays(),
                  ),
                );
              },
              child: const Text('Local Ovelays'),
            )
          ],
        ),
      ),
    );
  }
}
