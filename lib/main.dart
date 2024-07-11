import 'package:flutter/material.dart';
import 'package:last_uptate/screens/circle_page.dart';
import 'package:last_uptate/screens/ellipse_page.dart';
import 'package:last_uptate/screens/line_main_page.dart';
import 'package:last_uptate/screens/twoD_main_page.dart';

Color primary = Color(0xff3f51b5);
Color secondary = Color(0xfff5a623);
Color tirnary = Color(0xff2b387c);
void main() => runApp(GraphicsProject());

class GraphicsProject extends StatelessWidget {
  const GraphicsProject({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Graphics',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tirnary,
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          'Drawing Algorithms & 2D',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Category(
                  text: 'Line',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const LineMainPage();
                    }));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Category(
                  text: 'Circle',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DrawingPage();
                    }));
                  },
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Category(
                  text: 'Ellipse',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DrawingEllipsePage();
                    }));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Category(
                  text: '2D',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const TwoDTransformation();
                    }));
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class Category extends StatelessWidget {
  Category({super.key, required this.text, required this.onTap});
  final String? text;
  Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: primary),
        width: 150,
        height: 100,
        // color: primary,
        child: Center(
          child: Text(
            text!,
            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
