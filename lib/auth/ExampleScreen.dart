import 'package:flutter/material.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E18),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _shimmerCircle(84),
                  const SizedBox(height: 40),
                  _shimmerBox(height: 52),
                  const SizedBox(height: 18),
                  _shimmerBox(height: 52),
                  const SizedBox(height: 28),
                  _shimmerBox(height: 56, radius: 14),
                  const SizedBox(height: 22),
                  _shimmerBox(height: 16, width: 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _shimmerBox({
    double height = 20,
    double width = double.infinity,
    double radius = 10,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment(-1 + _controller.value * 2, 0),
              end: Alignment(1 + _controller.value * 2, 0),
              colors: const [
                Color(0xFF1C2030),
                Color(0xFF2A2F45),
                Color(0xFF1C2030),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _shimmerCircle(double size) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment(-1 + _controller.value * 2, 0),
              end: Alignment(1 + _controller.value * 2, 0),
              colors: const [
                Color(0xFF2EDBFF),
                Color(0xFF1C2030),
                Color(0xFFFF2EC4),
              ],
            ),
          ),
        );
      },
    );
  }
}