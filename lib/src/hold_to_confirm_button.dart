import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A button that requires long-press gesture to trigger an action.
class HoldToConfirmButton extends StatefulWidget {
  /// Internal constant representing the minimum hold duration (milliseconds) for the
  /// [HoldToConfirmButton]. This value is chosen to provide a balance between
  /// clear confirmation intent and efficient user interaction.
  static const _minHoldDuration = 800;

  /// Constant representing the minimum hold duration (milliseconds) for the
  /// [HoldToConfirmButton].
  static const Duration _minDuration = Duration(milliseconds: _minHoldDuration);

  /// A button that requires a long press to confirm an action.
  ///
  /// When the button is pressed and held for a specified duration, it scales
  /// up and triggers the [onProgressCompleted] callback (if provided). When the
  /// press is released, the button animates back to its original state.
  ///
  /// This button is useful for actions that require the user to confirm their
  /// intent with a deliberate hold, such as deleting data or sending a payment.
  ///
  /// Example usage:
  ///
  /// **Default Values:**
  ///
  /// This example uses mostly the default values, only specifying the
  /// `onProgressCompleted` callback.
  /// ```dart
  /// HoldToConfirmButton(
  ///   onProgressCompleted: () => print('Action confirmed!'),
  ///   child: const Text('Confirm Action'),
  /// ),
  /// ```
  ///
  /// **Custom Configuration:**
  ///
  /// This example demonstrates customizing several properties of the button.
  /// ```dart
  /// HoldToConfirmButton(
  ///   onProgressCompleted: deleteItem,
  ///   backgroundColor: Colors.red,
  ///   fillColor: Colors.redAccent,
  ///   borderRadius: BorderRadius.circular(10.0),
  ///   contentPadding: const EdgeInsets.all(8.0),
  ///   child: const Text('Delete Item'),
  /// ),
  /// ```
  ///
  /// **Disabled Button (No Callback):**
  ///
  /// This example omits the [onProgressCompleted] callback, resulting in a
  /// disabled button with reduced opacity.
  /// ```dart
  /// HoldToConfirmButton(
  ///   child: const Text('Disabled Button'),
  /// ),
  /// ```
  const HoldToConfirmButton({
    super.key,
    required this.child,
    this.onProgressCompleted,
    this.duration = const Duration(milliseconds: 1500),
    this.scaleDuration = const Duration(milliseconds: 300),
    this.hapticFeedback = true,
    this.backgroundColor = Colors.black,
    this.fillColor = Colors.white24,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(50),
    ),
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 32,
    ),
  })  : assert(duration >= _minDuration,
            'HoldToConfirmButton duration must be at least $_minHoldDuration milliseconds.'),
        assert(duration > scaleDuration,
            'HoldToConfirmButton duration must be greater than the scale duration.');

  /// The widget to display as the button's child.
  final Widget child;

  /// Callback invoked when the progress is completed.
  final VoidCallback? onProgressCompleted;

  /// The duration of the progress animation.
  final Duration duration;

  /// The duration of the scaling animation.
  final Duration scaleDuration;

  /// Whether to provide haptic feedback when progress is completed.
  final bool hapticFeedback;

  /// The background color of the button.
  final Color backgroundColor;

  /// The fill color of the progress indicator.
  final Color fillColor;

  /// The border radius of the button.
  final BorderRadius borderRadius;

  /// The content padding of the button.
  final EdgeInsets contentPadding;

  @override
  State<HoldToConfirmButton> createState() => _HoldToConfirmButtonState();
}

class _HoldToConfirmButtonState extends State<HoldToConfirmButton>
    with TickerProviderStateMixin {
// Animation controller for controlling the scale animation of the button.
  late final AnimationController scaleController;

// Animation controller for controlling the progress animation of the button.
  late final AnimationController progressController;

  @override
  void initState() {
    super.initState();

    scaleController = AnimationController(
      vsync: this,
      duration: widget.scaleDuration,
    );

    progressController = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.scaleDuration,
    )..addStatusListener(_onCompletedCallback);
  }

  void _onCompletedCallback(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (widget.hapticFeedback) {
        // Provide haptic feedback when progress is completed if enabled.
        HapticFeedback.mediumImpact();
      }

      // Reverse the animation and invoke the completion callback.
      _reverseAnimation();
      widget.onProgressCompleted?.call();
    }
  }

  @override
  void dispose() {
    scaleController.dispose();
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Disable the button if the onProgressCompleted callback is null.
    final isDisabled = widget.onProgressCompleted == null;

    return AbsorbPointer(
      key: const ValueKey<String>('absorb_pointer'),
      absorbing: isDisabled,
      child: AnimatedOpacity(
        key: const ValueKey<String>('animated_opacity'),
        opacity: isDisabled ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTapDown: (_) => _forwardAnimation(),
          onTapUp: (_) => _reverseAnimation(),
          onTapCancel: _reverseAnimation,
          // Apply the scale animation to the button.
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 1.0,
              end: 0.9,
            ).animate(
              CurvedAnimation(
                parent: scaleController,
                curve: Curves.easeInOut,
              ),
            ),
            child: AnimatedBuilder(
              animation: progressController,
              builder: (_, child) {
                // ShaderMask is a widget that applies a shader to its child.
                return ShaderMask(
                  // This blend mode overlays the shader on top of the child widget, preserving the child's alpha channel.
                  blendMode: BlendMode.srcATop,
                  // The shaderCallback is called to create the shader. The rect parameter provides the bounds of the child widget.
                  shaderCallback: (rect) {
                    // LinearGradient creates a gradient shader. It interpolates colors along a line.
                    return LinearGradient(
                      colors: [
                        // This is the color that appears as the button is held down.
                        widget.fillColor,

                        // This color is transparent, which means it doesn't show up on the screen.
                        // The gradient transitions from the fill color to transparent as the button is held down.
                        // This gives the effect of the button filling up with color the longer it's held.
                        Colors.transparent,
                      ],
                      // The stops property defines where each color is placed along the line.
                      // Here we're using the same value for both stops, which creates a sharp transition at that point.
                      stops: [
                        progressController.value,
                        progressController.value,
                      ],
                    ).createShader(rect);
                  },
                  child: child,
                );
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: widget.borderRadius,
                ),
                child: Padding(
                  padding: widget.contentPadding,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Start the forward animation.
  void _forwardAnimation() {
    scaleController.forward();
    progressController.forward();
  }

  /// Start the reverse animation.
  void _reverseAnimation() {
    scaleController.reverse();
    progressController.reverse();
  }
}
