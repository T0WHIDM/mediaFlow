import 'package:flutter/material.dart';
import 'package:mediaflow/screen/loading_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,

      title: 'mediaFlow',
      debugShowCheckedModeBanner: false,
      home: const LoadingScreen(),
    );
  }
}
