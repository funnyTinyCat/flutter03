import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      //
      title: "Weather App",
      theme: ThemeData(
        //
        primarySwatch: Colors.blue,
      ),
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  //
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //
  final List<String> cities = ['Atlanta', 'London', 'Istanbul', 'Mumbai'];
  final String apiKey = "HERE_SHOULD_BE_TOKEN";
  Map<String, dynamic> weatherData = {};
  bool isLoading = true;

  @override
  void initState() {
    //
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    //
    setState(() {
      isLoading = true;
    });
    final Map<String, dynamic> data = {};
    for (String city in cities) {
      //
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=imperial'));
      if (response.statusCode == 200) {
        //
        data[city] = jsonDecode(response.body);
      }
    }
    setState(() {
      //
      weatherData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
        //
        appBar: AppBar(
          title: Text("Weather App"),
        ),
        body: isLoading
            ? Center(
                child: SpinKitFadingCircle(
                  color: Colors.blue,
                  size: 50.0,
                ),
              )
            : RefreshIndicator(
                onRefresh: fetchWeatherData,
                child: ListView.builder(
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    //
                    String city = cities[index];
                    var cityWeather = weatherData[city];
                    return ListTile(
                      title: Text(city),
                      subtitle: cityWeather != null
                          ? Text(
                              '${cityWeather['main']['temp']} F, ${cityWeather['weather'][0]['description']}')
                          : Text("No data available"),
                    );
                  },
                ),
              ));
  }
}
