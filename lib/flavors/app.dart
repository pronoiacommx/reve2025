import 'package:flutter/material.dart';
import 'environment.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Environment.flavorColor),
      useMaterial3: true,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Environment.name,
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          title: Text('${Environment.name} (${Environment.flavorName})'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Base URL: ${Environment.apiBaseUrl}'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Environment.flavorColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Environment.flavorColor),
                ),
                child: Text(
                  'FLAVOR: ${Environment.flavorName}',
                  style: TextStyle(
                    color: Environment.flavorColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
