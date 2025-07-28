import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 27, 23),
        automaticallyImplyLeading: false, // Remove back button
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 172, 245, 0),
          ),
        ),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 172, 245, 0)),
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
                'Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 30),
            // Settings options
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Shop option
                    Card(
                      color: Color.fromARGB(255, 45, 45, 45),
                      child: ListTile(
                        leading: Icon(
                          Icons.shop,
                          color: Color.fromARGB(255, 172, 245, 0),
                          size: 30,
                        ),
                        title: Text(
                          'Shop',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          'Purchase items and upgrades',
                          style: TextStyle(color: Colors.white70),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white70,
                        ),
                        onTap: () async {
                          await Navigator.pushNamed(context, '/shop');
                          // Refresh data when returning from shop
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(height: 15),
                    // Character option
                    Card(
                      color: Color.fromARGB(255, 45, 45, 45),
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 172, 245, 0),
                          size: 30,
                        ),
                        title: Text(
                          'Character',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          'View character stats and progress',
                          style: TextStyle(color: Colors.white70),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white70,
                        ),
                        onTap: () async {
                          await Navigator.pushNamed(context, '/character');
                          // Refresh data when returning from character
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
