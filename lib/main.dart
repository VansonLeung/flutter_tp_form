import 'package:flutter/material.dart';
import 'package:tp_form_example/pages/SampleForm1Page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text('TPForm example', style: TextStyle(color: Color(0xff222222)),),
        ),
        body: const SampleForm1Page(),
      ),
    );
  }
}
