import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/addition_info.dart';
import 'package:weather_app/call.dart';
import 'hourly_forecast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weatherFuture;

  @override
  void initState(){
    super.initState();
    weatherFuture=getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async{
    try{
      String city="London";
      // const openAPIKey= '8090ea8174b24328e0010c2f37cf71dd';
      // print('API not called');
      final res = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$openAPIKey'),
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw "Request timed out. Please check your internet connection.";
      });
      // print("Response received");
      if (res.statusCode != 200) {
        throw "HTTP Error: ${res.statusCode}";
      }

      final data=jsonDecode(res.body);


      if(data['cod']!='200') {
        throw "An unexpected error occurred";
      }
      // setState(() {
      //   weatherData=data;
      //   isLoading=false;
      // });
      return data;
    }
    catch(e){
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            setState(() {
              weatherFuture=getCurrentWeather();
            });
          }, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder(
        future: weatherFuture,
        builder: (context, snapshot){
          // print(snapshot);
          print('Future builder called!');
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('Still waiting');
            return const Center(child: CircularProgressIndicator());
          }

          if(snapshot.hasError){
            print('Error detected');
            return Center(child: Text(snapshot.error.toString()));
          }

          print('Snapshot data:${snapshot.data}');
          final data = snapshot.data!;

          final currentData = data['list'][0];

          final currentTemp= currentData['main']['temp'];
          final currentIcon= currentData['weather'][0]['main'];
          final humidity= currentData['main']['humidity'];
          final windSpeed = currentData['wind']['speed'];
          final pressure = currentData['main']['pressure'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp K',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Icon(
                                switch(currentIcon){
                                  'Clouds'=> Icons.cloud,
                                  'Rain'=> Icons.beach_access,
                                  _=> Icons.sunny,
                                },
                                size: 60,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(currentIcon,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Weather Forecast',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     // children: [
                //     //   Hourlyforecast(
                //     //     time: DateTime.parse(data['list'][1]['dt_txt']),
                //     //     temp: data['list'][1]['main']['temp'].toString(),
                //     //     icon: data['list'][1]['weather'][0]['main'],
                //     //   ),
                //     //   Hourlyforecast(
                //     //     time: data['list'][2]['dt_txt'],
                //     //     temp: data['list'][2]['main']['temp'].toString(),
                //     //     icon: data['list'][2]['weather'][0]['main'],
                //     //   ),
                //     //   Hourlyforecast(
                //     //     time: data['list'][3]['dt_txt'],
                //     //     temp: data['list'][3]['main']['temp'].toString(),
                //     //     icon: data['list'][3]['weather'][0]['main'],
                //     //   ),
                //     //   Hourlyforecast(
                //     //     time: data['list'][4]['dt_txt'],
                //     //     temp: data['list'][4]['main']['temp'].toString(),
                //     //     icon: data['list'][4]['weather'][0]['main'],
                //     //   ),
                //     //   Hourlyforecast(
                //     //     time: data['list'][5]['dt_txt'],
                //     //     temp: data['list'][5]['main']['temp'].toString(),
                //     //     icon: data['list'][5]['weather'][0]['main'],
                //     //   ),
                //     // ],
                //   ),
                // ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index + 1];
                      final hourlySky =
                      data['list'][index + 1]['weather'][0]['main'];
                      final hourlyTemp =
                      hourlyForecast['main']['temp'].toString();
                      final time = DateTime.parse(hourlyForecast['dt_txt']);
                      return Hourlyforecast(
                        time: DateFormat.j().format(time),
                        temp  : hourlyTemp,
                        icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text('Additional Information',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AdditionInfo(
                      icon: Icons.opacity,
                      label: 'Humidity',
                      value: '$humidity',
                    ),
                    AdditionInfo(
                      icon: Icons.air,
                      label: 'Wind speed',
                      value: '$windSpeed',
                    ),
                    AdditionInfo(
                      icon: Icons.speed,
                      label: 'Pressure',
                      value: '$pressure',
                    ),
                  ],),
              ],
            ),
          );
        }),
    );
  }
}


