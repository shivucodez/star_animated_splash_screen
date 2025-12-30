import 'dart:math';

import 'package:flutter/material.dart';
import 'package:splashsctreen/auth/ExampleScreen.dart';
import 'package:splashsctreen/splash/StarPainter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController starController;
  late AnimationController expandController;

  late Animation<double> scaleAnim;
  bool startExpand = false;

  @override
  void initState() {
    super.initState();
    starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    scaleAnim = CurvedAnimation(
      parent: expandController,
      curve: Curves.easeInOutCubic,
    );

    Future.delayed(const Duration(seconds: 8), () {
      setState(() => startExpand = true);
      expandController.forward();
    });

    expandController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            pageBuilder: (_, __, ___) => const ExampleScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    starController.dispose();
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxRadius = sqrt(size.width * size.width + size.height * size.height);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [Color(0xFF1A0033), Color(0xFF000814), Color(0xFF000000)],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            CustomPaint(
              painter: StarPainter(animation: starController),
              child: const SizedBox.expand(),
            ),
            Center(
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Image.asset(
                    "asset/starlogo.png",
                    width: 155,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    "Star Splash",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            if (startExpand)
              AnimatedBuilder(
                animation: scaleAnim,
                builder: (context, _) {
                  return Center(
                    child: Transform.scale(
                      scale: scaleAnim.value * maxRadius / 60,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyanAccent.withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}


