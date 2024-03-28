// Define a mock class for the callback
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hold_to_confirm_button/src/hold_to_confirm_button.dart';
import 'package:mockito/mockito.dart';

class MockOnProgressCompleted extends Mock {
  void call() =>
      super.noSuchMethod(Invocation.method(#call, []), returnValue: null);
}

void main() {
  late MockOnProgressCompleted mockOnProgressCompleted;

  setUp(() => mockOnProgressCompleted = MockOnProgressCompleted());

  group('HoldToConfirmButton', () {
    testWidgets('Scale animation starts on long press and completes on release',
        (WidgetTester tester) async {
      // Build the HoldToConfirmButton widget
      await tester.pumpWidget(
        setupHoldToConfirmButton(
          onProgressCompleted: () => mockOnProgressCompleted(),
        ),
      );

      // Find the GestureDetector widget for interaction
      final gestureDetectorFinder = find.byType(GestureDetector);

      // Simulate a long press on the button
      final gesture =
          await tester.startGesture(tester.getCenter(gestureDetectorFinder));

      // Simulate holding for 2 seconds
      await tester.pump(const Duration(seconds: 2));

      // Verify the scale animation is running during the press
      final scaleTransitionWidget =
          tester.firstWidget<ScaleTransition>(find.byType(ScaleTransition));
      expect(scaleTransitionWidget.scale.status, AnimationStatus.forward);

      // Release the long press
      await gesture.up();
      await tester.pump();

      // Verify the scale animation is dismissed after release
      expect(scaleTransitionWidget.scale.status, AnimationStatus.dismissed);
    });

    testWidgets('renders correctly with custom values',
        (WidgetTester tester) async {
      // Build the widget with custom values
      await tester.pumpWidget(
        setupHoldToConfirmButton(
          backgroundColor: Colors.red,
          borderRadius: BorderRadius.circular(8),
          contentPadding: const EdgeInsets.all(8.0),
        ),
      );

      // Find the Text widget within the button
      final textWidget = tester.widget<Text>(find.text('Hold to Confirm'));
      expect(textWidget.data, 'Hold to Confirm');

      // Find the DecoratedBox widget within the button
      final decoratedBoxFinder = find.byType(DecoratedBox);
      expect(tester.widget<DecoratedBox>(decoratedBoxFinder), isNotNull);

      // Verify button color and border radius
      final buttonDecoration = tester
          .widget<DecoratedBox>(decoratedBoxFinder)
          .decoration as BoxDecoration;

      // Check for specified color
      expect(buttonDecoration.color, Colors.red);

      // Check for specified border radius
      expect(buttonDecoration.borderRadius, BorderRadius.circular(8));

      // Check for specified content padding
      expect(find.byWidgetPredicate(
        (widget) {
          final isPadding = widget is Padding;
          final edgeInsets = isPadding ? (widget).padding as EdgeInsets : null;
          return isPadding &&
              edgeInsets?.left == 8 &&
              edgeInsets?.top == 8 &&
              edgeInsets?.right == 8 &&
              edgeInsets?.bottom == 8;
        },
      ), findsOneWidget);
    });
  });

  group('HoldToConfirmButton - Callback Behavior', () {
    testWidgets('calls onProgressCompleted when held long enough (using mock)',
        (WidgetTester tester) async {
      const holdDuration = Duration(seconds: 2);

      await tester.pumpWidget(
        setupHoldToConfirmButton(
          onProgressCompleted: () => mockOnProgressCompleted(),
        ),
      );

      final gesture = await tester
          .startGesture(tester.getCenter(find.byType(GestureDetector)));
      // Hold for 2 seconds
      await tester.pumpAndSettle(holdDuration);
      await gesture.up();
      // Wait for animation completion
      await tester.pumpAndSettle();

      // Verify the mock callback was called once
      verify(mockOnProgressCompleted()).called(1);
    });

    testWidgets(
        'doesn\'t call onProgressCompleted for short press (using mock)',
        (WidgetTester tester) async {
      const shortPressDuration = Duration(milliseconds: 100);

      await tester.pumpWidget(
        setupHoldToConfirmButton(
          onProgressCompleted: () => mockOnProgressCompleted(),
        ),
      );

      final gesture = await tester
          .startGesture(tester.getCenter(find.byType(GestureDetector)));
      await tester.pump(shortPressDuration);
      await gesture.up();
      await tester.pumpAndSettle();

      verifyNever(mockOnProgressCompleted());
    });

    testWidgets(
        'doesn\'t call onProgressCompleted when not pressed at all (using mock)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        setupHoldToConfirmButton(
          onProgressCompleted: () => mockOnProgressCompleted(),
        ),
      );

      // Wait for initial frame
      await tester.pumpAndSettle();

      // Verify the mock callback was never called
      verifyNever(mockOnProgressCompleted());
    });

    testWidgets('disables button with null onProgressCompleted',
        (WidgetTester tester) async {
      // Create button with null callback to simulate disabled state
      await tester.pumpWidget(setupHoldToConfirmButton());

      // Simulate tap gesture and ensure events are absorbed
      final gesture = await tester
          .startGesture(tester.getCenter(find.byType(GestureDetector)));
      await gesture.up();

      // Allow opacity animation to finish for visual verification
      await tester.pumpAndSettle();

      // Assert no exceptions occur during interactions in disabled state
      final capturedException = tester.takeException();
      expect(capturedException, null);

      // Verify opacity for visual indication of disabled state
      final animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byKey(const ValueKey<String>('animated_opacity')),
      );
      expect(animatedOpacity.opacity, 0.5);

      // Verify AbsorbPointer prevents pointer events for disabled state
      final absorbPointer = tester.widget<AbsorbPointer>(
        find.byKey(const ValueKey<String>('absorb_pointer')),
      );
      expect(absorbPointer.absorbing, true);
    });
  });
}

// Reusable setup function
Widget setupHoldToConfirmButton({
  VoidCallback? onProgressCompleted,
  Duration duration = const Duration(milliseconds: 1500),
  Color backgroundColor = Colors.black,
  BorderRadius borderRadius = const BorderRadius.all(
    Radius.circular(50),
  ),
  EdgeInsets contentPadding = const EdgeInsets.symmetric(
    vertical: 16,
    horizontal: 32,
  ),
}) {
  return MaterialApp(
    home: Scaffold(
      body: HoldToConfirmButton(
        onProgressCompleted: onProgressCompleted,
        duration: duration,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        contentPadding: contentPadding,
        child: const Text('Hold to Confirm'),
      ),
    ),
  );
}
