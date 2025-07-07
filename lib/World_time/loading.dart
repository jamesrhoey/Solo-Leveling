import 'package:flutter/material.dart';
import 'package:my_app/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void setupWorldTime() async {
    try {
      WorldTime instance = WorldTime(location: 'Manila', url: 'Asia/Manila', flag: '🇵🇭');
      
      // Add a minimum delay to show loading animation
      await Future.wait([
        instance.geTime(),
        Future.delayed(Duration(seconds: 2)), // Minimum 2 seconds loading time
      ]);
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home', arguments: {
          'location': instance.location, 
          'flag': instance.flag,
          'time': instance.time,
        });
      }
    } catch (e) {
      print('Error in setupWorldTime: $e');
      if (mounted) {
        // Show error dialog or navigate to home with error message
        Navigator.pushReplacementNamed(context, '/home', arguments: {
          'location': 'Error',
          'flag': '❌',
          'time': 'Could not load time',
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: SpinKitRotatingCircle(
          color: Colors.white,
          size: 80.0,
        ),
      ),
    );
  }
}