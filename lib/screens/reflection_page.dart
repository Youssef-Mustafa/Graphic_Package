import 'package:flutter/material.dart';

enum ReflectionAxis { xAxis, yAxis }

class ReflectionPage extends StatefulWidget {
  @override
  _ReflectionPageState createState() => _ReflectionPageState();
}

class _ReflectionPageState extends State<ReflectionPage> {
  double reflectionDegree = 1.0;
  ReflectionAxis reflectionAxis = ReflectionAxis.yAxis;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2D Reflection in Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReflectWidget(
              reflectionDegree: reflectionDegree,
              reflectionAxis: reflectionAxis,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Hello, Reflection!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            DropdownButton<ReflectionAxis>(
              value: reflectionAxis,
              onChanged: (newValue) {
                setState(() {
                  reflectionAxis = newValue!;
                });
              },
              items: [
                DropdownMenuItem(
                  value: ReflectionAxis.xAxis,
                  child: Text('Reflect on X-axis'),
                ),
                DropdownMenuItem(
                  value: ReflectionAxis.yAxis,
                  child: Text('Reflect on Y-axis'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Slider(
              value: reflectionDegree,
              min: -1.0,
              max: 1.0,
              onChanged: (value) {
                setState(() {
                  reflectionDegree = value;
                });
              },
            ),
            Text(
              'Reflection Degree: ${reflectionDegree.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class ReflectWidget extends StatelessWidget {
  final Widget child;
  final double reflectionDegree;
  final ReflectionAxis reflectionAxis;

  ReflectWidget({
    required this.child,
    required this.reflectionDegree,
    required this.reflectionAxis,
  });

  @override
  Widget build(BuildContext context) {
    double xScale = 1.0;
    double yScale = 1.0;

    if (reflectionAxis == ReflectionAxis.xAxis) {
      yScale = reflectionDegree;
    } else {
      xScale = reflectionDegree;
    }

    return Transform(
      transform: Matrix4.identity()..scale(xScale, yScale),
      alignment: Alignment.center,
      child: child,
    );
  }
}
