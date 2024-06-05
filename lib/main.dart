import 'package:flutter/material.dart';
import 'package:micang/pages/home_page.dart';
import 'package:micang/utilities/initializer.dart';

void main() async {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MICaNG',
      debugShowCheckedModeBanner: false,
      theme: theme(),
      darkTheme: theme(),
      home: const Initializer(
        child: HomePage(),
      ),
    );
  }

  ThemeData theme() {
    return ThemeData(
      splashColor: const Color(0xFFd0d0ce),
      hoverColor: const Color(0xFF797878).withOpacity(0.7),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF000000),
        brightness: Brightness.dark,
        primary: const Color(0xFF931D23),
        secondary: const Color(0xFF1E1F22),
        onPrimary: const Color(0xFFFFFFFF),
        onSecondary: const Color(0xFFFFFFFF),
        primaryContainer: const Color(0xFF1E1F22).withOpacity(0.8),
        onPrimaryContainer: const Color(0xFFFFFFFF),
        secondaryContainer: const Color(0xFF515151).withOpacity(0.7),
        onSecondaryContainer: const Color(0xFFFFFFFF),
        surface: const Color(0xFF0F2248),
      ),
      iconTheme: IconThemeData(
        color: const Color(0xFFFFFFFF),
        shadows: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.3),
            offset: const Offset(2, 3),
            blurRadius: 5,
            spreadRadius: 5,
          ),
        ],
      ),
      textTheme: const TextTheme(
        labelSmall: TextStyle(color: Colors.white),
        labelLarge: TextStyle(color: Colors.white),
        labelMedium: TextStyle(color: Colors.white),
        displayLarge: TextStyle(color: Colors.white),
        displayMedium: TextStyle(color: Colors.white),
        displaySmall: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        iconColor: Colors.white,
        textColor: Colors.white,
      ),
      expansionTileTheme: ExpansionTileThemeData(
        collapsedIconColor: Colors.white,
        collapsedTextColor: Colors.white,
        iconColor: Colors.white,
        textColor: Colors.white,
        childrenPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        collapsedBackgroundColor: const Color(0xFF1E1F22).withOpacity(0.8),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w200),
        hintStyle: TextStyle(fontWeight: FontWeight.w200),
        suffixIconColor: Colors.white,
      ),
      useMaterial3: true,
    );
  }
}
