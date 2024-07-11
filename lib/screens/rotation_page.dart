import 'package:flutter/material.dart';

class RotationPage extends StatefulWidget {
  @override
  _RotationPageState createState() => _RotationPageState();
}

class _RotationPageState extends State<RotationPage> {
  double rotateX = 0.0;
  double rotateY = 0.0;

  void resetRotation() {
    setState(() {
      rotateX = 0.0;
      rotateY = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2D Rotation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateX(rotateX * 0.0174533) // Convert degrees to radians
                ..rotateY(rotateY * 0.0174533),
              alignment: FractionalOffset.center,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Rotate Me',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Rotate in X'),
            Slider(
              value: rotateX,
              min: -180,
              max: 180,
              onChanged: (value) {
                setState(() {
                  rotateX = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Rotate in Y'),
            Slider(
              value: rotateY,
              min: -180,
              max: 180,
              onChanged: (value) {
                setState(() {
                  rotateY = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetRotation,
              child: Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
