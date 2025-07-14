import 'package:flutter/material.dart';
import 'package:multi_screen_flutter_linux/widgets.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ExampleApp());
}

abstract class _State {
  final int counter;

  _State(this.counter);
}

class FirstScreenState extends _State {
  FirstScreenState(super.counter);
}

class SecondScreenState extends _State {
  SecondScreenState(super.counter);
}

class ExampleApp extends StatelessWidget {
  ExampleApp({super.key});

  final ValueNotifier<FirstScreenState> firstCounter =
      ValueNotifier<FirstScreenState>(FirstScreenState(0));
  final ValueNotifier<SecondScreenState> secondCounter =
      ValueNotifier<SecondScreenState>(SecondScreenState(0));

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ValueListenableProvider.value(value: firstCounter),
        ValueListenableProvider.value(value: secondCounter),
      ],
      child: DualScreenApp(
        orientation: Axis.vertical,
        spacing: 10.0,
        firstScreen: SubscreenData(width: 1024, height: 540),
        firstScreenBuilder: (context) => Scaffold(
          backgroundColor: Colors.blue,
          appBar: AppBar(title: const Text('First Screen')),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              firstCounter.value = FirstScreenState(
                firstCounter.value.counter + 1,
              );
            },
            child: const Icon(Icons.add),
          ),
          body: Builder(
            builder: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('This is the first screen.'),
                  Consumer<FirstScreenState>(
                    builder: (context, state, child) {
                      return Text('First screen counter: ${state.counter}');
                    },
                  ),
                  Consumer<SecondScreenState>(
                    builder: (context, state, child) {
                      return Text('Second screen counter: ${state.counter}');
                    },
                  ),
                  // Popup button
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Dialog'),
                          content: const Text(
                            'This is a dialog on the first screen.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Show dialog'),
                  ),
                  // Snackbar button
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'This is a snackbar on the first screen.',
                          ),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              // Handle undo action
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text('Show snackbar'),
                  ),
                  // Bottom sheet button
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          padding: const EdgeInsets.all(16.0),
                          child: const Text(
                            'This is a bottom sheet on the first screen.',
                          ),
                        ),
                      );
                    },
                    child: const Text('Show bottom sheet'),
                  ),
                  // Navigation button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(title: const Text('New Screen')),
                            body: Center(
                              child: const Text(
                                'This is a new screen navigated from the first screen.',
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text('Navigate to new screen'),
                  ),
                ],
              ),
            ),
          ),
        ),
        secondScreen: SubscreenData(width: 800, height: 420),
        secondScreenBuilder: (context) => Scaffold(
          backgroundColor: Colors.green,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              secondCounter.value = SecondScreenState(
                secondCounter.value.counter + 1,
              );
            },
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(title: const Text('Second Screen')),
          body: Builder(
            builder: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('This is the second screen.'),
                  Consumer<FirstScreenState>(
                    builder: (context, state, child) {
                      return Text('First screen counter: ${state.counter}');
                    },
                  ),
                  Consumer<SecondScreenState>(
                    builder: (context, state, child) {
                      return Text('Second screen counter: ${state.counter}');
                    },
                  ),
                  // Popup button
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Dialog'),
                          content: const Text(
                            'This is a dialog on the second screen.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Show dialog'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
