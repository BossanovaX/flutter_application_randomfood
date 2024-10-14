// import 'package:flutter/material.dart';
// import 'package:flutter_application_randomfood/pages/StartScreen.dart';
// import 'package:flutter_application_randomfood/pages/Random_Break.dart';
// import 'package:flutter_application_randomfood/pages/Random_Lunch.dart';
// import 'package:flutter_application_randomfood/pages/Random_dinner.dart';
// import 'package:flutter_application_randomfood/pages/Random_Normal.dart';
// import 'package:flutter_application_randomfood/pages/Random_isslam.dart';
// import 'package:flutter_application_randomfood/pages/Random_sen.dart';
// import 'package:flutter_application_randomfood/pages/Random_Khao.dart';
// import 'package:flutter_application_randomfood/pages/Random_Kubkhao.dart';
// import 'package:flutter_application_randomfood/pages/Random_desert.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_application_randomfood/test/test.dart';
// import 'firebase_options.dart';
// import 'package:flutter_application_randomfood/test/testfire.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MenuScreen(),
//       theme: ThemeData(
//         fontFamily: 'Arial',
//         primaryColor: Colors.red,
//       ),
//     );
//   }
// }

// class MenuScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.redAccent,
//         title: Text('เมนูสุ่มอาหาร', style: TextStyle(color: Colors.white)),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.white, Colors.redAccent.shade100],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: ListView(
//           padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
//           children: [
//             Align(
//               alignment: Alignment.topRight,
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => bgscreen()));
//                 },
//                 icon: Icon(Icons.arrow_back),
//                 label: Text('ย้อนกลับ'),
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.redAccent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             buildSectionTitle('เมนูยอดนิยม'),
//             buildDivider(),
//             MenuButton(
//               title: '5 อันดับอาหารยอดนิยมอาทิตย์นี้',
//               icon: Icons.star,
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => testfire()));
//               },
//             ),
//             buildSectionTitle('Menu'),
//             buildDivider(),
//             MenuButton(
//               title: 'สุ่มอาหารเช้า',
//               icon: Icons.free_breakfast,
//               onPressed: () {
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (context) => chao()));
//               },
//             ),
//             MenuButton(
//               title: 'สุ่มอาหารกลางวัน',
//               icon: Icons.lunch_dining,
//               onPressed: () {
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (context) => lunch()));
//               },
//             ),
//             MenuButton(
//               title: 'สุ่มอาหารเย็น',
//               icon: Icons.dinner_dining,
//               onPressed: () {
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (context) => dinner()));
//               },
//             ),
//             buildSectionTitle('เมนูอาหารทั่วไป'),
//             buildDivider(),
//             MenuButton(
//               title: 'สุ่มอาหารอิสลาม',
//               icon: Icons.restaurant_menu,
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => issalam()));
//               },
//             ),
//             MenuButton(
//               title: 'สุ่มอาหารจานเดียว',
//               icon: Icons.fastfood,
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => RandomNormal()));
//               },
//             ),
//             MenuButton(
//               title: 'สุ่มอาหารประเภทของหวาน',
//               icon: Icons.cake,
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => RandomDesert()));
//               },
//             ),
//             buildSectionTitle('เมนูอาหารตามประเภท'),
//             buildDivider(),
//             MenuButton(
//               title: 'สุ่มอาหารประเภทเส้น',
//               icon: Icons.ramen_dining,
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => RandomSen()));
//               },
//             ),
//             MenuButton(
//               title: 'สุ่มอาหารประเภทข้าว',
//               icon: Icons.rice_bowl,
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => RandomKhao()));
//               },
//             ),
//             MenuButton(
//               title: 'สุ่มอาหารประเภทกับข้าว',
//               icon: Icons.set_meal,
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => RandomKubkhao()));
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Center(
//         child: Text(
//           title,
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.redAccent,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildDivider() {
//     return Divider(
//       color: Colors.redAccent,
//       thickness: 2,
//       indent: 100,
//       endIndent: 100,
//     );
//   }
// }

// class MenuButton extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final VoidCallback onPressed;

//   const MenuButton({
//     required this.title,
//     required this.icon,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           foregroundColor: Colors.black,
//           backgroundColor: Colors.white,
//           padding: EdgeInsets.all(16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           shadowColor: Colors.redAccent,
//           elevation: 5,
//           side: BorderSide(color: Colors.redAccent),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Text(
//               title,
//               style: TextStyle(fontSize: 18),
//             ),
//             Icon(
//               icon,
//               color: Colors.redAccent,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
