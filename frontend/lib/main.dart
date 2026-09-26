import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'pages/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0B2D4D);
    const secondaryBlue = Color(0xFF163E5C);
    const beige = Color(0xFFE8D8B8);
    const lightBeige = Color(0xFFF5EEDC);
    const offWhite = Color(0xFFFAF8F2);
    const textDark = Color(0xFF1F2933);

    return MaterialApp(
      title: 'Seashells',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: offWhite,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          brightness: Brightness.light,
        ).copyWith(
          primary: primaryBlue,
          onPrimary: offWhite,
          secondary: secondaryBlue,
          onSecondary: offWhite,
          surface: offWhite,
          onSurface: textDark,
          error: secondaryBlue,
          onError: offWhite,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryBlue,
          foregroundColor: offWhite,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: primaryBlue,
          indicatorColor: beige,
          iconTheme: WidgetStatePropertyAll(IconThemeData(color: offWhite)),
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(color: offWhite, fontSize: 12),
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: primaryBlue,
        ),
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Roboto',
          bodyColor: textDark,
          displayColor: primaryBlue,
        ).copyWith(
          headlineLarge: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: primaryBlue,
          ),
          headlineMedium: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: primaryBlue,
          ),
          titleLarge: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: primaryBlue,
          ),
          titleMedium: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
          bodyLarge: const TextStyle(
            fontSize: 15,
            color: secondaryBlue,
          ),
          bodyMedium: const TextStyle(
            fontSize: 14,
            color: textDark,
          ),
          bodySmall: const TextStyle(
            fontSize: 12,
            color: secondaryBlue,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: offWhite,
            disabledBackgroundColor: beige,
            disabledForegroundColor: secondaryBlue,
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: offWhite,
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryBlue,
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: lightBeige,
          hintStyle: const TextStyle(color: secondaryBlue, fontSize: 14),
          prefixIconColor: primaryBlue,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: beige),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryBlue, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        cardTheme: const CardThemeData(color: offWhite),
        dialogTheme: const DialogThemeData(backgroundColor: offWhite),
      ),
      home: const OnboardingScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
