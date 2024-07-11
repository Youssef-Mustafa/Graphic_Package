import 'package:flutter/material.dart';

enum ShearingAxis { X, Y }

class ShearingPage extends StatefulWidget {
  @override
  _ShearingPageState createState() => _ShearingPageState();
}

class _ShearingPageState extends State<ShearingPage> {
  // Initial vertices of a square
  List<Offset> vertices = [
    Offset(50, 50),
    Offset(150, 50),
    Offset(150, 150),
    Offset(50, 150),
  ];

  // Default shearing factor and axis
  double defaultShearFactor = 0.0;
  ShearingAxis defaultShearingAxis = ShearingAxis.X;

  // Shearing factor
  double shearFactor = 0.0;
  ShearingAxis shearingAxis = ShearingAxis.X;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2D Shearing'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              child: CustomPaint(
                painter: ShearingPainter(vertices, shearFactor, shearingAxis),
              ),
            ),
            SizedBox(height: 100),
            Slider(
              value: shearFactor,
              min: -1.0,
              max: 1.0,
              onChanged: (value) {
                setState(() {
                  shearFactor = value;
                });
              },
            ),
            DropdownButton<ShearingAxis>(
              value: shearingAxis,
              onChanged: (ShearingAxis? newValue) {
                setState(() {
                  shearingAxis = newValue!;
                });
              },
              items: ShearingAxis.values.map((ShearingAxis axis) {
                return DropdownMenuItem<ShearingAxis>(
                  value: axis,
                  child: Text(axisToString(axis)),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetShearing,
              child: Text('Reset'),
            ),
            SizedBox(height: 20),
            Text('Shearing Factor: $shearFactor'),
          ],
        ),
      ),
    );
  }

  String axisToString(ShearingAxis axis) {
    switch (axis) {
      case ShearingAxis.X:
        return 'Shearing X';
      case ShearingAxis.Y:
        return 'Shearing Y';
    }
  }

  void _resetShearing() {
    setState(() {
      shearFactor = defaultShearFactor;
      shearingAxis = defaultShearingAxis;
    });
  }
}

class ShearingPainter extends CustomPainter {
  final List<Offset> vertices;
  final double shearFactor;
  final ShearingAxis shearingAxis;

  ShearingPainter(this.vertices, this.shearFactor, this.shearingAxis);

  @override
  void paint(Canvas canvas, Size size) {
    Paint axisPaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1.0;

    // Draw X-axis
    canvas.drawLine(Offset(0, size.height / 2),
        Offset(size.width, size.height / 2), axisPaint);

    // Draw Y-axis
    canvas.drawLine(Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height), axisPaint);

    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw the original square
    Path path = Path();
    path.moveTo(vertices[0].dx, vertices[0].dy);
    for (int i = 1; i < vertices.length; i++) {
      path.lineTo(vertices[i].dx, vertices[i].dy);
    }
    path.close();
    canvas.drawPath(path, paint);

    // Apply shearing transformation
    List<Offset> shearedVertices = [];
    for (var vertex in vertices) {
      double newX = vertex.dx;
      double newY = vertex.dy;
      if (shearingAxis == ShearingAxis.X) {
        newX += shearFactor * vertex.dy;
      }
      if (shearingAxis == ShearingAxis.Y) {
        newY += shearFactor * vertex.dx;
      }
      shearedVertices.add(Offset(newX, newY));
    }

    // Draw the sheared square
    Path shearedPath = Path();
    shearedPath.moveTo(shearedVertices[0].dx, shearedVertices[0].dy);
    for (int i = 1; i < shearedVertices.length; i++) {
      shearedPath.lineTo(shearedVertices[i].dx, shearedVertices[i].dy);
    }
    shearedPath.close();
    canvas.drawPath(shearedPath, paint);
  }

  @override
  bool shouldRepaint(ShearingPainter oldDelegate) {
    return oldDelegate.vertices != vertices ||
        oldDelegate.shearFactor != shearFactor ||
        oldDelegate.shearingAxis != shearingAxis;
  }
}
