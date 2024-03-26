# Hold to Confirm Button

This repo contains a sample project of a simple UI challenge: a `HoldToConfirmButton` widget. The button fills up as it's held down, and triggers an action when its completely filled. This provides a clear visual cue to the user about the progress of the button press.

## Support
Like this project? Leave a ⭐️, it's free and means a lot.<br>
Consider supporting its upkeep with a coffee. Your generosity is appreciated! ☕

<a href="https://www.buymeacoffee.com/danicoy" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

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

Here is [another approach](https://github.com/diegoveloper/flutter_hold_down_animated_button) to this challenge by [Diegoveloper](https://github.com/diegoveloper/)

[Inspired by Kavsoft](https://twitter.com/_Kavsoft/status/1770539226234507570)

## Contributions
Contributions, issues, and feature requests are welcome! Feel free to check issues page.

## License
This project is MIT licensed.
