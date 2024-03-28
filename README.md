# HoldToConfirmButton

This package provides a `HoldToConfirmButton` widget for Flutter apps. It allows users to hold down the button, which visually fills up as it's pressed. Upon complete fill, a designated action is triggered.

## Installation

Add the `hold_to_confirm_button` package as a dependency in your `pubspec.yaml` file:
```yaml
dependencies:
  hold_to_confirm_button: ^latest_version # Replace with the latest version available on pub.dev
```

Import the package in your Flutter project:
```dart
import 'package:hold_to_confirm_button/hold_to_confirm_button.dart';
```

## Usage
Default values:
```dart
HoldToConfirmButton(
  onProgressCompleted: () {
    // Handle the completed progress here
  },
  child: const Text('Hold to increase',
    style: TextStyle(color: Colors.white),
  ),
)
```
![default button](https://github.com/monster555/hold_to_confirm_button/assets/32662133/9b370557-9721-470b-81ae-801907fa270f)

Custom values:
```dart
HoldToConfirmButton(
  onProgressCompleted: () {
    // Handle the completed progress here
  },
  child: const Text('Hold to increase'
    style: TextStyle(color: Colors.white),
  ),
  hapticFeedback: false,
  backgroundColor: Colors.green,
  borderRadius: BorderRadius.all(
    Radius.circular(12),
  ),
)
```
![custom button](https://github.com/monster555/hold_to_confirm_button/assets/32662133/0ffc6370-2df9-49c0-8b3a-e6e54561dbbc)

## Customization

The HoldToConfirmButton widget offers various customization options to match your app's design:

- `child`: The widget displayed within the button area (e.g., Text, Icon).
- `hapticFeedback`: Enables or disables haptic feedback on button press (defaults to true).
- `backgroundColor`: Sets the background color of the button.
- `borderRadius`: Defines the border radius of the button.

## Support
Like this project? Leave a ⭐️, it's free and means a lot.<br>
Consider supporting its upkeep with a coffee. Your generosity is appreciated! ☕

<a href="https://www.buymeacoffee.com/danicoy" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

[Inspired by Kavsoft](https://twitter.com/_Kavsoft/status/1770539226234507570)

## Contributions
Contributions, issues, and feature requests are welcome! Feel free to check issues page.

## License
This project is MIT licensed.
