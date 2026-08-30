import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const KadalaasApp());
}

class KadalaasApp extends StatelessWidget {
  const KadalaasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kadalaas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        // Default English text uses Moderustic. Malayalam text widgets
        // explicitly override this back to the system font, since
        // Moderustic doesn't include Malayalam glyphs.
        textTheme: GoogleFonts.moderusticTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
