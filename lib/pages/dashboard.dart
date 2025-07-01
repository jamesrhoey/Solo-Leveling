import 'package:flutter/material.dart';


class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 28, 27, 23),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 28, 27, 23),
        title: Text(
          'Questify',
          style: TextStyle(color: Color.fromARGB(255, 172, 245, 0)),
        ),
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 172, 245, 0),
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
                    color: Color.fromARGB(255, 45, 45, 45),
                    child: ListTile(
                      leading: Icon(Icons.bolt, color: Colors.orange),
                      title: Text(
                        '5km Jogging',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Reward: 1000 Gold',
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 172, 245, 0),
                        ),
                        child: Text('Accept'),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    color: Color.fromARGB(255, 45, 45, 45),
                    child: ListTile(
                      leading: Icon(Icons.forest, color: Color.fromARGB(255, 172, 245, 0)),
                      title: Text(
                        'Walk outside',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Reward: 500 Gold',
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 172, 245, 0),
                        ),
                        child: Text('Accept'),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    color: Color.fromARGB(255, 45, 45, 45),
                    child: ListTile(
                      leading: Icon(Icons.favorite, color: Colors.purple),
                      title: Text(
                        'Learn new things',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Reward: 2000 Gold',
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 172, 245, 0),
                        ),
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
                Container(
                  width: 120,
                  height: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 45, 45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8,
                      shadowColor: Colors.black26,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/quest');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task, size: 40, color: Color.fromARGB(255, 172, 245, 0)),
                        SizedBox(height: 8),
                        Text(
                          'Quests',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  width: 120,
                  height: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 45, 45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8,
                      shadowColor: Colors.black26,
                    ),
                    onPressed: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shop, size: 40, color: Color.fromARGB(255, 172, 245, 0)),
                        SizedBox(height: 8),
                        Text(
                          'Shop',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 45, 45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8,
                      shadowColor: Colors.black26,
                    ),
                    onPressed: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: 40, color: Color.fromARGB(255, 172, 245, 0)),
                        SizedBox(height: 8),
                        Text(
                          'Character',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  width: 120,
                  height: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 45, 45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8,
                      shadowColor: Colors.black26,
                    ),
                    onPressed: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.settings, size: 40, color: Color.fromARGB(255, 172, 245, 0)),
                        SizedBox(height: 8),
                        Text(
                          'Settings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
