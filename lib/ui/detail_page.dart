import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/weatherItem.dart';

class DetailPage extends StatelessWidget {
  final List<dynamic> dailyForecast;
  const DetailPage({Key? key, required this.dailyForecast})
      : super(key: key);

  Map<String, dynamic> getForecast(int idx) {
    final d = dailyForecast[idx];
    final day = d['day'];
    return {
      'date': DateFormat('EEEE, d MMM').format(DateTime.parse(d['date'])),
      'icon': day['condition']['text']
          .replaceAll(' ', '')
          .toLowerCase() +
          '.png',
      'maxTemp': day['maxtemp_c'].round(),
      'minTemp': day['mintemp_c'].round(),
      'wind': day['maxwind_kph'].round(),
      'humidity': day['avghumidity'].round(),
      'rain': day['daily_chance_of_rain'].round(),
      'condition': day['condition']['text'],
    };
  }

  @override
  Widget build(BuildContext context) {
    final today = getForecast(0);
    return Scaffold(
      backgroundColor: const Color(0xffeaf4fc),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text('Forecast Details',
            style: TextStyle(color: Colors.black87)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Today Summary Card
            Container(
              margin:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                    colors: [Color(0xff4da8da), Color(0xff0074d9)]),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/${today['icon']}',
                        width: 80,
                        height: 80,
                        errorBuilder: (_,__,___) => const Icon(Icons.cloud,
                            size: 80, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(today['condition'],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            const SizedBox(height: 4),
                            Text(today['date'],
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 16)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      WeatherItem(
                          value: today['wind'],
                          unit: 'km/h',
                          imageUrl: 'assets/windspeed.png'),
                      WeatherItem(
                          value: today['humidity'],
                          unit: '%',
                          imageUrl: 'assets/humidity.png'),
                      WeatherItem(
                          value: today['rain'],
                          unit: '%',
                          imageUrl: 'assets/rain.png'),
                    ],
                  ),
                ],
              ),
            ),

            // 3-day Forecast
            ...List.generate(dailyForecast.length, (i) {
              final f = getForecast(i);
              return Card(
                margin:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: Image.asset(
                    'assets/${f['icon']}',
                    width: 40,
                    height: 40,
                    errorBuilder: (_,__,___) =>
                    const Icon(Icons.cloud, size: 40),
                  ),
                  title: Text(f['date'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(f['condition']),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${f['maxTemp']}° / ${f['minTemp']}°'),
                      Text('${f['rain']}% rain'),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
