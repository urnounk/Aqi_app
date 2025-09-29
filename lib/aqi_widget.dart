import 'package:aqi_app/model/aqi.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AqiWidget extends StatefulWidget {
  const AqiWidget({super.key});

  @override
  State<AqiWidget> createState() => _AqiWidgetState();
}

class _AqiWidgetState extends State<AqiWidget> {
  Aqi? aqiData;

  @override
  void initState() {
    super.initState();
    fetchAqi();
  }

  void fetchAqi() async {
    try {
      var response = await http.get(
        Uri.parse(
          'https://api.waqi.info/feed/here/?token=c727945af351673b355c0c43905f127d3d2e649c',
        ),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        Aqi aqi = Aqi.fromJson(data);
        setState(() {
          aqiData = aqi;
        });
        print('City: ${aqi.cityname}, AQI: ${aqi.aqi}');
      } else {
        print('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

Color getAqiColor(int? aqi) {
  if ( aqi == null) return Colors.grey;
  if ( aqi <= 50) return const Color.fromARGB(255, 60, 152, 63); 
  if ( aqi <= 100) return const Color.fromARGB(255, 230, 214, 78); 
  if ( aqi <= 150) return const Color.fromARGB(255, 228, 138, 3);
  if ( aqi <= 200) return const Color.fromARGB(255, 216, 20, 6); 
  if ( aqi <= 300) return const Color.fromARGB(255, 108, 14, 125); 
   return const Color.fromARGB(255, 101, 4, 29);

}

String getAqiLevel(int? aqi) {
  if (aqi == null) return "Unknown";
  if (aqi <= 50) return "Good";
  if (aqi <= 100) return "Moderate";
  if (aqi <= 150) return "Unhealthy for Sensitive Groups";
  if (aqi <= 200) return "Unhealthy";
  if (aqi <= 300) return "Very Unhealthy";
   return "Hazardous";

}

  @override
  Widget build(BuildContext context) {
    final aqiColor = getAqiColor(aqiData?.aqi);

    return Scaffold(
      //backgroundColor: aqiColor,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'Air Quality Index (AQI) ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),  
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 44, 46, 159),
        elevation: 0,
      ),
      body: Center(
        child: aqiData == null
            ? const CircularProgressIndicator(color: Colors.white)
            : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: 
                        Text(
                          aqiData!.cityname,
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.access_time, color: Colors.black),
                      const SizedBox(width: 6),
                      Flexible(
                      child:  
                      Text(
                        '${aqiData!.time}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      )
                     
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.thermostat, color: Colors.black),
                      const SizedBox(width: 6),
                      Text(
                        '${aqiData!.temperature}°C',
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      decoration: BoxDecoration(
                      color: getAqiColor(aqiData!.aqi), 
                      borderRadius: BorderRadius.circular(12), 
                      //border: Border.all(color: Colors.white, width: 2), 
                    ),
                    child: Column(
                      mainAxisSize:  MainAxisSize.min,
                      children: [

                        
                         Text(
                    '${aqiData!.aqi}',
                    style: const TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                   const SizedBox(height: 3),
                  Text(
                      'µg/m³',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    )
                  ),
                   const SizedBox(height: 8),
                  Text(
                    getAqiLevel(aqiData!.aqi),
                    style: const TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                      ],

                    ),
                  ),
                  

                  const SizedBox(height: 30),

                  ElevatedButton.icon(
                    onPressed: fetchAqi,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
                  ],
                ),
              ),
            )
            
      ),
    );
  }
}
