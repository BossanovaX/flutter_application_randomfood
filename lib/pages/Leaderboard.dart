import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';

class Leaderboard extends StatefulWidget {
  @override
  _TopFoodWithRatingPageState createState() => _TopFoodWithRatingPageState();
}

class _TopFoodWithRatingPageState extends State<Leaderboard> {
  List<DocumentSnapshot> _topFoods = [];
  late Database database;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchTopFoods();
    _initializeDatabase();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Don't forget to dispose of the controller
    super.dispose();
  }

  Future<void> _fetchTopFoods() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .orderBy('averageRating', descending: true) // เรียงจากคะแนนมากไปน้อย
        .orderBy('totalRatings',
            descending: true) // ถ้าคะแนนเท่ากัน ให้เรียงจากจำนวนรีวิวมากไปน้อย
        .limit(5)
        .get();

    setState(() {
      _topFoods = snapshot.docs;
    });
  }

  Future<void> _initializeDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'food_menu.db');

    database = await openDatabase(
      path,
      version: 1,
    );
  }

  Future<Uint8List?> _getFoodImage(String menuName) async {
    List<Map> result = await database
        .rawQuery('SELECT pic FROM food WHERE name = ?', [menuName]);
    if (result.isNotEmpty) {
      return result.first['pic']
          as Uint8List; // Assume pic is stored as Uint8List
    }
    return null; // Return null if no image found
  }

  Widget _buildRatingBar(int rating, int count, int total) {
    double ratingPercentage = total > 0 ? count / total : 0;
    return Row(
      children: [
        Text(
          rating.toString(),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            value: ratingPercentage,
            backgroundColor: Colors.grey[200],
            color: Colors.green,
          ),
        ),
        SizedBox(width: 8),
        Text(
          count.toString(),
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFFCFAEE),
        child: ListView.builder(
          controller: _scrollController, // Add the ScrollController here
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _topFoods.length,
          itemBuilder: (context, index) {
            var foodData = _topFoods[index].data() as Map<String, dynamic>;
            var menuName = foodData['menu'];
            var averageRating = foodData['averageRating']?.toDouble() ?? 0.0;
            var totalRatings = foodData['totalRatings'] ?? 0;
            var ratingCounts = foodData['ratingCounts'] ?? {};

            // Ensure all counts are integers using int keys
            Map<int, int> counts = {};
            for (int i = 1; i <= 5; i++) {
              counts[i] = ratingCounts[i.toString()] ??
                  0; // ใช้ String ในการเข้าถึงจาก Firestore
            }

            return FutureBuilder<Uint8List?>(
              future: _getFoodImage(menuName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            menuName,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        snapshot.data != null
                            ? Image.memory(
                                snapshot.data!,
                                height: 300,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Text('ไม่พบรูปภาพ',
                                style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            SizedBox(width: 30),
                            Text(
                              averageRating.toStringAsFixed(1),
                              style: TextStyle(
                                  fontSize: 48, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            Row(
                              children: List.generate(
                                5,
                                (starIndex) => Icon(
                                  starIndex < averageRating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.green,
                                  size: 28,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '$totalRatings รีวิว',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        _buildRatingBar(5, counts[5] ?? 0, totalRatings),
                        _buildRatingBar(4, counts[4] ?? 0, totalRatings),
                        _buildRatingBar(3, counts[3] ?? 0, totalRatings),
                        _buildRatingBar(2, counts[2] ?? 0, totalRatings),
                        _buildRatingBar(1, counts[1] ?? 0, totalRatings),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
