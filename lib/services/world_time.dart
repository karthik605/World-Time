import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location; // location name for the ui
  late String time; // the time in that location
  String flag; // url to an asset flag icon
  String url; // location url for api endpoint
  late bool isDaytime; // true or false if daytime or not

  WorldTime({
    required this.location,
    required this.flag,
    required this.url,
  });

  Future<void> getTime() async {
    try {
      Uri apiUrl = Uri.parse('http://worldtimeapi.org/api/timezone/$url');
      Response response = await get(apiUrl);
      Map data = jsonDecode(response.body);

      // get properties from data
      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3);

      // create datetime object
      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));

      // set the time property with the desired time format
      isDaytime = now.hour > 6 && now.hour < 19 ? true : false;
      time = DateFormat('hh:mm a').format(now); // 'a' for AM/PM
    } catch (e) {
      print('caught error: $e');
      time = 'could not get time data';
    }
  }
}
