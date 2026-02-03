import 'package:flutter/material.dart';
import 'package:mediaflow/screen/loading_screen.dart';
import 'package:mediaflow/provider/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        return ThemeProvider();
      },
      builder: (context, child) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme
      theme: Provider.of<ThemeProvider>(context).themeData,
      title: 'mediaFlow',
      debugShowCheckedModeBanner: false,
      home: const LoadingScreen(),
    );
  }
}
