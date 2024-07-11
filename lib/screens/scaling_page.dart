import 'package:flutter/material.dart';

class ScalingPage extends StatefulWidget {
  @override
  _ScalingPageState createState() => _ScalingPageState();
}

class _ScalingPageState extends State<ScalingPage> {
  double initialScaleX = 1.0;
  double initialScaleY = 1.0;
  double scaleX = 1.0;
  double scaleY = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2D Scaling'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200 * scaleX,
              height: 100 * scaleY,
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Scaled Object',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 200),
            Text('Scale X: ${scaleX.toStringAsFixed(2)}'),
            Slider(
              value: scaleX,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              onChanged: (value) {
                setState(() {
                  scaleX = value;
                });
              },
            ),
            Text('Scale Y: ${scaleY.toStringAsFixed(2)}'),
            Slider(
              value: scaleY,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              onChanged: (value) {
                setState(() {
                  scaleY = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  scaleX = initialScaleX;
                  scaleY = initialScaleY;
                });
              },
              child: Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
