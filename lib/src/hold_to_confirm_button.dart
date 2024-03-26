import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A button that requires long-press gesture to trigger an action.
class HoldToConfirmButton extends StatefulWidget {
  /// Creates a [HoldToConfirmButton].
  const HoldToConfirmButton({
    super.key,
    required this.onProgressCompleted,
    required this.child,
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
  });

  /// Callback invoked when the progress is completed.
  final VoidCallback onProgressCompleted;

  /// The widget to display as the button's child.
  final Widget child;

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
  late final AnimationController _scaleController;

// Animation controller for controlling the progress animation of the button.
  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: widget.scaleDuration,
    );

    _progressController = AnimationController(
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
      widget.onProgressCompleted();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            parent: _scaleController,
            curve: Curves.easeInOut,
          ),
        ),
        child: AnimatedBuilder(
          animation: _progressController,
          builder: (_, child) {
            // ShaderMask is a widget that applies a shader to its child.
            return ShaderMask(
              // BlendMode.srcATop uses the source (child) as the base and overlays the destination (shader) on top.
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
                    _progressController.value,
                    _progressController.value,
                  ],
                ).createShader(rect);
              },
              child: Container(
                padding: widget.contentPadding,
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: widget.borderRadius,
                ),
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }

  /// Start the forward animation.
  void _forwardAnimation() {
    _scaleController.forward();
    _progressController.forward();
  }

  /// Start the reverse animation.
  void _reverseAnimation() {
    _scaleController.reverse();
    _progressController.reverse();
  }
}
