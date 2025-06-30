import 'package:flutter/material.dart';
import 'package:my_app/pages/Quests.dart';


class ItemCard extends StatelessWidget {
  final Quests quests;
  const ItemCard({
    super.key,
    required this.quests});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      color: const Color.fromARGB(255, 53, 51, 51),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          ListTile(
            leading: Icon(Icons.task, color: Colors.green,),
            title: Text(
              quests.title,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              quests.description,
              style: TextStyle(color: Colors.white),
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: quests.status.toLowerCase() == 'completed' 
                    ? Colors.green 
                    : Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                quests.status,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 72.0, bottom: 8.0),
            child: Row(
              children: [
                Icon(Icons.attach_money, size: 18, color: Colors.amberAccent,),
                SizedBox(width: 4),
                Text(
                  quests.gold.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 16),
                Icon(Icons.show_chart, size: 18, color: Colors.red,),
                SizedBox(width: 4),
                Text(
                  quests.exp.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      
    );
  }
}