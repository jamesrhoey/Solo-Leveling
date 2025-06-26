import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Dashboard()));
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Questify',
          style: TextStyle(color: Color.fromARGB(255, 172, 245, 0)),
        ),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle)),
        ],
        shadowColor: const Color.fromARGB(255, 121, 3, 25),
        surfaceTintColor: Colors.black87,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Quest',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 172, 245, 0),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.bolt, color: Colors.orange),
                      title: Text('5km Jogging'),
                      subtitle: Text('Reward: 1000 Gold'),
                      trailing: ElevatedButton(
                        onPressed: () {},
                        child: Text('Accept'),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.forest, color: Colors.green),
                      title: Text('Walk outside'),
                      subtitle: Text('Reward: 500 Gold'),
                      trailing: ElevatedButton(
                        onPressed: () {},
                        child: Text('Accept'),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.favorite, color: Colors.purple),
                      title: Text('Learn new things'),
                      subtitle: Text('Reward: 2000 Gold'),
                      trailing: ElevatedButton(
                        onPressed: () {},
                        child: Text('Accept'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Column(
                    children: [Icon(Icons.task, size: 50), Text('Quests')],
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: Column(
                    children: [Icon(Icons.shop, size: 50), Text('Shop')],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Column(
                    children: [Icon(Icons.person, size: 50), Text('Character')],
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: Column(
                    children: [
                      Icon(Icons.settings, size: 50),
                      Text('Settings'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
