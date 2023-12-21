# Secure Gate

A simple package that helps you secure your app in multiple platforms.

## Usage

With `MaterialApp`:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SecureGate(
        overlays: (context, controller) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                controller.unlock();
              },
              child: const Text('Go'),
            ),
          );
        },
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
```

With `MaterialApp.router`:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routerConfig: router,
        theme: pageColorsCtrler.themeData,
        darkTheme: ThemeData.dark(useMaterial3: false),
        themeMode: ThemeMode.light,
        builder: (BuildContext context, Widget? child) {
        return SecureGate(
                overlays: (context, controller) {
                    return Center(
                        child: ElevatedButton(
                            onPressed: () {
                                controller.unlock();
                            },
                            child: const Text('Go'),
                        ),
                    );
                },
                child: child!
            );
        },
    );
  }
}
```

The package uses a build-in singleton controller `SecureGateController.instance`, so if you want to separate the behavior into multiple places, you need to create a new controller by defining a new `SecureGateController()` and put it into the `controller` parameter.

You can also specify the `color`, `blur` and `opacity` value by modify its' parameters.

## Information

This package does not use any native way to secure the screen. So it may not works as expected in some cases. If you have any suggestion, feel free to open an issue or a PR. Thank you.
