import 'package:flutter/material.dart';
import 'package:last_uptate/screens/bresenham_algorithm.dart';
import 'package:last_uptate/screens/dda_page.dart';

Color primary = Color(0xff3f51b5);
Color secondary = Color(0xfff5a623);
Color tirnary = Color(0xff2b387c);

class Line extends StatelessWidget {
  const Line({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LineMainPage(),
    );
  }
}

class LineMainPage extends StatelessWidget {
  const LineMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tirnary,
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text(
          'Line Drawing Algorithms',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Category(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const DDAPage();
                  }));
                },
                text: 'DDA',
              ),
              const SizedBox(
                height: 30,
              ),
              Category(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const BresenhamPage();
                  }));
                },
                text: 'Bresenham ',
              ),
            ],
          ),
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
        width: 200,
        height: 100,
        color: primary,
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
