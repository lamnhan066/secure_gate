# Secure Gate

A simple package that helps you secure your app when it is hidden or inactive by covered with a blur screen and overlay Widget.

## Setup

Wrap your page with `SecureGate`. All pages with the same `controller` will be shared the same behavior. It means that when one page is unlocked, all pages with the same `controller` will be unlocked:

```dart
class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    return SecureGate(
        onFocus: (context, controller) async {
          if (await biometricAuthentication()) {
            controller.unlock();
          }
        }
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Page'),
        ),
        body: const Center(
          child: Text('This is a secured page'),
        ),
      ),
    );
  }
}
```

Use with `MaterialApp`, this method will secure all pages:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      builder: (context, child) {
        return SecureGate(
          onFocus: (context, controller) async {
            if (await biometricAuthentication()) {
              controller.unlock();
            }
          }
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
          child: child!,
        );
      },
    );
  }
}
```

Use with `MaterialApp.router`, this method will secure all pages:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routerConfig: router,
        theme: pageColorsCtrler.themeData,
        darkTheme: ThemeData.dark(useMaterial3: false),
        themeMode: ThemeMode.light,
        builder: (BuildContext context, Widget? child) {
        return SecureGate(
            onFocus: (context, controller) async {
              if (await biometricAuthentication()) {
                controller.unlock();
              }
            }
            overlayBuilder: (context, controller) {
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

Remember to `dispose()` the created controller when it's not in use. You can also dipose the build-in controller by calling `SecureGateController.instance.close()`, the package will automatically create a new one when it's needed to use.

You can also specify the `color`, `blur` and `opacity` value by modify its' parameters in the `SecureGate`.

## Usage

- Call `controller.lock()` if you want to lock all pages that using the same `controller` by your self.

- Call `controller.unlock()` if you want to unlock any pages that using the same `controller`.

- Call `controller.on()` if you want to turn on the `controller`. This method will also `lock()` the screen by default, you can set the `isLock` to `false` to disable this behavior.

- Call `controller.off()` if you want to turn off the `controller`. You can not use `lock()` and `unlock()` when the controller is turned off, so remember to `lock()` or `unlock()` before using this method. This method will also `unlock()` the screen by default, you can set the `isUnlock` to `false` to disable this behavior.

## Advanced

By default, the `SecureGate` uses a build-in controller named `SecureGateController.instance`. You can modify it to apply to all pages that wrapped with the `SecureGate`:

```dart
SecureGateController.instance.overlayBuilder = (context, controller) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          controller.unlock();
        },
        child: const Text('Go'),
      ),
    );
  };

SecureGateController.instance.onFocus = (controller) async {
      if (await biometricAuthentication()) {
        controller.unlock();
      }
    };
```

Or you can create a global overlayBuilder by setting the `overlayBuilder` parameter in the new controller and pass it into the `SecureGate`:

```dart
final secureGateController = SecureGateController(
  onFocus: (context, controller) async {
    if (await biometricAuthentication()) {
      controller.unlock();
    }
  }
  overlayBuilder: (context, controller) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          controller.unlock();
        },
        child: const Text('Go'),
      ),
    );
  },
);

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    return SecureGate(
      controller: secureGateController,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Page'),
        ),
        body: const Center(
          child: Text('This is a secured page'),
        ),
      ),
    );
  }
}
```

By default, the screen will be locked on start. If you want to change this behavior, you can set the `lockOnStart` in the `controller` to `false`, so the page will be unlocked on start.

The `biometricAuthentication()` is just an example that shows you how to implement it into your `SecureGate`. You can try it in the example.

## Information

This package does not use any native way to secure the screen. So it may not works as expected in some cases. If you have any issue or suggestion, feel free to file an issue or a PR. Thank you.
