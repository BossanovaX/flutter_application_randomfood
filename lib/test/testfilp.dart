import 'package:flutter/material.dart';

class testfilp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CardFlipDemo(),
    );
  }
}

class CardFlipDemo extends StatefulWidget {
  @override
  _CardFlipDemoState createState() => _CardFlipDemoState();
}

class _CardFlipDemoState extends State<CardFlipDemo>
    with SingleTickerProviderStateMixin {
  bool isFront = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  void _flipCard() {
    if (isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    isFront = !isFront;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Card Flip Animation')),
      body: Center(
        child: GestureDetector(
          onTap: _flipCard,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final angle = _animation.value * 3.1416; // 3.1416 = pi
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(angle),
                child: angle > 1.5708 // 1.5708 = pi / 2
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(3.1416),
                        child: _buildBackSide(),
                      )
                    : _buildFrontSide(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFrontSide() {
    return Container(
      width: 200,
      height: 300,
      color: Colors.blue,
      child: Center(
        child: Text(
          'Front Side',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildBackSide() {
    return Container(
      width: 200,
      height: 300,
      color: Colors.red,
      child: Center(
        child: Text(
          'Back Side',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
