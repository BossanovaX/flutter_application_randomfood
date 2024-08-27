import 'package:flutter/material.dart';
import 'dart:math';

// ตัวเริ่มต้นของแอปพลิเคชัน Flutter
class menu10 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MenuCardDemo(), // เรียกใช้หน้าหลักของแอป
    );
  }
}

// สร้าง State สำหรับการจัดการหน้าหลักของแอป
class MenuCardDemo extends StatefulWidget {
  @override
  _MenuCardDemoState createState() => _MenuCardDemoState();
}

class _MenuCardDemoState extends State<MenuCardDemo> {
  // รายการเมนูอาหารทั้งหมด 20 เมนู
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
  List<bool> _isFlipped = List.generate(10, (_) => false);

  @override
  void initState() {
    super.initState();
    _generateRandomMenus(); // สุ่มเมนูเมื่อเริ่มต้นแอป
  }

  // ฟังก์ชันสำหรับสุ่มเมนู 10 เมนูจากรายการทั้งหมด
  void _generateRandomMenus() {
    _randomMenus = [];
    List<String> tempMenus = List.from(_allMenus);
    Random random = Random();

    for (int i = 0; i < 10; i++) {
      int randomIndex = random.nextInt(tempMenus.length);
      _randomMenus
          .add(tempMenus[randomIndex]); // เพิ่มเมนูที่ถูกสุ่มเข้าไปในรายการ
      tempMenus.removeAt(randomIndex); // ลบเมนูที่ถูกสุ่มออกจากรายการชั่วคราว
    }
  }

  // ฟังก์ชันสำหรับพลิกการ์ดเมื่อผู้ใช้แตะการ์ด
  void _flipCard(int index) {
    setState(() {
      _isFlipped[index] = !_isFlipped[index]; // เปลี่ยนสถานะการพลิกของการ์ด
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Random Menu Cards')), // แสดงชื่อหัวข้อใน AppBar
      body: GridView.builder(
        padding: EdgeInsets.all(8), // กำหนด padding รอบ GridView
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // แสดงการ์ด 4 ใบต่อแถว
          crossAxisSpacing: 8, // ช่องว่างระหว่างการ์ดในแนวนอน
          mainAxisSpacing: 8, // ช่องว่างระหว่างการ์ดในแนวตั้ง
        ),
        itemCount: _randomMenus.length, // จำนวนการ์ดที่จะแสดง
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () =>
                _flipCard(index), // เรียกฟังก์ชันพลิกการ์ดเมื่อผู้ใช้แตะการ์ด
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 1500), // กำหนดระยะเวลาอนิเมชัน
              transitionBuilder: (Widget child, Animation<double> animation) {
                return RotationYTransition(
                    turns: animation, child: child); // กำหนดอนิเมชันพลิกการ์ด
              },
              child: _isFlipped[index]
                  ? _buildBackSide(index) // แสดงด้านหลังการ์ดหากถูกพลิก
                  : _buildFrontSide(index), // แสดงด้านหน้าการ์ดหากยังไม่ถูกพลิก
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _generateRandomMenus(); // สุ่มเมนูใหม่เมื่อกดปุ่มรีเฟรช
            _isFlipped =
                List.generate(10, (_) => false); // รีเซ็ตสถานะการพลิกการ์ด
          });
        },
        child: Icon(Icons.refresh), // ไอคอนรีเฟรชบนปุ่ม
      ),
    );
  }

  // สร้าง Widget สำหรับด้านหน้าของการ์ด
  Widget _buildFrontSide(int index) {
    return AspectRatio(
      aspectRatio: 1 / 1.5, // กำหนดอัตราส่วนของการ์ด (กว้าง:สูง)
      child: Container(
        key: ValueKey(true), // กำหนดคีย์ให้กับด้านหน้าของการ์ด
        color: Colors.orangeAccent, // สีพื้นหลังของการ์ดด้านหน้า
        child: Center(
          child: Text(
            _randomMenus[index], // แสดงชื่อเมนูที่สุ่มได้
            style: TextStyle(
                fontSize: 14, color: Colors.white), // กำหนดสไตล์ของข้อความ
          ),
        ),
      ),
    );
  }

  // สร้าง Widget สำหรับด้านหลังของการ์ด
  Widget _buildBackSide(int index) {
    return AspectRatio(
      aspectRatio: 1 / 1.5, // กำหนดอัตราส่วนของการ์ด (กว้าง:สูง)
      child: Container(
        key: ValueKey(false), // กำหนดคีย์ให้กับด้านหลังของการ์ด
        color: Colors.blueAccent, // สีพื้นหลังของการ์ดด้านหลัง
        child: Center(
          child: Text(
            'Back Side', // ข้อความที่จะแสดงบนด้านหลังการ์ด
            style: TextStyle(
                fontSize: 14, color: Colors.white), // กำหนดสไตล์ของข้อความ
          ),
        ),
      ),
    );
  }
}

// คลาสสำหรับสร้างอนิเมชันหมุนในแกน Y
class RotationYTransition extends AnimatedWidget {
  const RotationYTransition({
    Key? key,
    required Animation<double> turns,
    this.alignment = Alignment.center,
    this.child,
  }) : super(key: key, listenable: turns);

  final AlignmentGeometry alignment;
  final Widget? child;

  Animation<double> get turns => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final Matrix4 transform =
        Matrix4.rotationY(turns.value * pi); // หมุน Widget ในแกน Y
    return Transform(
      transform: transform,
      alignment: alignment,
      child: child, // แสดง Widget ที่ถูกหมุน
    );
  }
}
