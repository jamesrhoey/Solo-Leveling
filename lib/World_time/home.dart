import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Map data = {};

  

  @override
  Widget build(BuildContext context) {

    if (data.isEmpty) {
      data = ModalRoute.of(context)?.settings.arguments as Map? ?? {};
    }
    print(data);

    //set background
    String bgImage = (data['isDaytime'] ?? false) ? 'day.png' : 'night.png';
    Color bgColor = (data['isDaytime'] ?? false) ? Colors.blue : Colors.indigo[700]!;
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea (
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/$bgImage'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 120, 0,0),
            child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                dynamic result = await Navigator.pushNamed(context, '/location');
                if (result != null) {
                  setState(() {
                    data = result as Map;
                  });
                }
              },
              icon: Icon(Icons.edit_location),
              label: Text('Edit Location'),
            ),

            SizedBox(height: 20.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                children: [
                  Text(data['location'] ?? '',
                    style: TextStyle(
                      fontSize: 28,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    data['url'] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              )
            ],
          ),  
            SizedBox(height: 20,),
            Text(data['time'] ?? '',
            style: TextStyle(
              fontSize: 66,
              color: Colors.white,
              ),
            ),
            
          ],
        ),
      ),
    ),
  ),
);

  }
}