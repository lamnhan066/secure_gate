import 'package:flutter/material.dart';
import 'package:secure_gate/secure_gate.dart';

class LocalOverlays extends StatefulWidget {
  const LocalOverlays({super.key});

  @override
  State<LocalOverlays> createState() => _LocalOverlaysState();
}

class _LocalOverlaysState extends State<LocalOverlays> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Local Overlays'),
      ),
      body: SecureGate(
        overlayBuilder: (context, controller) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                controller.unlock();
              },
              child: const Text('Go Local Overlays 1'),
            ),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return SecureGate(
      overlayBuilder: (context, controller) {
        return Center(
          child: ElevatedButton(
            onPressed: () {
              controller.unlock();
            },
            child: const Text('Go Local Overlays 2'),
          ),
        );
      },
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
