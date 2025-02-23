import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shping_test/core/providers/theme_provider.dart';
import 'package:shping_test/core/routes/app_router.dart';
import 'package:shping_test/features/home/ui/screens/home_screen.dart';
import 'package:shping_test/core/theme/app_themes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'Photo Gallery',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
