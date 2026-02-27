import 'package:flutter/material.dart';
import 'package:mediaflow/core/routing/router.dart';
import 'package:mediaflow/provider/download_provider.dart';
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
    return MaterialApp.router(
      theme: context.watch<ThemeProvider>().themeData,
      title: 'mediaFlow',
      debugShowCheckedModeBanner: false,
      routerConfig: appGlobalRouter,
    );
  }
}
