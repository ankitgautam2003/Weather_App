import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/extra_info.dart';
import 'package:weather_app/hourly_fore_cast.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secreats.dart';

class WeatherscreenHomePage extends StatefulWidget {
  const WeatherscreenHomePage({super.key});

  @override
  State<WeatherscreenHomePage> createState() => _WeatherscreenHomePageState();
}

class _WeatherscreenHomePageState extends State<WeatherscreenHomePage> {

  late Future <Map<String, dynamic>> weather;

  // bool isLoading = false;
  //double temp = 0;

  @override
  void initState() {
    super.initState();

    weather = getCurrentWeatherUpdates();
  }

  // @override
  // void initState() {
  //   super.initState();

  //   getCurrentWeatherUpdates();
  // }

  Future <Map<String, dynamic>> getCurrentWeatherUpdates () async {
    try {
      // setState(() {
      //   isLoading = true;
      // });
      String cityName = "Kanpur";
      final res = await http.get(
        Uri.parse("http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey"),
      );

      // if(res.statusCode == 200);

      final data = jsonDecode(res.body);

      if(data ["cod"] != "200") {
        throw "An Unexpected Error Occured";
      }

      return data;

      // print("hi");

      // print (data ["list"] [0] ["main"] ["temp"]);

      // setState(() {
      //   temp = (data ["list"] [0] ["main"] ["temp"]);
      //   isloading = false;
      // });
    }
    catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text (
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeatherUpdates();
              });
            },
            icon: const Icon(Icons.refresh)
          )

          // InkWell(
          //   onTap: () {
          //     print("Refresh");
          //   },
          // child: const Icon(Icons.refresh),
          // )


          // GestureDetector(
          //   onTap: () {
          //     print("Refresh");
          //   },
          // child: const Icon(Icons.refresh),
          // )
        ],
      ),

      body: 
        // temp == 0 
        // isloading
        // ? const CircularProgressIndicator() : 
        FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              return Center(child: (Text (snapshot.error.toString())));
            }

            final data = snapshot.data!;

            final currentWeatherData = data["list"] [0];


            final currentTemp = currentWeatherData ["main"] ["temp"];
            final currentSky = currentWeatherData ["weather"] [0] ["main"];
            final currentPressure = currentWeatherData ["main"] ["pressure"];
            final currentWindSpeed = currentWeatherData ["wind"] ["speed"];
            final currentHumidity = currentWeatherData ["main"] ["humidity"];


            double accurateTemp = currentTemp - 274.15;
            return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Card
              // const Placeholder(
              //   fallbackHeight: 250,
              // ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 30,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              "${accurateTemp!=0 ? accurateTemp.toStringAsFixed(2) : accurateTemp.toStringAsFixed(0)} °C",
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                        
                            const SizedBox(
                              height: 20,
                            ),
                        
                            Icon(currentSky == "Clouds" || currentSky == "Rain" ? Icons.cloud : Icons.sunny, size: 70,),
                        
                            const SizedBox(
                              height: 20,
                            ),
                        
                            Text(
                              "$currentSky",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            )
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
          
              // const Align(
              //   alignment: Alignment.centerLeft,
              //   // child: Text(
              //   //   "Weather Forcast",
              //   //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              //   // ),
              // ),
          
              const Text(
                  "Hourly Forcast",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
          
              const SizedBox(
                height: 15,
              ),
          
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [

              //       for(int i=0; i<5; i++)
              //         HourlyForeCast(
              //           time: data ["list"] [i+1] ["dt_txt"].toString(),
              //           icon: data ["list"] [i+1] ["weather"] [0] ["main"] == "Clouds" || data ["list"] [i+1] ["weather"] [0] ["main"] ==  "Rain" ? Icons.cloud : Icons.sunny,
              //           temp: "${(data ["list"] [i+1] ["main"] ["temp"] - 274.15).toStringAsFixed(2)} °C",
              //         ),
          
          
              // //       Card(
              // //         elevation: 20,
              // //         child: ClipRRect(
              // //           borderRadius: BorderRadius.circular(10),
              // //           child: BackdropFilter(
              // //             filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
              // //             child: Container(
              // //               width: 100,
              // //               decoration: BoxDecoration(
              // //                 borderRadius: BorderRadius.circular(10),
              // //               ),
              // //               padding: const EdgeInsets.all(8.0),
              // //               child: const Column(
              // //                 children: [
              // //                   Text(
              // //                     "00:00",
              // //                     style: TextStyle(
              // //                       fontWeight: FontWeight.bold,
              // //                       fontSize: 20
              // //                     ),
              // //                   ),
                            
              // //                   SizedBox(
              // //                     height: 10,
              // //                   ),
                            
              // //                   Icon(Icons.cloud, size: 34),
                            
              // //                   SizedBox(
              // //                     height: 10,
              // //                   ),
                            
              // //                   Text("100.50"),
              // //                 ],
              // //               ),
              // //             ),
              // //           ),
              // //         ),
              // //       ),
                 
              // //       Card(
              // //         elevation: 20,
              // //         child: ClipRRect(
              // //           borderRadius: BorderRadius.circular(10),
              // //           child: BackdropFilter(
              // //             filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
              // //             child: Container(
              // //               width: 100,
              // //               decoration: BoxDecoration(
              // //                 borderRadius: BorderRadius.circular(10),
              // //               ),
              // //               padding: const EdgeInsets.all(8.0),
              // //               child: const Column(
              // //                 children: [
              // //                   Text(
              // //                     "00:00",
              // //                     style: TextStyle(
              // //                       fontWeight: FontWeight.bold,
              // //                       fontSize: 20
              // //                     ),
              // //                   ),
                            
              // //                   SizedBox(
              // //                     height: 10,
              // //                   ),
                            
              // //                   Icon(Icons.cloud, size: 34),
                            
              // //                   SizedBox(
              // //                     height: 10,
              // //                   ),
                            
              // //                   Text("100.50"),
              // //                 ],
              // //               ),
              // //             ),
              // //           ),
              // //         ),
              // //       ),
                 
              // //       Card(
              // //         elevation: 20,
              // //         child: ClipRRect(
              // //           borderRadius: BorderRadius.circular(10),
              // //           child: BackdropFilter(
              // //             filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
              // //             child: Container(
              // //               width: 100,
              // //               decoration: BoxDecoration(
              // //                 borderRadius: BorderRadius.circular(10),
              // //               ),
              // //               padding: const EdgeInsets.all(8.0),
              // //               child: const Column(
              // //                 children: [
              // //                   Text(
              // //                     "00:00",
              // //                     style: TextStyle(
              // //                       fontWeight: FontWeight.bold,
              // //                       fontSize: 20
              // //                     ),
              // //                   ),
                            
              // //                   SizedBox(
              // //                     height: 10,
              // //                   ),
                            
              // //                   Icon(Icons.cloud, size: 34),
                            
              // //                   SizedBox(
              // //                     height: 10,
              // //                   ),
                            
              // //                   Text("100.50"),
              // //                 ],
              // //               ),
              // //             ),
              // //           ),
              // //         ),
              // //       ),
                 
              // //       Card(
              // //         elevation: 20,
              // //         child: ClipRRect(
              // //           borderRadius: BorderRadius.circular(10),
              // //           child: BackdropFilter(
              // //             filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
              // //             child: Container(
              // //               width: 100,
              // //               decoration: BoxDecoration(
              // //                 borderRadius: BorderRadius.circular(10),
              // //               ),
              // //               padding: const EdgeInsets.all(8.0),
              // //               child: const Column(
              // //                 children: [
              // //                   Text(
              // //                     "00:00",
              // //                     style: TextStyle(
              // //                       fontWeight: FontWeight.bold,
              // //                       fontSize: 20
              // //                     ),
              // //                   ),
                            
              // //                   SizedBox(
              // //                     height: 10,
              // //                   ),
                            
              // //                   Icon(Icons.cloud, size: 34),
                            
              // //                   SizedBox(
              // //                     height: 10,
              // //                   ),
                            
              // //                   Text("100.50"),
              // //                 ],
              // //               ),
              // //             ),
              // //           ),
              // //         ),
              // //       ),
                 
              // //       Card(
              // //         elevation: 20,
              // //         child: ClipRRect(
              // //           borderRadius: BorderRadius.circular(10),
              // //           child: BackdropFilter(
              // //             filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
              // //             child: Container(
              // //               width: 100,
              // //               decoration: BoxDecoration(
              // //                 borderRadius: BorderRadius.circular(10),
              // //               ),
              // //               padding: const EdgeInsets.all(8.0),
              // //               child: const Column(
              // //                 children: [
              // //                   Text(
              // //                     "00:00",
              // //                     style: TextStyle(
              // //                       fontWeight: FontWeight.bold,
              // //                       fontSize: 20
              // //                     ),
              // //                   ),
                            
              // //                   SizedBox(
              // //                     height: 10,
              // //                   ),
                            
              // //                   Icon(Icons.cloud, size: 34),
                            
              // //                   SizedBox(
              // //                     height: 10,
              // //                   ),
                            
              // //                   Text("100.50"),
              // //                 ],
              // //               ),
              // //             ),
              // //           ),
              // //         ),
              // //       ),
                 
              // //       Card(
              // //         elevation: 20,
              // //         child: ClipRRect(
              // //           borderRadius: BorderRadius.circular(10),
              // //           child: BackdropFilter(
              // //             filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
              // //             child: Container(
              // //               width: 100,
              // //               decoration: BoxDecoration(
              // //                 borderRadius: BorderRadius.circular(10),
              // //               ),
              // //               padding: const EdgeInsets.all(8.0),
              // //               child: const Column(
              // //                 children: [
              // //                   Text(
              // //                     "00:00",
              // //                     style: TextStyle(
              // //                       fontWeight: FontWeight.bold,
              // //                       fontSize: 20
              // //                     ),
              // //                   ),
                            
              // //                   SizedBox(
              // //                     height: 10,
              // //                   ),
                            
              // //                   Icon(Icons.cloud, size: 34),
                            
              // //                   SizedBox(
              // //                     height: 10,
              // //                   ),
                            
              // //                   Text("100.50"),
              // //                 ],
              // //               ),
              // //             ),
              // //           ),
              // //         ),
              // //       )
          
              
              //         // HourlyForeCast(
              //         //   time: "00:00",
              //         //   icon: Icons.cloud,
              //         //   temp: "40ºC",
              //         // ),
              //         // HourlyForeCast(
              //         //   time: "03:00",
              //         //   icon: Icons.wb_sunny,
              //         //   temp: "33ºC",
              //         // ),
              //         // HourlyForeCast(
              //         //   time: "06:00",
              //         //   icon:Icons.cloud,
              //         //   temp: "37ºC",
              //         // ),
              //         // HourlyForeCast(
              //         //   time: "09:00",
              //         //   icon:Icons.cloud,
              //         //   temp: "37ºC",
              //         // ),
              //         // HourlyForeCast(
              //         //   time: "12:00",
              //         //   icon: Icons.wb_sunny,
              //         //   temp: "33ºC",
              //         // ),
              //       ],
              //     ),
              //   ),
          
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 8,
                  itemBuilder:(context, index) {
                    final hourlyReport = data ["list"] [index + 1];
                    final time = DateTime.parse(hourlyReport["dt_txt"]);
                    final temperature = hourlyReport ["main"] ["temp"] - 274.15;
                    return HourlyForeCast(
                    time: DateFormat.j().format(time),
                    icon: data ["list"] [index+1] ["weather"] [0] ["main"] == "Clouds" || data ["list"] [index+1] ["weather"] [0] ["main"] ==  "Rain" ? Icons.cloud : Icons.sunny, 
                    temp: "${temperature.toStringAsFixed(2)} °C"
                    // temp: "${temperature!=0 ? temperature.toStringAsFixed(2) : temperature.toStringAsFixed(0)} °C" 
                  );
                  },
                ),
              ),


              // // Wheather Forecast Card
              // const Placeholder(
              //   fallbackHeight: 150,
              // ),
          
              const SizedBox(
                height: 20,
              ),
          
              // Extra Info
              // const Placeholder(
              //   fallbackHeight: 150,
              // ),
          
              const Text(
                  "Weather Forcast",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
          
              const SizedBox(
                height: 20,
              ),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
              
                  // Column(
                  //   children: [
                  //     Icon(Icons.water_drop, size: 34,),
                                    
                  //     SizedBox(
                  //     height: 8,
                  //     ),
                  
                  //     Text("Humidity"),
                                    
                  //     SizedBox(
                  //       height: 8,
                  //     ),
                  
                  //     Text(
                  //       "10.7",
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold
                  //       ),
                  //     )
                  //   ]
                  // ),
              
                  // Column(
                  //   children: [
                  //     Icon(Icons.air, size: 34,),
                                    
                  //     SizedBox(
                  //     height: 8,
                  //     ),
                  
                  //     Text("Air Speed"),
                                    
                  //     SizedBox(
                  //       height: 8,
                  //     ),
                  
                  //     Text(
                  //       "10.7",
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold
                  //       ),
                  //     )
                  //   ]
                  // ),
              
                  // Column(
                  //   children: [
                  //     Icon(Icons.umbrella, size: 34,),
                                    
                  //     SizedBox(
                  //     height: 8,
                  //     ),
                  
                  //     Text("Pressure"),
                                    
                  //     SizedBox(
                  //       height: 8,
                  //     ),
                  
                  //     Text(
                  //       "10.7",
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold
                  //       ),
                  //     )
                  //   ]
                  // ),
              
                  ExtraInfo(
                    icon: Icons.water_drop,
                    lable: "Humidity",
                    value: currentHumidity.toString()
                  ),
                  ExtraInfo(
                    icon: Icons.air,
                    lable: "Wind Speed",
                    value: currentWindSpeed.toString(),
                  ),
                  ExtraInfo(
                    icon: Icons.beach_access,
                    lable: "Pressure",
                    value: currentPressure.toString(),
                  ),
                ],
              )
          
            ],
          ),
                );
          },
        ),
    );
  }
}