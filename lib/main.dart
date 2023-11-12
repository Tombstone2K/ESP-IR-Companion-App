/// Main Dart Page
import 'package:flutter/material.dart';
import 'package:flutter_arduino_ir/rulesCustomClass.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';


import 'homePage.dart';

late Box rulesBox;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(RulesAdapter());
  Hive.registerAdapter(listOfRulesAdapter());
  rulesBox = await Hive.openBox<listOfRules>('rulesBox');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP Automation',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
          background: Colors.teal,
        ),
      ),
      home: const MyHomePage(title: 'ESP Automation'),
    );
  }
}

