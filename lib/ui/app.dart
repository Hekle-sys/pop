import 'package:flutter/material.dart';
import 'package:pop/ui/pages/main_navigation.dart';
import 'package:pop/ui/pages/onboarding_page.dart';

class MyApp extends StatelessWidget {
  final bool hasCompletedOnboarding;

  const MyApp({
    super.key,
    this.hasCompletedOnboarding = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POP',
      theme: ThemeData(
        fontFamily: 'Inter',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: hasCompletedOnboarding
          ? const MainNavigationPage()
          : const OnboardingPage(),
      routes: {
        '/home': (context) => const MainNavigationPage(),
        '/onboarding': (context) => const OnboardingPage(),
      },
    );
  }
}

