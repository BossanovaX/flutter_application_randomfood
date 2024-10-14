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
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_randomfood/pages/map2.dart';
import 'firebase_options.dart';
import 'package:flutter_application_randomfood/pages/Leaderboard.dart'; // Assuming you have a MapScreen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: bgscreen(),
      theme: ThemeData(
        fontFamily: 'Arial',
        primaryColor: Colors.red,
      ),
    );
  }
}

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentIndex = 1;
  Color _appBarColor = Color(0xFFA5B68D); // สีเริ่มต้นของ AppBar

  final List<Widget> _pages = [
    Leaderboard(), // หน้าอันดับยอดนิยม
    MenuListScreen(), // หน้าหลักเมนูอาหาร
    desmap2(), // หน้าจอแผนที่
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      // เปลี่ยนสีของ AppBar ตามประเภทเมนูที่เลือก
      if (index == 0) {
        // ถ้ากดที่ "อาหารยอดนิยม"
        _appBarColor = Colors.green; // เปลี่ยนสีเป็นสีเขียว
      } else if (index == 1) {
        // ถ้ากดที่ "อาหารยอดนิยม"
        _appBarColor = Color(0xFFA5B68D); // เปลี่ยนสีเป็นสีเขียว
      } else {
        _appBarColor = Color.fromARGB(255, 209, 226, 185); // สีเริ่มต้น
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300), // ความเร็วของการเปลี่ยนสี
          color: _appBarColor, // ใช้ตัวแปรสีของ AppBar
          child: AppBar(
            title: Center(
              child: Text('GinRai Homescreen',
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
            ),
            backgroundColor: Colors.transparent, // ทำให้พื้นหลังโปร่งใส
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped, // ใช้ฟังก์ชันสำหรับการกด
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.star,
                color: Colors.green,
              ),
              label: 'อาหารยอดนิยม'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'เมนู',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
              color: Colors.black,
            ),
            label: 'แผนที่',
          ),
        ],
      ),
    );
  }
}

class MenuListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFCFAEE), Color(0xFFECDFCC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                color: Color(0xFFDA8359),
                height: 10,
                thickness: 2,
                indent: 50,
                endIndent: 50,
              ),
              Center(child: buildSectionTitle('สุ่มตามมื้ออาหาร')),
              Divider(
                color: Color(0xFFDA8359),
                height: 10,
                thickness: 2,
                indent: 50,
                endIndent: 50,
              ),
              SizedBox(height: 10),
              buildMenuGrid(menuItems), // แสดงการ์ดเมนูอาหาร
              SizedBox(height: 20), // ระยะห่างระหว่างหัวข้อ
              Divider(
                color: Color(0xFFDA8359),
                height: 10,
                thickness: 2,
                indent: 50,
                endIndent: 50,
              ),
              Center(child: buildSectionTitle('สุ่มตามประเภทอาหาร')),
              Divider(
                color: Color(0xFFDA8359),
                height: 10,
                thickness: 2,
                indent: 50,
                endIndent: 50,
              ),
              SizedBox(height: 10),
              buildMenuGrid(generalMenuItems), // แสดงการ์ดเมนูทั่วไป
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

  Widget buildMenuGrid(List<MenuItem> items) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // แสดง 2 คอลัมน์ต่อแถว
        crossAxisSpacing: 10, // ระยะห่างแนวนอนระหว่างการ์ด
        mainAxisSpacing: 10, // ระยะห่างแนวตั้งระหว่างการ์ด
      ),
      physics:
          NeverScrollableScrollPhysics(), // ทำให้ไม่สามารถเลื่อน GridView ได้
      shrinkWrap: true, // ทำให้ GridView มีขนาดตามเนื้อหา
      itemCount: items.length,
      itemBuilder: (context, index) {
        return MenuCard(items[index]);
      },
    );
  }
}

// ข้อมูลเมนูอาหาร
final List<MenuItem> menuItems = [
  MenuItem(
    title: 'อาหารเช้า',
    icon: Icons.free_breakfast,
    iconColor: Color.fromARGB(255, 247, 227, 114), // เปลี่ยนสีไอคอนที่นี่
    page: Chao(),
  ),
  MenuItem(
    title: 'อาหารกลางวัน',
    icon: Icons.lunch_dining,
    iconColor: Color.fromARGB(255, 252, 126, 88), // เปลี่ยนสีไอคอนที่นี่
    page: lunch(),
  ),
  MenuItem(
    title: 'อาหารเย็น',
    icon: Icons.dinner_dining,
    iconColor: Colors.orange, // เปลี่ยนสีไอคอนที่นี่
    page: dinner(),
  ),
];

// ข้อมูลเมนูอาหารทั่วไป
final List<MenuItem> generalMenuItems = [
  MenuItem(
    title: 'อิสลาม',
    icon: Icons.restaurant_menu,
    iconColor: Color.fromARGB(255, 216, 200, 181), // เปลี่ยนสีไอคอนที่นี่
    page: issalam(),
  ),
  MenuItem(
    title: 'จานเดียว',
    icon: Icons.fastfood,
    iconColor: Color(0xFF798645), // เปลี่ยนสีไอคอนที่นี่
    page: Normal(),
  ),
  MenuItem(
    title: 'เส้น',
    icon: Icons.ramen_dining,
    iconColor: Colors.brown, // เปลี่ยนสีไอคอนที่นี่
    page: RandomSen(),
  ),
  MenuItem(
    title: 'ข้าว',
    icon: Icons.rice_bowl,
    iconColor: Color.fromARGB(255, 255, 218, 175), // เปลี่ยนสีไอคอนที่นี่
    page: RandomKhao(),
  ),
  MenuItem(
    title: 'กับข้าว',
    icon: Icons.set_meal,
    iconColor: Color(0xFF254336), // เปลี่ยนสีไอคอนที่นี่
    page: RandomKubkhao(),
  ),
  MenuItem(
    title: 'ของหวาน',
    icon: Icons.cake,
    iconColor: Color.fromARGB(255, 252, 186, 45), // เปลี่ยนสีไอคอนที่นี่
    page: desert(),
  ),
];

// คลาสสำหรับเมนู
class MenuItem {
  final String title;
  final IconData icon;
  final Color iconColor; // เพิ่มสีสำหรับไอคอน
  final Widget page;

  MenuItem(
      {required this.title,
      required this.icon,
      required this.iconColor,
      required this.page});
}

// คลาสสำหรับการ์ดเมนู
class MenuCard extends StatelessWidget {
  final MenuItem item;

  const MenuCard(this.item);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => item.page));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              item.icon,
              size: 40,
              color: item.iconColor, // สีไอคอน
            ),
            SizedBox(height: 8),
            const Text(
              'สุ่มอาหาร :',
              style: TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            //SizedBox(height: 8)
            Text(
              '${item.title}', // แสดงประเภทอาหาร
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8), // ระยะห่าง
          ],
        ),
      ),
    );
  }
}
