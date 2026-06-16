import 'package:flutter/material.dart';
import 'tugas_pertemuan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kreatif Hub Icha',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          background: const Color(0xFFF9F6FA), // Background soft cerah seperti di gambar
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F6FA),
      ),
      home: const TugasPertemuan(),
    );
  }
}