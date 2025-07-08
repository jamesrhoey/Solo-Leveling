import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';


class WorldTime {
  
  String location; //location name for the UI
  String time = ''; //time in that location
  String flag; //url to an asset flag icon
  String url; //this is the location url for the api endpoint
  bool isDaytime = true; //true or false if the time is day

  WorldTime({ required this.location, required this.flag,required this.url});


  Future<void> getTime() async{

    try {
      Response response = await get(
        Uri.parse('https://timeapi.io/api/time/current/zone?timeZone=$url'),
        headers: {'User-Agent': 'Mozilla/5.0'},
      );
   
      Map data = jsonDecode(response.body);
      print(data);

      //get properties from data
      String datetime = data['dateTime'];
      // No offset in response, so skip offset logic

      //create a datetime object
      DateTime now = DateTime.parse(datetime);

      // set isDaytime based on hour
      isDaytime = now.hour >= 6 && now.hour < 18;

      //set time property
      time = DateFormat.jm().format(now);
    } 
    catch (e) {
      print('caught error : $e');
      time = 'could not get time data';
      isDaytime = true;
    }
    
    //simulate network request
   
  }
}
