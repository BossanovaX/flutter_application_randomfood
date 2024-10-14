import 'package:flutter/material.dart';
import 'package:flutter_application_randomfood/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_randomfood/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_randomfood/pages/map.dart';

class menudes extends StatefulWidget {
  @override
  State<menudes> createState() => _MenudesState();
}

class _MenudesState extends State<menudes> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  String namefood = '';
  List<dynamic> desc = [];
  int? _rating;

  @override
  void initState() {
    super.initState();
    getfood();
  }

  Future<void> getfood() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String food = prefs.getString('food') ?? '';
    setState(() {
      namefood = food;
    });
    final List<Map<String, dynamic>> maps =
        await _dbHelper.getfoodbyname(namefood);
    print(maps);
    setState(() {
      desc = maps;
    });
  }

  Future<void> _submitRating() async {
    if (_rating != null) {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('ratings')
          .where('menu', isEqualTo: desc[0]['name'])
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        FirebaseFirestore.instance.collection('ratings').add({
          'menu': desc[0]['name'],
          'averageRating': _rating!.toDouble(),
          'totalRatings': 1,
          'ratingCounts': {
            '1': _rating == 1 ? 1 : 0,
            '2': _rating == 2 ? 1 : 0,
            '3': _rating == 3 ? 1 : 0,
            '4': _rating == 4 ? 1 : 0,
            '5': _rating == 5 ? 1 : 0,
          },
          'timestamp': FieldValue.serverTimestamp(),
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('เพิ่มคะแนนเมนู ${desc[0]['name']} เรียบร้อยแล้ว!')),
          );
        });
        Navigator.of(context).pop();
      } else {
        var doc = querySnapshot.docs.first;
        var ratingCounts = doc['ratingCounts'];
        int totalRatings = doc['totalRatings'];
        double averageRating = doc['averageRating'];

        FirebaseFirestore.instance.collection('ratings').doc(doc.id).update({
          'ratingCounts.${_rating}': ratingCounts['$_rating'] + 1,
          'totalRatings': totalRatings + 1,
          'averageRating': ((averageRating.toDouble() * totalRatings) +
                  _rating!.toDouble()) /
              (totalRatings + 1),
          'timestamp': FieldValue.serverTimestamp(),
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('เพิ่มคะแนนเมนู ${desc[0]['name']} เรียบร้อยแล้ว!')),
          );
          Navigator.of(context).pop();
        });
      }
    }
  }

  Future<void> sendnamefood(String namefood) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('food', namefood);
    Navigator.push(context, MaterialPageRoute(builder: (context) => desmap()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ผลการสุ่ม', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(backgroundColor: Color(0xFFA04747)),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MenuScreen()));
            },
            icon: Icon(Icons.home, color: Color(0xFF800000)),
            label: Text(
              'หน้าหลัก',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        backgroundColor: Color(0xFFD8D2C2),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Text(
                    namefood,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                Divider(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  thickness: 2,
                  indent: 100,
                  endIndent: 100,
                ),
                SizedBox(height: 10),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.memory(
                      desc[0]['pic'],
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'ประเภท : ${desc[0]['type2']}',
                    style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                SizedBox(height: 30),
                MenuButton(
                  title: 'ร้านอาหารใกล้ฉัน',
                  onPressed: () async {
                    await sendnamefood(namefood);
                  },
                ),
                MenuButton(
                  title: 'ให้คะแนนอาหารเมนูนี้',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => StatefulBuilder(
                        builder: (context, setState) => Container(
                          height: MediaQuery.of(context).size.height * .33,
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'ให้คะแนนอาหาร',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                DropdownButton<int>(
                                  value: _rating,
                                  hint: Text('เลือกคะแนน'),
                                  items: List.generate(5, (index) {
                                    int ratingValue = index + 1;
                                    return DropdownMenuItem(
                                      value: ratingValue,
                                      child: Text(
                                        '${ratingValue.toString()}  คะแนน',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    );
                                  }),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _rating = newValue;
                                    });
                                  },
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 228, 80, 80),
                                      ),
                                      child: Text(
                                        'ยกเลิก',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    ElevatedButton(
                                      onPressed: _submitRating,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      child: Text(
                                        'ยืนยัน',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
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
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 18),
            ),
            Icon(
              Icons.arrow_forward,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ],
        ),
      ),
    );
  }
}
