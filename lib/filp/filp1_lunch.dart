import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_randomfood/pages/des.dart';
import 'package:flutter_application_randomfood/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Filp1Lunch extends StatefulWidget {
  @override
  _CardFlipDemoState createState() => _CardFlipDemoState();
}

class _CardFlipDemoState extends State<Filp1Lunch>
    with TickerProviderStateMixin {
  List<String> _allMenus = [];
  List<String> _allType = [];
  List<String> _displayMenus = List.generate(1, (_) => '');
  List<String> _displayType = List.generate(1, (_) => '');
  List<Map<String, dynamic>> _randomMenus = [];
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> itemlist = [];
  List<Timer> _timers = [];
  List<double> _opacityList =
      List.generate(1, (_) => 0.0); // ใช้ควบคุมแอนิเมชันของการ์ด

  @override
  void initState() {
    super.initState();
    _fetchBreakfastMenus();
  }

  Future<void> _fetchBreakfastMenus() async {
    final List<Map<String, dynamic>> maps =
        await _dbHelper.getfoodbytype('อาหารกลางวัน'); // ใส่ type อาหารลงไป

    setState(() {
      if (maps.length >= 1) {
        _randomMenus = _generateRandomMenus(maps);
      } else {
        _randomMenus = maps;
      }
      _allMenus = maps.map((item) => item['name'] as String).toList();
      _allType = maps.map((item) => item['type2'] as String).toList();
      _startShuffling();
    });
  }

  List<Map<String, dynamic>> _generateRandomMenus(
      List<Map<String, dynamic>> menus) {
    List<Map<String, dynamic>> selectedMenus = [];
    Random random = Random();

    for (int i = 0; i < 1; i++) {
      int randomIndex = random.nextInt(menus.length);
      selectedMenus.add(menus[randomIndex]);
    }
    return selectedMenus;
  }

  void _startShuffling() {
    for (int i = 0; i < 1; i++) {
      _timers.add(Timer.periodic(Duration(milliseconds: 100), (timer) {
        setState(() {
          _displayMenus[i] = _allMenus[Random().nextInt(_allMenus.length)];
          _displayType[i] = _allType[Random().nextInt(_allMenus.length)];
        });
      }));
    }

    Future.delayed(Duration(milliseconds: 700), () {
      _stopShuffling();
      _startCardAnimation();
    });
  }

  void _stopShuffling() {
    for (var timer in _timers) {
      timer.cancel();
    }

    setState(() {
      for (int i = 0; i < 1; i++) {
        _displayMenus[i] = _randomMenus[i]['name'] as String;
        _displayType[i] = _randomMenus[i]['type2'] as String;
      }
    });
  }

  // ฟังก์ชันนี้ใช้เพื่อเริ่มแอนิเมชันการแสดงการ์ดทีละใบ
  void _startCardAnimation() {
    for (int i = 0; i < 1; i++) {
      Future.delayed(Duration(milliseconds: i * 300), () {
        setState(() {
          _opacityList[i] = 1.0; // ทำให้การ์ดแต่ละใบค่อยๆ ปรากฏขึ้น
        });
      });
    }
  }

  void _reset() {
    setState(() {
      _timers.clear();
      _opacityList = List.generate(1, (_) => 0.0); // รีเซ็ตค่าแอนิเมชัน
      _fetchBreakfastMenus();
    });
  }

  Future<void> getnamefood(String namefood) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('food', namefood);
    Navigator.push(context, MaterialPageRoute(builder: (context) => menudes()));
  }

  @override
  void dispose() {
    for (var timer in _timers) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ผลการสุ่ม', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(backgroundColor: Colors.green),
            onPressed: _reset,
            icon: Icon(Icons.refresh, color: Colors.white),
            label: Text(
              'ทำการสุ่มใหม่',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        backgroundColor: Color.fromARGB(255, 252, 126, 88),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: 1,
        itemBuilder: (context, index) {
          return AnimatedOpacity(
            opacity: _opacityList[index], // ใช้ค่าความทึบในการแสดงแอนิเมชัน
            duration: Duration(milliseconds: 500),
            child: _buildTextItem(index),
          );
        },
      ),
    );
  }

  Widget _buildTextItem(int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 40, 8, 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 253, 190, 171), // ใช้โทนสีส้มอ่อน
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3), // เงาใต้การ์ด
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
          ),
          Text(
            _displayMenus[index],
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 86, 34),
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            _displayType[index],
            style: TextStyle(
              fontSize: 20,
              color: Colors.brown.shade500,
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                print(_displayMenus[index]);
                getnamefood(_displayMenus[index]);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.brown.shade500,
                backgroundColor: Color.fromARGB(255, 252, 126, 88),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
              child: Text('เลือก',
                  style: TextStyle(color: Colors.black, fontSize: 20)),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
