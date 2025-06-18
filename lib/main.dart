import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Solo Leveling'),
          backgroundColor: const Color.fromARGB(255, 45, 162, 22),
          shadowColor: const Color.fromARGB(255, 121, 3, 25),
          surfaceTintColor: Colors.black87,
          actions: [BackButton()],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'HAHAHAHHA',
                style: TextStyle(
                  fontSize: 10,
                  backgroundColor: const Color.fromARGB(255, 193, 0, 0),
                ),
              ),
              Text(
                'HAHAHAHHA',
                style: TextStyle(
                  fontSize: 20,
                  backgroundColor: const Color.fromARGB(255, 251, 255, 0),
                ),
              ),
              Text(
                'HAHAHAHHA',
                style: TextStyle(
                  fontSize: 30,
                  backgroundColor: const Color.fromARGB(255, 19, 223, 1),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
