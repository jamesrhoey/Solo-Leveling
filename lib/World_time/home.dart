import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Map data = {};

  @override
  void initState() {
    super.initState();
    // Access the arguments when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        data = ModalRoute.of(context)?.settings.arguments as Map? ?? {};
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(data);

    return Scaffold(
      body: SafeArea (
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 120, 0,0),
        child: Column(
          children: [
            ElevatedButton.icon(onPressed: (){
              Navigator.pushNamed(context, '/location');
            },
            icon: Icon(Icons.edit_location),
             label: Text('Edit Location')),

            SizedBox(height: 20.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data['location'] ?? '',
                style: TextStyle(
                  fontSize: 28,
                  letterSpacing: 2,
                ),
                )
              ],
            ),
            SizedBox(height: 20,),
            Text(data['time'] ?? '',
            style: TextStyle(fontSize: 66),
            )

            // Display the data to verify it's working
            
          ],
        )
      ),
      )
    );
  }
}