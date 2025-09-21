import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weatherapp/components/weatherItem.dart';
import 'package:weatherapp/ui/detail_page.dart';
import 'package:weatherapp/widgets/constants.dart';

class Homepage extends StatefulWidget {
  final List<dynamic> dailyForecast;
  const Homepage({super.key, this.dailyForecast = const []});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _cityController = TextEditingController();
  final constants _constants = constants();
  final String apiKey = '18cdc76af30c4616af1174326232503';

  String location = 'Chiniot';
  String weatherIcon = 'sunny.png';
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;
  String currentWeatherStatus = '';
  String date = '';
  List hourlyForecast = [];
  List dailyForecast = [];

  Future<void> fetchWeatherData(String city) async {
    final url =
        'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=3';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final weatherData = json.decode(response.body);
      final locationData = weatherData['location'];
      final current = weatherData['current'];
      final forecast = weatherData['forecast']['forecastday'];

      setState(() {
        location = locationData['name'];
        temperature = current['temp_c'].toInt();
        windSpeed = current['wind_kph'].toInt();
        humidity = current['humidity'].toInt();
        cloud = current['cloud'].toInt();
        currentWeatherStatus = current['condition']['text'];
        weatherIcon = currentWeatherStatus.replaceAll(' ', '').toLowerCase() + ".png";
        date = DateFormat('EEEE, MMMM d').format(DateTime.now());
        hourlyForecast = forecast[0]['hour'];
        dailyForecast = forecast;
      });
    }
  }

  Future<List<String>> fetchSuggestions(String query) async {
    final url =
        'https://api.weatherapi.com/v1/search.json?key=$apiKey&q=$query';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map<String>((e) => e['name'].toString()).toList();
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData(location);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: _constants.linearGradientBlue,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.grid_view_rounded,
                                  color: Colors.white),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    location,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.white,
                                        builder: (context) => Padding(
                                          padding: EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            top: 20,
                                            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: TextField(
                                                      controller: _cityController,
                                                      autofocus: true,
                                                      decoration: const InputDecoration(
                                                        hintText: "Search city...",
                                                        border: OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  GestureDetector(
                                                    onTap: () {
                                                      String city = _cityController.text.trim();
                                                      if (city.isNotEmpty) {
                                                        fetchWeatherData(city);
                                                        Navigator.pop(context);
                                                      } else {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(content: Text("Enter a city name")),
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(14),
                                                      decoration: BoxDecoration(
                                                        color: Colors.blueAccent,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(Icons.search, color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );

                                    },
                                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                                  ),

                                ],
                              ),
                              const CircleAvatar(
                                backgroundImage:
                                AssetImage('assets/profile.png'),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Image.asset(
                            'assets/$weatherIcon',
                            width: 100,
                            height: 100,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.wb_cloudy,
                                size: 80, color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$temperature',
                                style: TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..shader = _constants.shader,
                                ),
                              ),
                              Text(
                                '°',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..shader = _constants.shader,
                                ),
                              ),
                            ],
                          ),
                          Text(currentWeatherStatus,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 22)),
                          Text(date,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 16)),
                          const Divider(color: Colors.white70),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _weatherInfo(Icons.air, '$windSpeed km/h'),
                              _weatherInfo(Icons.water_drop, '$humidity%'),
                              _weatherInfo(Icons.cloud, '$cloud%'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: const Text("Today's Forecast",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      height: 130,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: hourlyForecast.length,
                        itemBuilder: (context, index) {
                          final hourData = hourlyForecast[index];
                          final time = hourData['time']
                              .toString()
                              .substring(11, 16);
                          final icon = hourData['condition']['text']
                              .toString()
                              .replaceAll(' ', '')
                              .toLowerCase() +
                              ".png";
                          final temp = hourData['temp_c'].round().toString();

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    dailyForecast: dailyForecast,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 70,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.blueAccent),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 4,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(time,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                  Image.asset(
                                    'assets/$icon',
                                    width: 28,
                                    height: 28,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.wb_sunny_outlined,
                                        size: 24),
                                  ),
                                  Text('$temp°',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _weatherInfo(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 6),
        Text(value, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
