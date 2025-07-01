import 'package:flutter/material.dart';
import 'package:my_app/pages/Quests.dart';
import 'package:my_app/pages/questCard.dart';

class Listitems extends StatefulWidget {
  const Listitems({super.key});

  @override
  State<Listitems> createState() => _ListitemsState();
}

class _ListitemsState extends State<Listitems> {

  List<Quests> quests = [

    Quests(title: '5km Jogging', description: 'Complete a 5km jogging', status: 'Completed', gold: 2000, exp: 500),
    Quests(title: 'Workout', description: 'Do a Push day workout', status: 'pending', gold: 1000, exp: 200),
    Quests(title: 'Learn New Things', description: 'Just explore and learn', status: 'Completed', gold: 500, exp: 100),
    Quests(title: 'Drink 8 Glasses of Water', description: 'Drink 8 Glasses of Water', status: 'Completed', gold: 2000, exp: 500),
    Quests(title: 'Meditate', description: 'Complete a meditation', status: 'Completed', gold: 200, exp: 300)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 27, 23),
        title: Text('Quests',
         style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.green),),
        iconTheme: IconThemeData(
          color: Colors.green,
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 28, 27, 23),
        child: Column(
          children: [
            // Title section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, left: 20),
              child: Text(
                'Your quests',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20,),
            // Quest list
            Expanded(
              child: ListView.builder(
                itemCount: quests.length,
                itemBuilder: (context, index) {
                  return ItemCard(quests: quests[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/add');
        }, 
        backgroundColor: Colors.green,
        child: Icon(Icons.add)),
    );
  }
}