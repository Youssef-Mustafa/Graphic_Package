import 'package:flutter/material.dart';
import 'dart:math';

class testPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2D Rotation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: test(),
    );
  }
}

class test extends StatefulWidget {
  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  double rotationAngleX = 0.0;
  double rotationAngleY = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2D Rotation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateX(rotationAngleX)
                ..rotateY(rotationAngleY),
              alignment: FractionalOffset.center,
              child: Container(
                width: 200.0,
                height: 200.0,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Flutter',
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Rotate X'),
                Slider(
                  value: rotationAngleX,
                  min: 0,
                  max: pi * 2,
                  onChanged: (value) {
                    setState(() {
                      rotationAngleX = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Rotate Y'),
                Slider(
                  value: rotationAngleY,
                  min: 0,
                  max: pi * 2,
                  onChanged: (value) {
                    setState(() {
                      rotationAngleY = value;
                    });
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
