import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TranslateAnimation(),
    );
  }
}

class TranslateAnimation extends StatefulWidget {
  @override
  _TranslateAnimationState createState() => _TranslateAnimationState();
}

class _TranslateAnimationState extends State<TranslateAnimation> {
  double _translateX = 0.0;
  double _translateY = 0.0;
  bool _isTranslated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2D Translate Animation'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isTranslated = !_isTranslated;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  transform: Matrix4.translationValues(
                    _isTranslated ? _translateX : 0.0,
                    _isTranslated ? _translateY : 0.0,
                    0.0,
                  ),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        'Translate Me',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 200),
          // Sliders and Value Displays
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('X: '),
                  Slider(
                    value: _translateX,
                    min: -50,
                    max: 50,
                    divisions: 20,
                    onChanged: (newValue) {
                      setState(() {
                        _translateX = newValue;
                      });
                    },
                  ),
                  Text('$_translateX'),
                ],
              ),
              Column(
                children: [
                  Text('Y: '),
                  Slider(
                    value: _translateY,
                    min: -100,
                    max: 100,
                    divisions: 20,
                    onChanged: (newValue) {
                      setState(() {
                        _translateY = newValue;
                      });
                    },
                  ),
                  Text('$_translateY'),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          // Reset button
          ElevatedButton(
            onPressed: () {
              setState(() {
                _translateX = 0.0;
                _translateY = 0.0;
                _isTranslated = false;
              });
            },
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }
}
