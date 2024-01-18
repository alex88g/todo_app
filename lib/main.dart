import 'package:flutter/material.dart';
import 'pages/todo_page.dart';
import 'util/create_material_color.dart'; // Importera util.dart-filen
import 'package:timezone/data/latest.dart' as tz;

void main() {
  tz.initializeTimeZones(); // Initialisera tidszoner
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TodoPage(),
      theme: ThemeData(
        primaryColor: createMaterialColor(const Color.fromRGBO(253, 7, 7, 1)),
        primarySwatch: createMaterialColor(const Color.fromRGBO(253, 7, 7, 1)),
      ),
    );
  }
}

// Lägg till MyHomePage klassen här om den behövs
