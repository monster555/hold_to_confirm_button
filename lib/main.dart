import 'package:flutter/material.dart';
import 'package:hold_to_confirm_button/src/hold_to_confirm_button.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HoldToConfirmButton Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'HoldToConfirmButton Demo'),
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
  int _counter = 0;

  void _incrementCounter() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have incremented the counter\n this many times:',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: Text('Default button'),
            ),
            HoldToConfirmButton(
              onProgressCompleted: _incrementCounter,
              child: Text(
                'Hold to increase',
                style: textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: Text('Custom button'),
            ),
            HoldToConfirmButton(
              onProgressCompleted: _incrementCounter,
              // Custom border radius
              borderRadius: BorderRadius.circular(12),
              // Disable haptic feedback
              hapticFeedback: false,
              // Custom background color
              backgroundColor: Colors.green,
              child: Text(
                'Hold to increase',
                style: textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
