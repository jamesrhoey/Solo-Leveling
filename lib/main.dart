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
        ),
        body: Column(
          children: [
            Container(
              
              margin: EdgeInsets.all(10),
              child: Row(
                
                children: [
                  Text(
                    style: TextStyle(fontSize: 20),
                    
                    'Name:'),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      style: TextStyle(color: const Color.fromARGB(255, 255, 0, 0)),
                      'James Rhoey P. De Castro'),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              
              child: Row(
                children: [
                  Text(style: TextStyle(fontSize: 20),'Age:'),
                  Text(style: TextStyle(color: const Color.fromARGB(255, 255, 0, 0)),'21 years old'),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
              
              child: Row(
                children: [
                  Text(style: TextStyle(fontSize: 20),'Gender:'),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(style: TextStyle(color: const Color.fromARGB(255, 255, 0, 0)),'Male'),
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
