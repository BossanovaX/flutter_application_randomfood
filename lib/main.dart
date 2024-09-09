import 'package:flutter/material.dart';
import 'package:flutter_application_randomfood/pages/StartScreen.dart';
import 'package:flutter_application_randomfood/pages/Random_Break.dart';
import 'package:flutter_application_randomfood/pages/Random_Lunch.dart';
import 'package:flutter_application_randomfood/pages/Random_dinner.dart';
import 'package:flutter_application_randomfood/pages/Random_Normal.dart';
import 'package:flutter_application_randomfood/pages/Random_isslam.dart';
import 'package:flutter_application_randomfood/pages/Random_sen.dart';
import 'package:flutter_application_randomfood/pages/Random_Khao.dart';
import 'package:flutter_application_randomfood/pages/Random_Kubkhao.dart';
import 'package:flutter_application_randomfood/pages/Random_desert.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: bgscreen(),
      //home: testfilp10(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return bgscreen();
                    }));
                    // Handle logout action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 236, 7, 7),
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Logout'),
                ),
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(
                color: Color.fromARGB(255, 245, 47, 12),
                thickness: 2,
                indent: 100,
                endIndent: 100,
              ),
              const SizedBox(height: 20),
              MenuButton(
                title: 'สุ่มอาหารเช้า',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return chao();
                  }));
                  // ใส่โค้ดที่ต้องการเมื่อกดปุ่ม
                },
              ),
              MenuButton(
                title: 'สุ่มอาหารกลางวัน',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return lunch();
                  }));
                  // ใส่โค้ดที่ต้องการเมื่อกดปุ่ม
                },
              ),
              MenuButton(
                title: 'สุ่มอาหารเย็น',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return dinner();
                  }));
                  // ใส่โค้ดที่ต้องการเมื่อกดปุ่ม
                },
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'เมนูอาหารทั่วไป',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(
                color: Color.fromARGB(255, 245, 47, 12),
                thickness: 2,
                indent: 100,
                endIndent: 100,
              ),
              const SizedBox(height: 20),
              MenuButton(
                title: 'สุ่มอาหารอิสลาม',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return issalam();
                  }));
                  // ใส่โค้ดที่ต้องการเมื่อกดปุ่ม
                },
              ),
              MenuButton(
                title: 'สุ่มอาหารจานเดียว',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RandomNormal();
                  }));
                  // ใส่โค้ดที่ต้องการเมื่อกดปุ่ม
                },
              ),
              MenuButton(
                title: 'สุ่มอาหารประเภทของหวาน',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RandomDesert();
                  }));
                  // ใส่โค้ดที่ต้องการเมื่อกดปุ่ม
                },
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'เมนูอาหารตามประเภท',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(
                color: Color.fromARGB(255, 245, 47, 12),
                thickness: 2,
                indent: 100,
                endIndent: 100,
              ),
              const SizedBox(height: 20),
              MenuButton(
                title: 'สุ่มอาหารประเภทเส้น',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RandomSen();
                  }));
                  // ใส่โค้ดที่ต้องการเมื่อกดปุ่ม
                },
              ),
              MenuButton(
                title: 'สุ่มอาหารประเภทข้าว',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RandomKhao();
                  }));
                  // ใส่โค้ดที่ต้องการเมื่อกดปุ่ม
                },
              ),
              MenuButton(
                title: 'สุ่มอาหารประเภทกับข้าว',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RandomKubkhao();
                  }));
                  // ใส่โค้ดที่ต้องการเมื่อกดปุ่ม
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  MenuButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        // Handle button press
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: const BorderSide(color: Colors.white),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 18),
            ),
            const Icon(
              Icons.arrow_forward,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
