import 'package:flutter/material.dart';
import 'dart:math';

class test2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FruitRandomizer(),
    );
  }
}

class FruitRandomizer extends StatefulWidget {
  @override
  _FruitRandomizerState createState() => _FruitRandomizerState();
}

class _FruitRandomizerState extends State<FruitRandomizer> {
  List<String> fruits = [
    'Apple',
    'Banana',
    'Orange',
    'Mango',
    'Grapes',
    'Pineapple',
    'Strawberry',
    'Watermelon',
    'Cherry',
    'Peach'
  ];

  String getRandomFruit() {
    final random = Random();
    int index = random.nextInt(fruits.length);
    return fruits[index];
  }

  void showFruitDialog(String fruit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ผลการสุ่ม'),
          content: Text('You got: $fruit'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fruit Randomizer'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            String fruit = getRandomFruit();
            showFruitDialog(fruit);
          },
          child: Text('Randomize Fruit'),
        ),
      ),
    );
  }
}
