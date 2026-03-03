import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Local chat app"), 
          backgroundColor: const Color.fromARGB(255, 165, 165, 165), 
        ),
        body: Center(
          child: ElevatedButton(
            child: Text("test"),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}