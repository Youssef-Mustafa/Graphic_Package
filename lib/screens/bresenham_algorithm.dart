import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

Color primary = Color(0xff3f51b5);
Color secondary = Color(0xfff5a623);
Color mainColor = Color(0xffeeeeee);

class Line extends StatelessWidget {
  const Line({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BresenhamPage(),
    );
  }
}

class BresenhamPage extends StatefulWidget {
  const BresenhamPage({super.key});

  @override
  _BresenhamPageState createState() => _BresenhamPageState();
}

class _BresenhamPageState extends State<BresenhamPage> {
  Offset? startPoint;
  Offset? endPoint;
  List<Offset> points = [];

  TextEditingController startXController = TextEditingController();
  TextEditingController startYController = TextEditingController();
  TextEditingController endXController = TextEditingController();
  TextEditingController endYController = TextEditingController();

  void drawLineBresenham(Offset start, Offset end) {
    setState(() {
      points = _calculatePoints(start, end);
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LineDisplayScreen(points),
      ),
    );
  }

  List<Offset> _calculatePoints(Offset start, Offset end) {
    List<Offset> calculatedPoints = [];
    int x1 = start.dx.round();
    int y1 = start.dy.round();
    int x2 = end.dx.round();
    int y2 = end.dy.round();

    int dx = (x2 - x1).abs();
    int dy = (y2 - y1).abs();
    int sx = x1 < x2 ? 1 : -1;
    int sy = y1 < y2 ? 1 : -1;
    int err = dx - dy;

    while (x1 != x2 || y1 != y2) {
      calculatedPoints.add(Offset(x1.toDouble(), y1.toDouble()));
      int e2 = 2 * err;
      if (e2 > -dy) {
        err -= dy;
        x1 += sx;
      }
      if (e2 < dx) {
        err += dx;
        y1 += sy;
      }
    }

    calculatedPoints.add(Offset(x2.toDouble(), y2.toDouble()));
    return calculatedPoints;
  }

  void viewPoints() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PointsPage(points),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text(
          'Draw line with Bresenham',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: startXController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Start X'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: startYController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Start Y'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: endXController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'End X'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: endYController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'End Y'),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: secondary),
            onPressed: () {
              setState(() {
                startPoint = Offset(
                  double.parse(startXController.text),
                  double.parse(startYController.text),
                );
                endPoint = Offset(
                  double.parse(endXController.text),
                  double.parse(endYController.text),
                );
                drawLineBresenham(startPoint!, endPoint!);
              });
            },
            child: const Text('Draw Line With Bresenham'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: secondary),
            onPressed: points.isNotEmpty ? viewPoints : null,
            child: const Text('View Points'),
          ),
        ],
      ),
    );
  }
}

class LineDisplayScreen extends StatefulWidget {
  final List<Offset> points;

  LineDisplayScreen(this.points);

  @override
  _LineDisplayScreenState createState() => _LineDisplayScreenState();
}

class _LineDisplayScreenState extends State<LineDisplayScreen> {
  double _scale = 1.0;

  void _zoomIn() {
    setState(() {
      _scale *= 1.5; // Increase scale for zooming in
    });
  }

  void _zoomOut() {
    setState(() {
      _scale /= 1.5; // Decrease scale for zooming out
    });
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Offset, double>> _createData() {
      // Find min and max coordinates for X and Y axes
      double minX = double.infinity;
      double maxX = double.negativeInfinity;
      double minY = double.infinity;
      double maxY = double.negativeInfinity;
      widget.points.forEach((point) {
        if (point.dx < minX) minX = point.dx;
        if (point.dx > maxX) maxX = point.dx;
        if (point.dy < minY) minY = point.dy;
        if (point.dy > maxY) maxY = point.dy;
      });

      final data = widget.points.map((point) {
        return Offset(point.dx.toDouble(), point.dy.toDouble());
      }).toList();

      return [
        charts.Series<Offset, double>(
          id: 'Line',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (Offset point, _) => point.dx,
          measureFn: (Offset point, _) => point.dy,
          data: data,
        )
      ];
    }

    var chart = charts.ScatterPlotChart(
      _createData(),
      animate: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Line Display With Bresenham'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onScaleUpdate: (details) {
                  setState(() {
                    _scale = details.scale;
                  });
                },
                child: Container(
                  constraints: BoxConstraints.expand(),
                  child: Transform.scale(
                    scale: _scale,
                    child: chart,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _zoomIn,
                  child: const Text('Zoom In'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _zoomOut,
                  child: const Text('Zoom Out'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = secondary
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    if (points.isNotEmpty) {
      for (int i = 0; i < points.length - 1; i++) {
        canvas.drawLine(
          Offset(centerX + points[i].dx, centerY + points[i].dy),
          Offset(centerX + points[i + 1].dx, centerY + points[i + 1].dy),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class PointsPage extends StatelessWidget {
  final List<Offset> points;

  PointsPage(this.points);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text(
          'Points',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: points.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                'Point ${index + 1}: (${points[index].dx}, ${points[index].dy})'),
          );
        },
      ),
    );
  }
}
