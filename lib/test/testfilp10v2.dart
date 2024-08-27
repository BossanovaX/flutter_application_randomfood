import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TestFlip10V2 extends StatelessWidget {
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
  List<AnimationController> _controllers = [];
  List<Animation<double>> _animations = [];
  List<Map<String, dynamic>> _randomMenus = [];
  List<bool> _isFront = List.generate(10, (_) => false);

  @override
  void initState() {
    super.initState();
    _fetchBreakfastMenus(); // ดึงข้อมูลเมนูอาหารเช้าเมื่อเริ่มต้นแอป
  }

  Future<void> _fetchBreakfastMenus() async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'food_menu.db'),
    );

    // SQL query เพื่อดึงเฉพาะเมนูอาหารเช้า
    final List<Map<String, dynamic>> maps = await db.query(
      'food',
      where: 'type = ?',
      whereArgs: ['อาหารเช้า'],
    );

    print('Maps from Database: ${maps.length}');
    print('menu from Database: ${_randomMenus}'); // Debugging

    setState(() {
      if (maps.length >= 5) {
        _randomMenus = _generateRandomMenus(maps);
      } else {
        print('Not enough menu items to generate random menus.');
        _randomMenus = maps; // or handle it accordingly
      }
      print('Random Menus Length: ${_randomMenus.length}'); // Debugging
      _initAnimations();
    });
  }

  List<Map<String, dynamic>> _generateRandomMenus(
      List<Map<String, dynamic>> menus) {
    List<Map<String, dynamic>> selectedMenus = [];
    Random random = Random();

    for (int i = 0; i < 10; i++) {
      int randomIndex = random.nextInt(menus.length);
      selectedMenus.add(menus[randomIndex]);
    }
    return selectedMenus;
  }

  void _initAnimations() {
    for (int i = 0; i < 10; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this,
      );
      final animation = Tween(begin: 0.0, end: 1.0).animate(controller);
      _controllers.add(controller);
      _animations.add(animation);
    }
  }

  void _flipCard(int index) {
    if (_isFront[index]) {
      _controllers[index].reverse();
    } else {
      _controllers[index].forward();
    }
    setState(() {
      _isFront[index] = !_isFront[index];
    });
  }

  void _reset() {
    setState(() {
      _fetchBreakfastMenus();
      for (var i = 0; i < _isFront.length; i++) {
        _isFront[i] = true;
        _controllers[i].reset(); // รีเซ็ตให้การ์ดกลับมาด้านหน้า
        // รีเซ็ตแอนิเมชันของการ์ด
      } // รีเซ็ตเพื่อดึงข้อมูลใหม่และสุ่มเมนูใหม่
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
            onPressed: _reset,
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
          crossAxisCount: 2,
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
                final angle = _animations[index].value * pi;
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(angle),
                  child: angle > pi / 2
                      ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(pi),
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
      aspectRatio: 1 / 1.5,
      child: Container(
        key: ValueKey(true),
        color: Colors.orangeAccent,
      ),
    );
  }

  Widget _buildBackSide(int index) {
    return AspectRatio(
      aspectRatio: 1 / 1.5,
      child: Container(
        key: ValueKey(true),
        color: Color.fromARGB(255, 35, 141, 2),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _randomMenus[index]['name'] ?? 'No name',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                _randomMenus[index]['description'] ?? 'No description',
                style: TextStyle(fontSize: 12, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
