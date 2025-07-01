
import 'package:flutter/material.dart';
import 'package:my_app/pages/Listitems.dart';
import 'package:my_app/pages/addQuests.dart';
import 'package:my_app/pages/dashboard.dart';
  
void main() {
  runApp(MaterialApp(
    routes: {
      '/quest' :(context) => Listitems(),
      '/add' : (context) => AddQuests(),
      '/' : (context) => Dashboard(),
    },

  ));
}



