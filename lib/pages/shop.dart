import 'package:flutter/material.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 27, 23),
        title: Text(
          'Shop',
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
                Icons.shop,
                size: 100,
                color: Color.fromARGB(255, 172, 245, 0),
              ),
              SizedBox(height: 20),
              Text(
                'Shop Coming Soon!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Purchase items and upgrades here',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
