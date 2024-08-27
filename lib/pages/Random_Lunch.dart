import 'package:flutter/material.dart';

import 'package:flutter_application_randomfood/pages/filp10_lunch.dart';
import 'package:flutter_application_randomfood/pages/filp1_lunch.dart';

class lunch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เมนูสุ่มอาหารกลางวัน'),
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

class MenuCard extends StatelessWidget {
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
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.help_outline,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                    onPressed: () {
                      // โค้ดเมื่อกดปุ่มเครื่องหมายคำถาม
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
                  decoration: const BoxDecoration(
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
