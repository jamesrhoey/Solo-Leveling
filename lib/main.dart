import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Profile()));
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questify'),
        backgroundColor: const Color.fromARGB(255, 45, 162, 22),
        shadowColor: const Color.fromARGB(255, 121, 3, 25),
        surfaceTintColor: Colors.black87,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'User Profile',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.account_circle, size: 100),
            Container(
              padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'James Rhoey P. De Castro',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'jamesrhoeydecastro7@gmail.com',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Company',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Batangas State University TNEU Balayan',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Contact Number',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '09777404043',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 170, 0, 0),
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [Icon(Icons.logout), Text('Logout')],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
