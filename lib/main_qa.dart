import 'package:flutter/material.dart';
import 'flavors/environment.dart';
import 'flavors/app.dart';

void main() {
  Environment.init(
    appFlavor: AppFlavor.qa,
    baseUrl: 'https://api.qa.superapp.local',
    displayName: 'Reve (QA)',
  );
  runApp(const MyApp());
}
