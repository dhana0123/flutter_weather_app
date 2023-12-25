import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import './hourly_forcast.dart';
import './additional_infoitem.dart';
import 'package:http/http.dart' as http;

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
    String cityName = "London";

    try {
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=d6ba33612f69b756eb4a4c8dc8acd6d1'));

      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'Unexpected Error occured';
      }
      return data;
    } catch (er) {
      throw er.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh_rounded),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          final data = snapshot.data!;
          final temp = data['list'][0]['main']['temp'];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //main card
                SizedBox(
                  width: double.infinity,
                  // height: 250,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                "$temp k",
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Icon(Icons.cloud, size: 64),
                              const SizedBox(height: 16),
                              const Text(
                                "Rain",
                                style: TextStyle(fontSize: 20),
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
                //weather forcast cards
                const Text(
                  "Weather Forcast",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      HourlyForcast(
                        time: '3:00',
                        icon: Icons.cloud,
                        temperature: '100',
                      ),
                      HourlyForcast(
                        time: '4:00',
                        icon: Icons.cloud,
                        temperature: '100',
                      ),
                      HourlyForcast(
                        time: '5:00',
                        icon: Icons.cloud,
                        temperature: '100',
                      ),
                      HourlyForcast(
                        time: '6:00',
                        icon: Icons.cloud,
                        temperature: '100',
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Additional Imformation",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MoreDetailItem(
                      icon: Icons.water_drop,
                      label: "Humidity",
                      value: "32",
                    ),
                    MoreDetailItem(
                      icon: Icons.air,
                      label: "wind",
                      value: "32",
                    ),
                    MoreDetailItem(
                      icon: Icons.beach_access,
                      label: "Pressure",
                      value: "32",
                    )
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
