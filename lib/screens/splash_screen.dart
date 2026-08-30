import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';

/// Launch screen: stacked Malayalam wordmark, then a fade into Home.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const _lines = ['കട', 'ലാ', 'സ്'];

  late final AnimationController _enter;
  late final AnimationController _exit;
  Timer? _holdTimer;

  @override
  void initState() {
    super.initState();

    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _exit = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );

    _enter.forward();

    _holdTimer = Timer(const Duration(milliseconds: 2100), () async {
      if (!mounted) return;
      await _exit.forward();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(_homeRoute());
    });
  }

  PageRouteBuilder<void> _homeRoute() {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 720),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const HomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fade = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(fade);

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _enter.dispose();
    _exit.dispose();
    super.dispose();
  }

  Animation<double> _lineProgress(int index) {
    final start = index * 0.16;
    final end = (start + 0.55).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: _enter,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wordmarkStyle = GoogleFonts.notoSansMalayalam(
      fontSize: 40,
      fontWeight: FontWeight.w700,
      color: Colors.black,
      height: 1.12,
      letterSpacing: 0.5,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: Tween<double>(begin: 1, end: 0).animate(
          CurvedAnimation(parent: _exit, curve: Curves.easeInCubic),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < _lines.length; i++)
                _SplashLine(
                  text: _lines[i],
                  style: wordmarkStyle,
                  animation: _lineProgress(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashLine extends StatelessWidget {
  const _SplashLine({
    required this.text,
    required this.style,
    required this.animation,
  });

  final String text;
  final TextStyle style;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = animation.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 18),
            child: Transform.scale(
              scale: 0.94 + (t * 0.06),
              child: child,
            ),
          ),
        );
      },
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }
}
