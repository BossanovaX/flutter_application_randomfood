import 'package:flutter/material.dart';
import 'package:flutter_application_randomfood/pages/filp10_desert.dart';
import 'package:flutter_application_randomfood/pages/filp1_desert.dart';

class desert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เมนูสุ่มของหวาน'),
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
                child: Image.network(
                    'https://cdn.discordapp.com/attachments/1153664982374961223/1270800180358287401/aeedc89b397e3d0f.png?ex=66bb9be5&is=66ba4a65&hm=2d4c725eca4e6bf913dafba9a67155f5fc12deed2911098c67eece7d5c307df3'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Filp1Desert();
                    }));
                    // โค้ดเมื่อกดปุ่มสุ่ม 10 ครั้ง
                  },
                  style: ElevatedButton.styleFrom(),
                  child: Text('สุ่ม 1 ครั้ง'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Filp10Desert();
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
