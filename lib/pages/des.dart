import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_randomfood/services/database_service.dart';

class testdes extends StatefulWidget {
  @override
  State<testdes> createState() => _testdesState();
}

class _testdesState extends State<testdes> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  Future<void> getfood() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String food = prefs.getString('food') ?? '';
    setState(() {
      namefood = food;
    });
    final List<Map<String, dynamic>> maps =
        await _dbHelper.getfoodbyname(namefood); // ใส่ type อาหารลงไป
    print(maps);
    setState(() {
      desc = maps;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getfood();
  }

  String namefood = '';
  List<dynamic> desc = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ผลการสุ่ม'),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 10),
              Center(
                child: Text(
                  namefood,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                color: Color.fromARGB(255, 245, 47, 12),
                thickness: 2,
                indent: 100,
                endIndent: 100,
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: Image.memory(
                desc[0]['pic'],
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              )),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  desc[0]['name'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  desc[0]['type2'],
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MenuButton(title: 'ร้านอาหารใกล้ฉัน', onPressed: () {})
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
          padding: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide(color: Colors.white),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 18),
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
