import 'package:flutter/material.dart';
import 'flavors/environment.dart';
import 'flavors/app.dart';

void main() {
  Environment.init(
    appFlavor: AppFlavor.dev,
    baseUrl: 'https://api.dev.superapp.local',
    displayName: 'Reve (DEV)',
  );
  runApp(const MyApp());
}
