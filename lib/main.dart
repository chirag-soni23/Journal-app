import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:journal_app_in_flutter/screen/journal_screen.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const JournalScreen(),
    );
  }
}
