import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/widgets.dart';

class test3 extends StatelessWidget {
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
    'Peach',
    'Lemon',
    'Lychee',
    'Blueberry',
    'Kiwi',
    'Pomegranate',
    'Papaya',
    'Dragon Fruit',
    'Passion Fruit',
    'Raspberry',
    'Blackberry'
  ];

  List<String> random10() {
    final random = Random();
    Set<int> indices = Set();

    while (indices.length < 10) {
      indices.add(random.nextInt(fruits.length));
    }

    return indices.map((index) => fruits[index]).toList();
  }

  String random1() {
    final random = Random();
    int index = random.nextInt(fruits.length);
    return fruits[index];
  }

  void showdialog10(List<String> fruits) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ผลการสุ่ม'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: fruits.map((fruit) => Text(fruit)).toList(),
          ),
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

  void showdialog1(String fruit) {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                List<String> selectedFruits = random10();
                showdialog10(selectedFruits);
              },
              child: Text('สุ่มผลไม้ 10 ผล'),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                String fruit = random1();
                showdialog1(fruit);
              },
              child: Text('สุ่มผลไม้ 1 ผล'),
            ),
          ],
        ),
      ),
    );
  }
}
