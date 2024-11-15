import 'package:again_inventory_project/page/home.dart';
import 'package:again_inventory_project/page/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool access = false; // set this to false to start at LOGIN ! ! !

  void _onLoginPressed(bool validAcc) {
    if (validAcc) {
      setState(() {
        access = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Inventory System",
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
        scaffoldBackgroundColor: Colors.grey.shade200,
      ),
      home: access ? const Home() : Login(onLoginClick: _onLoginPressed),
    );
  }
}
