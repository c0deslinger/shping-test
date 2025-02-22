import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shping_test/app/global/providers/theme_provider.dart';
import 'package:shping_test/app/modules/home/screens/home_screen.dart';
import 'package:shping_test/styles/app_themes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Photo Gallery',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
        );
      },
    );
  }
}
