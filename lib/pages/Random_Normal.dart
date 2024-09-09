import 'package:flutter/material.dart';

import 'package:flutter_application_randomfood/filp/filp10_lunch.dart';

import 'package:flutter_application_randomfood/filp/filp1_lunch.dart';
import 'package:flutter_application_randomfood/services/database_service.dart';

class RandomNormal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เมนูสุ่มอาหารจานเดียว'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          MenuCard(),
          SizedBox(height: 16),
        ],
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
    // แก้ไขให้กรองเฉพาะรายการอาหารเช้า
    final itemlist = await _dbhelper.getfoodbytype2('ข้าว');
    final itemlist1 = await _dbhelper.getfoodbytype2('เส้น');
    setState(() {
      _item = itemlist + itemlist1;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getitem(); // โหลดข้อมูลเมื่อเริ่มต้น
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
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
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: IconButton(
                    icon: Icon(Icons.help_outline,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          insetPadding: const EdgeInsets.all(16),
                          title: Text('รายการอาหาร'),
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
                                        title: Text(fooditem['name']),
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
                    image: DecorationImage(
                      image: AssetImage("assets/images/lunch.jpeg"),
                      fit: BoxFit.cover,
                    ),
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
                      return Filp1Lunch();
                    }));
                    // โค้ดเมื่อกดปุ่มสุ่ม 10 ครั้ง
                  },
                  style: ElevatedButton.styleFrom(),
                  child: Text('สุ่ม 1 ครั้ง'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Filp10Lunch();
                    }));
                    // โค้ดเมื่อกดปุ่มสุ่ม 10 ครั้ง
                  },
                  style: ElevatedButton.styleFrom(),
                  child: Text('สุ่ม 10 ครั้ง'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
