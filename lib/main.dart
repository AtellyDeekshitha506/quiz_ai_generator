import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_ai/providers/quiz_provider.dart';
import 'package:quiz_ai/theme/themes.dart';
import 'screens/splash_screen.dart';
import 'providers/app_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, _) {
        return MaterialApp(
          title: 'AI Quiz Generator',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appProvider.themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
