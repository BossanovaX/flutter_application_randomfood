import 'package:flutter/material.dart';
import 'package:flutter_application_randomfood/main.dart';
import 'package:flutter_application_randomfood/services/database_service.dart';

class tripage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Text("Welcome"),
        appBar: AppBar(
          title: Text('เมนูสุ่ม'),
        ));
  }
}

class bgscreen extends StatelessWidget {
  final DatabaseHelper _dbhelper = DatabaseHelper.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Tren3.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _dbhelper.replaceDatabase();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MenuScreen()));
                    // Handle logout action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    foregroundColor: Color.fromARGB(255, 236, 51, 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Get Started'),
                ),
              ),
              SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
    );
  }
}
