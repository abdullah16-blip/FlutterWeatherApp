import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(WeatherApp());

class WeatherApp extends StatefulWidget {
  //const WeatherApp({Key? key}) : super(key: key);

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  int temperature = 0;
  String location = 'Khulna';
  int woeid = 1336135;

  String searchApiUrl =
      'http://api.openweathermap.org/data/2.5/weather?id=1336135&appid=eb6d75a05b00484ed9aba7e98becc56a';
  String locationApiUrl = 'http://api.openweathermap.org/data/2.5/weather?id=1336135&appid=eb6d75a05b00484ed9aba7e98becc56a';

  void fetchSearch(String input) async {
    var searchResult = await http.get(searchApiUrl + input);
    var result = json.decode(searchResult.body)[0];

    setState(() {
      location = result["name"];// in video, title is written
      woeid= result["woeid"];
      String weather = 'clear';
    });
  }

  void fetchLocation() async{
    var locationResult= await http.get(locationApiUrl + woeid.toString());
    var result = json.decode(locationResult.body);
    var consolidated_weather = result["consolidated_weather"];
    var data= consolidated_weather[0];

    setState(() {
      temperature = data["the_temp"].round();
      weather = data["weather_state_name"].replaceAll(' ','').toLowerCase();
    });
  }

  void onTextFieldSubmitted(String input){
    fetchSearch(input);
    fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/$weather.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Center(
                      child: Text(
                        temperature.toString() + '??C',
                        style: TextStyle(color: Colors.white, fontSize: 60.0),
                      ),
                    ),
                    Center(
                      child: Text(
                        location,
                        style: TextStyle(color: Colors.white, fontSize: 40.0),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: 300,
                      child: TextField(
                        onSubmitted: (String input){
                          onTextFieldSubmitted(input);
                        },
                        style: TextStyle(color: Colors.white, fontSize: 25),
                        decoration: InputDecoration(
                          hintText: 'Search a location...',
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 18.0),
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
