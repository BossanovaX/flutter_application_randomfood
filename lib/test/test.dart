import 'package:flutter/material.dart';
import 'dart:math';

class test extends StatelessWidget {
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

  List<String> selectedFruits = [];

  List<String> getRandomFruits(int count) {
    final random = Random();
    List<String> result = [];
    Set<int> indices = Set();

    while (indices.length < count) {
      indices.add(random.nextInt(fruits.length));
    }

    indices.forEach((index) {
      result.add(fruits[index]);
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fruit Randomizer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectedFruits.isEmpty
                ? Text(
                    'Press the button to pick 3 fruits!',
                    style: TextStyle(fontSize: 24),
                  )
                : Column(
                    children: selectedFruits
                        .map((fruit) =>
                            Text(fruit, style: TextStyle(fontSize: 20)))
                        .toList(),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedFruits = getRandomFruits(
                      3); // Replace 3 with the number of fruits you want to pick
                });
              },
              child: Text('Randomize Fruits'),
            ),
          ],
        ),
      ),
    );
  }
}
