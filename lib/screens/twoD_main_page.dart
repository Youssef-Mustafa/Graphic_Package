import 'package:last_uptate/screens/reflection_page.dart';
import 'package:last_uptate/screens/scaling_page.dart';
import 'package:last_uptate/screens/shearing_page.dart';
import 'package:last_uptate/screens/rotation_page.dart';
import 'package:last_uptate/screens/translate_page.dart';
import 'package:flutter/material.dart';

Color primary = Color(0xff3f51b5);
Color secondary = Color(0xfff5a623);
Color tirnary = Color(0xff2b387c);

class TwoDTransformation extends StatelessWidget {
  const TwoDTransformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tirnary,
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          '2D Transformation',
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
                  text: 'Translation',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TranslateAnimation();
                    }));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Category(
                  text: 'Rotation',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RotationPage();
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
                  text: 'Scaling',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ScalingPage();
                    }));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Category(
                  text: 'Reflection',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ReflectionPage();
                    }));
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Category(
                  text: 'Shearing',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ShearingPage();
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
        width: 160,
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
