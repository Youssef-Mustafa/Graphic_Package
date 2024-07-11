import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

Color primary = const Color(0xff3f51b5);
Color secondary = const Color(0xfff5a623);
Color tirnary = const Color(0xff2b387c);

class DrawingPage extends StatefulWidget {
  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  Offset? centerPoint;
  double? radius;
  List<Offset> circlePoints = [];
  List<double> decisionParameters = [];

  TextEditingController centerXController = TextEditingController();
  TextEditingController centerYController = TextEditingController();
  TextEditingController radiusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text(
          'Circle Drawing Algorithm',
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
                    controller: centerXController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Center X'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: centerYController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Center Y'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: radiusController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Radius'),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                // Reset circle and points lists
                circlePoints.clear();
                decisionParameters.clear();

                centerPoint = Offset(
                  double.parse(centerXController.text),
                  double.parse(centerYController.text),
                );
                radius = double.parse(radiusController.text);
                _calculateCirclePoints(centerPoint!, radius!);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CircleDisplayPage(centerPoint!,
                        radius!, circlePoints, decisionParameters),
                  ),
                );
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: secondary),
              width: 150,
              height: 50,
              child: const Center(
                child: Text(
                  'Draw Circle',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: secondary,
            ),
            onPressed: () {
              if (circlePoints.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PointsDisplayPage(circlePoints, decisionParameters),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('No Points'),
                      content: const Text(
                          'Please draw a circle first to calculate points.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Text('Show Points'),
          ),
        ],
      ),
    );
  }

  void _calculateCirclePoints(Offset center, double radius) {
    int x = 0, y = radius.round();
    double d = 5.0 / 4 - radius.round().toDouble();

    void _plotCirclePoints(int x, int y) {
      circlePoints.add(Offset(center.dx + x, center.dy + y));
      circlePoints.add(Offset(center.dx - x, center.dy + y));
      circlePoints.add(Offset(center.dx + x, center.dy - y));
      circlePoints.add(Offset(center.dx - x, center.dy - y));
      circlePoints.add(Offset(center.dx + y, center.dy + x));
      circlePoints.add(Offset(center.dx - y, center.dy + x));
      circlePoints.add(Offset(center.dx + y, center.dy - x));
      circlePoints.add(Offset(center.dx - y, center.dy - x));
      decisionParameters.addAll([d, d, d, d, d, d, d, d]);
    }

    _plotCirclePoints(x, y);
    while (x < y) {
      if (d < 0) {
        d += 2.0 * x + 3.0;
      } else {
        d += 2.0 * (x - y) + 5.0;
        y--;
      }
      x++;
      _plotCirclePoints(x, y);
    }
  }
}

class CircleDisplayPage extends StatefulWidget {
  final Offset centerPoint;
  final double radius;
  final List<Offset> circlePoints;
  final List<double> decisionParameters;

  CircleDisplayPage(this.centerPoint, this.radius, this.circlePoints,
      this.decisionParameters);

  @override
  _CircleDisplayPageState createState() => _CircleDisplayPageState();
}

class _CircleDisplayPageState extends State<CircleDisplayPage> {
  double _scale = 1.0;

  void _zoomIn() {
    setState(() {
      _scale *= 1.1;
    });
  }

  void _zoomOut() {
    setState(() {
      _scale /= 1.1;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Offset, double>> _createData() {
      final data = widget.circlePoints.map((point) {
        return Offset(point.dx.toDouble(), point.dy.toDouble());
      }).toList();

      return [
        charts.Series<Offset, double>(
          id: 'Circle',
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
        title: Text('Circle Display'),
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
                    child: Stack(
                      children: [
                        chart,
                        CustomPaint(
                          painter: CirclePainter(
                            widget.centerPoint,
                            widget.radius,
                            widget.circlePoints,
                            widget.decisionParameters,
                          ),
                          size: Size(widget.radius * 2 * _scale,
                              widget.radius * 2 * _scale),
                        ),
                      ],
                    ),
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

class CirclePainter extends CustomPainter {
  final Offset centerPoint;
  final double radius;
  final List<Offset> circlePoints;
  final List<double> decisionParameters;

  CirclePainter(this.centerPoint, this.radius, this.circlePoints,
      this.decisionParameters);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Paint pointPaint = Paint()
      ..color = secondary
      ..strokeWidth = 2.0;

    canvas.drawCircle(centerPoint, radius, circlePaint);

    for (int i = 0; i < circlePoints.length; i++) {
      canvas.drawPoints(PointMode.points, [circlePoints[i]], pointPaint);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.centerPoint != centerPoint ||
        oldDelegate.radius != radius ||
        oldDelegate.circlePoints != circlePoints ||
        oldDelegate.decisionParameters != decisionParameters;
  }
}

class PointsDisplayPage extends StatelessWidget {
  final List<Offset> points;
  final List<double> decisionParameters;

  PointsDisplayPage(this.points, this.decisionParameters);

  @override
  Widget build(BuildContext context) {
    Map<double, List<Offset>> uniquePointsMap = {};

    // Group points by decision parameters
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      final decisionParameter = decisionParameters[i];
      if (!uniquePointsMap.containsKey(decisionParameter)) {
        uniquePointsMap[decisionParameter] = [];
      }
      uniquePointsMap[decisionParameter]!.add(point);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text('Unique Circle Points'),
      ),
      body: ListView(
        children: uniquePointsMap.entries.map((entry) {
          final decisionParameter = entry.key;
          final points = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  'Decision Parameter: ${decisionParameter.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: points.length,
                itemBuilder: (context, index) {
                  final point = points[index];
                  return ListTile(
                    title: Text(
                      'Point ${index + 1}: (${point.dx.toStringAsFixed(2)}, ${point.dy.toStringAsFixed(2)})',
                    ),
                  );
                },
              ),
              const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }
}
