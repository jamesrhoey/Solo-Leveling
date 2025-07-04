import 'package:flutter/material.dart';

class Character extends StatefulWidget {
  const Character({super.key});

  @override
  State<Character> createState() => _CharacterState();
}

class _CharacterState extends State<Character> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 27, 23),
        title: Text(
          'Character',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 172, 245, 0),
          ),
        ),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 172, 245, 0)),
      ),
      body: Container(
        color: const Color.fromARGB(255, 28, 27, 23),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 100,
                color: Color.fromARGB(255, 172, 245, 0),
              ),
              SizedBox(height: 20),
              Text(
                'Character Stats',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'View your progress and achievements',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
