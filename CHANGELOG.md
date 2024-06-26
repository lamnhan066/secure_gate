## 0.2.0

* Add `context` to `onFocus`.
* Add logic to check the overlayBuilder better.

## 0.1.1

* Change min sdk version to `3.0.0`.
* Change from `overlays` to `overlayBuilder`.
* Update needed files.

## 0.0.3

* Add `onFocus` parameter to `SecureGate` and `SecureGateController` to control the focus event, so you can implement something like biometric authentication.
* Improve internal behavior.
* Update README.

## 0.0.2

* Fixes: `SecureGate` does not respect the unlocked state.
* Adds: `lockOnStart` parameter to `SecureGateController` to specify the on start behavior of the `SecureGate` when it starts.
* Adds: `overlays` parameter to `SecureGateController` to set the global overlays across pages that uses the same controller.
* Add more examples.
* Improve the dispose behavior.

## 0.0.1

* Initial release.
