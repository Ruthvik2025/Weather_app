import "dart:convert";
import "dart:ui";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:weather_app/additonal_info_items.dart";
import "package:weather_app/hourly_weather_cards.dart";
import 'package:http/http.dart' as http;
import "package:weather_app/secrets.dart";

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'London';
      final res = await http.get(
        Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIkey',
        ),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'unexpected error';
      }
      return data;
      //data['list'][0]['main']['temp'];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          print(snapshot);
          print(snapshot.runtimeType);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];

          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //Main card

              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 10,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              '$currentTemp k',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Icon(
                              currentSky == 'Clouds' || currentSky == 'rain'
                                  ? Icons.cloud
                                  : Icons.cloudy_snowing,
                              size: 70,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              currentSky,
                              style: const TextStyle(fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),
              const Text(
                'Wether forecast',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 21),
              ),
              const SizedBox(
                height: 8,
              ),

              /* SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < 5; i++)
                      HourlyForecastCards(
                        time: data['list'][i + 1]['dt'].toString(),
                        icon: data['list'][i + 1]['weather'][0]['main'] ==
                                    'Clouds' ||
                                data['list'][i + 1]['weather'][0]['main'] ==
                                    'Rain'
                            ? Icons.cloud
                            : Icons.cloudy_snowing,
                        temperature:
                            data['list'][i + 1]['main']['temp'].toString(),
                      ), //card1
                    //card5
                  ],
                ),
              ), */
              //weather forecast cards

              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final hourlyForecast = data['list'][index + 1];
                    final time = DateTime.parse(hourlyForecast['dt_txt']);
                    return HourlyForecastCards(
                      time: DateFormat.j().format(time),
                      temperature: hourlyForecast['main']['temp'].toString(),
                      icon: hourlyForecast['weather'][0]['main'] == 'Clouds' ||
                              hourlyForecast['weather'][0]['main'] == 'Rain'
                          ? Icons.cloud
                          : Icons.cloudy_snowing,
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              //additional information
              const Text(
                'Additional information',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalinfoItems(
                    icon: Icons.water_drop_rounded,
                    value: 'Humidity',
                    label: currentHumidity.toString(),
                  ),
                  AdditionalinfoItems(
                    icon: Icons.air_sharp,
                    value: 'Wind speed',
                    label: currentWindSpeed.toString(),
                  ),
                  AdditionalinfoItems(
                    icon: Icons.beach_access,
                    value: 'Pressure',
                    label: currentPressure.toString(),
                  ),
                ],
              )
            ]),
          );
        },
      ),
    );
  }
}
