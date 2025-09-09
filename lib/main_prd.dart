import 'package:flutter/material.dart';
import 'flavors/environment.dart';
import 'flavors/app.dart';

void main() {
  Environment.init(
    appFlavor: AppFlavor.prd,
    baseUrl: 'https://api.superapp.com',
    displayName: 'Reve',
  );
  runApp(const MyApp());
}
