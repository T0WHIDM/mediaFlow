import 'package:flutter/material.dart';
import 'package:mediaflow/provider/download_provider.dart';
import 'package:mediaflow/screen/loading_screen.dart';
import 'package:mediaflow/provider/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        ChangeNotifierProvider(create: (_) => DownloadProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme
      theme: context.watch<ThemeProvider>().themeData,
      title: 'mediaFlow',
      debugShowCheckedModeBanner: false,
      home: const LoadingScreen(),
    );
  }
}
