import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_randomfood/pages/des.dart';
import 'package:flutter_application_randomfood/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Filp10Khao extends StatefulWidget {
  @override
  _CardFlipDemoState createState() => _CardFlipDemoState();
}

class _CardFlipDemoState extends State<Filp10Khao>
    with TickerProviderStateMixin {
  List<String> _allMenus = [];
  List<String> _allType = [];
  List<String> _displayMenus = List.generate(10, (_) => '');
  List<String> _displayType = List.generate(10, (_) => '');
  List<Map<String, dynamic>> _randomMenus = [];
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> itemlist = [];
  List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();
    _fetchBreakfastMenus();
  }

  Future<void> _fetchBreakfastMenus() async {
    final List<Map<String, dynamic>> maps =
        await _dbHelper.getfoodbytype2('ข้าว'); // ใส่ type อาหารลงไป

    setState(() {
      if (maps.length >= 10) {
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

    for (int i = 0; i < 10; i++) {
      int randomIndex = random.nextInt(menus.length);
      selectedMenus.add(menus[randomIndex]);

      //selectedMenus.removeAt(randomIndex);
    }
    return selectedMenus;
  }

  void _startShuffling() {
    for (int i = 0; i < 10; i++) {
      _timers.add(Timer.periodic(Duration(milliseconds: 100), (timer) {
        setState(() {
          _displayMenus[i] = _allMenus[Random().nextInt(_allMenus.length)];
          _displayType[i] = _allType[Random().nextInt(_allMenus.length)];
        });
      }));
    }

    // Stop shuffling after 3 seconds and display the final result
    Future.delayed(Duration(seconds: 2), () {
      _stopShuffling();
    });
  }

  void _stopShuffling() {
    for (var timer in _timers) {
      timer.cancel();
    }

    setState(() {
      for (int i = 0; i < 10; i++) {
        _displayMenus[i] = _randomMenus[i]['name'] as String;
        _displayType[i] = _randomMenus[i]['type2'] as String;
      }
    });
  }

  void _reset() {
    setState(() {
      _timers.clear();
      _fetchBreakfastMenus();
    });
  }

  Future<void> getnamefood(String namefood) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('food', namefood);
    Navigator.push(context, MaterialPageRoute(builder: (context) => testdes()));
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
        title: Text('ผลการสุ่ม'),
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
          return _buildTextItem(index);
        },
      ),
    );
  }

  Widget _buildTextItem(int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 40, 8, 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            _displayMenus[index],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            _displayType[index],
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                onPressed: () {
                  print(_displayMenus[index]);
                  getnamefood(_displayMenus[index]);
                  //โค้ดเมื่อกดปุ่มสุ่ม 10 ครั้ง
                },
                child: Text('เลือก')),
          )
        ],
      ),
    );
  }
}
