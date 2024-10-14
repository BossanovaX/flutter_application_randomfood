import 'package:flutter/material.dart';
import 'package:flutter_application_randomfood/filp/filp10_khao.dart';
import 'package:flutter_application_randomfood/filp/filp1_khao.dart';

import 'package:flutter_application_randomfood/services/database_service.dart';

class RandomKhao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เมนูสุ่มอาหารประเภทข้าว', style: TextStyle(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 250, 231, 210),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xFFFEFAE0)),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            MenuCard(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class MenuCard extends StatefulWidget {
  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  final _foodnameController = TextEditingController();
  final _fooddecController = TextEditingController();
  final DatabaseHelper _dbhelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _item = [];

  Future<void> additem() async {
    final foodname = _foodnameController.text;
    final fooddec = _fooddecController.text;

    if (foodname.isNotEmpty && fooddec.isNotEmpty) {
      await _dbhelper.insertFood(foodname, fooddec);
      _foodnameController.clear();
      _fooddecController.clear();
      print('Added $foodname to the database');
      getitem();
    } else {
      print('Please enter both food name and description');
    }
  }

  Future<void> getitem() async {
    final itemlist = await _dbhelper.getfoodbytype2('ข้าว');
    setState(() {
      _item = itemlist;
    });
  }

  @override
  void initState() {
    super.initState();
    getitem();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'ตัวอย่างภาพเมนูสุ่มอาหาร',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: IconButton(
                    icon: Icon(Icons.help_outline, color: Colors.black54),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          insetPadding: const EdgeInsets.all(16),
                          title: Text('รายการอาหาร',
                              style: TextStyle(fontSize: 20)),
                          content: SizedBox(
                            width: 300,
                            height: 300,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _item.length,
                                    itemBuilder: (context, index) {
                                      final fooditem = _item[index];
                                      return ListTile(
                                        title: Text(fooditem['name'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        subtitle: Text(fooditem['description']),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 300,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage("assets/images/kao.jpg"),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Filp1Khao();
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 250, 231, 210),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text('สุ่ม 1 ครั้ง',
                      style: TextStyle(
                          fontSize: 18, color: Color.fromARGB(255, 0, 0, 0))),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Filp10Khao();
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 250, 231, 210),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text('สุ่ม 10 ครั้ง',
                      style: TextStyle(
                          fontSize: 18, color: Color.fromARGB(255, 0, 0, 0))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
