import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(
        Rect.fromCenter(
          center: screen!.frame.center,
          width: windowWidth,
          height: windowHeight,
        ),
      );
    });
  }
}

class Counter with ChangeNotifier {
  int value = 0;

  void increment() {
    if (value < 99) {
      value += 1;
      notifyListeners();
    }
  }

  void decrement() {
    if (value > 0) {
      value -= 1;
      notifyListeners();
    }
  }

  void setValue(int newValue) {
    value = newValue;
    notifyListeners();
  }

  // Define the milestone categories and return appropriate message and color
  Map<String, dynamic> getAgeMilestone() {
    if (value >= 0 && value <= 12) {
      return {'message': "You're a child!", 'color': Colors.lightBlue};
    } else if (value >= 13 && value <= 19) {
      return {'message': "Teenager time!", 'color': Colors.lightGreen};
    } else if (value >= 20 && value <= 30) {
      return {'message': "You're a young adult!", 'color': Colors.yellow};
    } else if (value >= 31 && value <= 50) {
      return {'message': "You're an adult now!", 'color': Colors.orange};
    } else {
      return {'message': "Golden years!", 'color': Colors.grey};
    }
  }

  // Define the color for the progression bar based on the counter value
  Color getProgressBarColor() {
    if (value >= 0 && value <= 33) {
      return Colors.green;
    } else if (value > 33 && value <= 67) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demo Home Page')),
      body: Consumer<Counter>(
        builder: (context, counter, child) {
          final milestone = counter.getAgeMilestone();
          final progressColor = counter.getProgressBarColor();
          return Container(
            color: milestone['color'], // Set the background color
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You are at the age of:'),
                  Text(
                    '${counter.value}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    milestone['message']!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Slider to change age
                  Slider(
                    value: counter.value.toDouble(),
                    min: 0,
                    max: 99,
                    divisions: 99,
                    label: '${counter.value}',
                    onChanged: (double newValue) {
                      counter.setValue(newValue.toInt());
                    },
                  ),
                  // Progress bar to show progression in the age range
                  LinearProgressIndicator(
                    value: counter.value / 99,
                    color: progressColor,
                    backgroundColor: Colors.grey[300],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Decrement button
          FloatingActionButton(
            onPressed: () {
              var counter = context.read<Counter>();
              counter.decrement();
            },
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 10),
          // Increment button
          FloatingActionButton(
            onPressed: () {
              var counter = context.read<Counter>();
              counter.increment();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
