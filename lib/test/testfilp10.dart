import 'dart:math';

import 'package:flutter/material.dart';

class testfilp10 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CardFlipDemo(),
    );
  }
}

class CardFlipDemo extends StatefulWidget {
  @override
  _CardFlipDemoState createState() => _CardFlipDemoState();
}

class _CardFlipDemoState extends State<CardFlipDemo>
    with TickerProviderStateMixin {
  List<bool> isFront = List.generate(10, (_) => true);
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  final List<String> _allMenus = [
    'Pizza',
    'Burger',
    'Pasta',
    'Salad',
    'Sushi',
    'Steak',
    'Soup',
    'Sandwich',
    'Tacos',
    'Burrito',
    'Curry',
    'Ramen',
    'Fried Rice',
    'Spring Rolls',
    'Pad Thai',
    'Kebab',
    'Dumplings',
    'Falafel',
    'Quesadilla',
    'Waffles'
  ];

  // รายการเมนูที่ถูกสุ่ม 10 เมนู
  List<String> _randomMenus = [];
  // สถานะของการพลิกการ์ด (true: ด้านหลัง, false: ด้านหน้า)
  List<bool> _isFront = List.generate(10, (_) => false);

  @override
  void initState() {
    super.initState();
    _generateRandomMenus(); // สุ่มเมนูเมื่อเริ่มต้นแอป
  }

  // ฟังก์ชันสำหรับสุ่มเมนู 10 เมนูจากรายการทั้งหมด
  void _generateRandomMenus() {
    if (_allMenus.isEmpty || _allMenus.length < 10) {
      // ถ้าไม่มีเมนูหรือมีน้อยกว่า 10 รายการ ให้หยุดการทำงานหรือจัดการกรณีนี้
      print("ไม่สามารถสุ่มเมนูได้ เนื่องจากมีเมนูไม่เพียงพอ");
      return;
    }

    _randomMenus = [];
    List<String> tempMenus = List.from(_allMenus);
    Random random = Random();

    for (int i = 0; i < 10; i++) {
      int randomIndex = random.nextInt(tempMenus.length);
      _randomMenus
          .add(tempMenus[randomIndex]); // เพิ่มเมนูที่ถูกสุ่มเข้าไปในรายการ
      tempMenus.removeAt(randomIndex); // ลบเมนูที่ถูกสุ่มออกจากรายการชั่วคราว
    }

    _controllers = List.generate(
      10,
      (index) => AnimationController(
        duration: Duration(milliseconds: 800),
        vsync: this,
      ),
    );

    _animations = _controllers
        .map((controller) => Tween(begin: 0.0, end: 1.0).animate(controller))
        .toList();
  }

  void _flipCard(int index) {
    if (_isFront[index]) {
      _controllers[index].forward();
    } else {
      _controllers[index].reverse();
    }
    setState(() {
      _isFront[index] = !_isFront[index];
    });
  }

  // ฟังก์ชันสำหรับรีเซ็ตการสุ่มและการพลิกการ์ด
  void _reset() {
    setState(() {
      _generateRandomMenus(); // สุ่มเมนูใหม่
      for (var i = 0; i < _isFront.length; i++) {
        _isFront[i] = true; // รีเซ็ตให้การ์ดกลับมาด้านหน้า
        _controllers[i].reset(); // รีเซ็ตแอนิเมชันของการ์ด
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ผลการสุ่ม'),
        actions: [
          TextButton.icon(
            onPressed: _reset, // เรียกใช้ฟังก์ชันรีเซ็ตเมื่อกดปุ่ม
            icon: Icon(Icons.refresh, color: Color.fromARGB(255, 245, 87, 87)),
            label: Text(
              'ทำการสุ่มใหม่',
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // สองคอลัมน์
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _flipCard(index),
            child: AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                final angle = _animations[index].value * 3.1416; // 3.1416 = pi
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(angle),
                  child: angle > 1.5708 // 1.5708 = pi / 2
                      ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(3.1416),
                          child: _buildBackSide(index),
                        )
                      : _buildFrontSide(index),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrontSide(int index) {
    return AspectRatio(
      aspectRatio: 1 / 1.5, // กำหนดอัตราส่วนของการ์ด (กว้าง:สูง)
      child: Container(
        key: ValueKey(true), // กำหนดคีย์ให้กับด้านหน้าของการ์ด
        color: Colors.orangeAccent, // สีพื้นหลังของการ์ดด้านหน้า
      ),
    );
  }

  Widget _buildBackSide(int index) {
    return AspectRatio(
      aspectRatio: 1 / 1.5, // กำหนดอัตราส่วนของการ์ด (กว้าง:สูง)
      child: Container(
        key: ValueKey(true), // กำหนดคีย์ให้กับด้านหน้าของการ์ด
        color: Color.fromARGB(255, 35, 141, 2),
        child: Center(
          child: Text(
            _randomMenus[index], // แสดงชื่อเมนูที่สุ่มได้
            style: TextStyle(
                fontSize: 14,
                color: Colors.white), // สีพื้นหลังของการ์ดด้านหน้า
          ),
        ),
      ),
    );
  }
}
