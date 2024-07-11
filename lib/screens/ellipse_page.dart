import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

Color primary = Color(0xff3f51b5);
Color secondary = Color(0xfff5a623);
Color mainColor = Color(0xffeeeeee);

class DrawingEllipsePage extends StatefulWidget {
  @override
  _DrawingEllipsePageState createState() => _DrawingEllipsePageState();
}

class _DrawingEllipsePageState extends State<DrawingEllipsePage> {
  Offset? centerPoint;
  double? radiusX;
  double? radiusY;
  List<Offset> ellipsePoints = [];
  List<double> decisionParameters = [];

  TextEditingController centerXController = TextEditingController();
  TextEditingController centerYController = TextEditingController();
  TextEditingController radiusXController = TextEditingController();
  TextEditingController radiusYController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          'Ellipse Drawing Algorithm',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: centerXController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Center X'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: centerYController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Center Y'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: radiusXController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Radius X'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: radiusYController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Radius Y'),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                // Reset ellipse and points lists
                ellipsePoints.clear();
                decisionParameters.clear();

                centerPoint = Offset(
                  double.parse(centerXController.text),
                  double.parse(centerYController.text),
                );
                radiusX = double.parse(radiusXController.text);
                radiusY = double.parse(radiusYController.text);
                _calculateEllipsePoints(centerPoint!, radiusX!, radiusY!);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EllipseDisplayPage(
                        centerPoint!, radiusX!, radiusY!, ellipsePoints),
                  ),
                );
              });
            },
            child: Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: secondary),
              child: Center(
                child: Text(
                  'Draw Ellipse',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: secondary,
            ),
            onPressed: () {
              if (centerPoint != null &&
                  radiusX != null &&
                  radiusY != null &&
                  ellipsePoints.isNotEmpty &&
                  decisionParameters.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EllipsePointsPage(
                      ellipsePoints: ellipsePoints,
                      decisionParameters: decisionParameters,
                    ),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Please draw an ellipse first.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Text(
              'Show Points',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _calculateEllipsePoints(Offset center, double radiusX, double radiusY) {
    int x = 0, y = radiusY.round();
    double d1 = radiusY * radiusY -
        radiusX * radiusX * radiusY +
        0.25 * radiusX * radiusX;
    double dx = 2 * radiusY * radiusY * x;
    double dy = 2 * radiusX * radiusX * y;

    while (dx < dy) {
      _plotEllipsePoints(center, x, y, d1);
      if (d1 < 0) {
        x++;
        dx += 2 * radiusY * radiusY;
        d1 += dx + radiusY * radiusY;
      } else {
        x++;
        y--;
        dx += 2 * radiusY * radiusY;
        dy -= 2 * radiusX * radiusX;
        d1 += dx - dy + radiusY * radiusY;
      }
    }

    double d2 = radiusY * radiusY * (x + 0.5) * (x + 0.5) +
        radiusX * radiusX * (y - 1) * (y - 1) -
        radiusX * radiusX * radiusY * radiusY;

    while (y >= 0) {
      _plotEllipsePoints(center, x, y, d2);
      if (d2 > 0) {
        y--;
        dy -= 2 * radiusX * radiusX;
        d2 += radiusX * radiusX - dy;
      } else {
        y--;
        x++;
        dx += 2 * radiusY * radiusY;
        dy -= 2 * radiusX * radiusX;
        d2 += dx - dy + radiusX * radiusX;
      }
    }
  }

  void _plotEllipsePoints(
      Offset center, int x, int y, double decisionParameter) {
    ellipsePoints.add(Offset(center.dx + x, center.dy + y));
    ellipsePoints.add(Offset(center.dx - x, center.dy + y));
    ellipsePoints.add(Offset(center.dx + x, center.dy - y));
    ellipsePoints.add(Offset(center.dx - x, center.dy - y));

    decisionParameters.add(decisionParameter);
    decisionParameters.add(decisionParameter);
    decisionParameters.add(decisionParameter);
    decisionParameters.add(decisionParameter);
  }
}

class EllipseDisplayPage extends StatefulWidget {
  final Offset centerPoint;
  final double radiusX;
  final double radiusY;
  final List<Offset> ellipsePoints;

  EllipseDisplayPage(
      this.centerPoint, this.radiusX, this.radiusY, this.ellipsePoints);

  @override
  _EllipseDisplayPageState createState() => _EllipseDisplayPageState();
}

class _EllipseDisplayPageState extends State<EllipseDisplayPage> {
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
      final data = widget.ellipsePoints.map((point) {
        return charts.Series<Offset, double>(
          id: 'Ellipse',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (Offset point, _) => point.dx,
          measureFn: (Offset point, _) => point.dy,
          data: [point],
        );
      }).toList();

      return data;
    }

    var chart = charts.ScatterPlotChart(
      _createData(),
      animate: false,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Ellipse Display',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Center(
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
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _zoomIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondary,
                    ),
                    child: Text(
                      'Zoom In',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _zoomOut,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondary,
                    ),
                    child: Text(
                      'Zoom Out',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EllipsePainter extends CustomPainter {
  final Offset centerPoint;
  final double radiusX;
  final double radiusY;
  final List<Offset> ellipsePoints;

  EllipsePainter(
      this.centerPoint, this.radiusX, this.radiusY, this.ellipsePoints);

  @override
  void paint(Canvas canvas, Size size) {
    Paint ellipsePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Paint pointPaint = Paint()
      ..color = secondary
      ..strokeWidth = 5.0;

    Rect rect = Rect.fromCenter(
        center: centerPoint, width: radiusX * 2, height: radiusY * 2);
    canvas.drawOval(rect, ellipsePaint);

    for (int i = 0; i < ellipsePoints.length; i++) {
      canvas.drawPoints(PointMode.points, [ellipsePoints[i]], pointPaint);
    }
  }

  @override
  bool shouldRepaint(EllipsePainter oldDelegate) {
    return oldDelegate.centerPoint != centerPoint ||
        oldDelegate.radiusX != radiusX ||
        oldDelegate.radiusY != radiusY ||
        oldDelegate.ellipsePoints != ellipsePoints;
  }
}

class EllipsePointsPage extends StatelessWidget {
  final List<Offset> ellipsePoints;
  final List<double> decisionParameters;

  EllipsePointsPage({
    required this.ellipsePoints,
    required this.decisionParameters,
  });

  @override
  Widget build(BuildContext context) {
    Map<double, List<Offset>> uniquePointsMap = {};

    // Group points by decision parameters
    for (int i = 0; i < ellipsePoints.length; i++) {
      final point = ellipsePoints[i];
      final decisionParameter = decisionParameters[i];
      if (!uniquePointsMap.containsKey(decisionParameter)) {
        uniquePointsMap[decisionParameter] = [];
      }
      uniquePointsMap[decisionParameter]!.add(point);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          'Unique Ellipse Points',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: uniquePointsMap.entries.map((entry) {
          final decisionParameter = entry.key;
          final points = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  'Decision Parameter: ${decisionParameter.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
              Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }
}
