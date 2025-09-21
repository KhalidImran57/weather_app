import 'package:flutter/material.dart';

class WeatherItem extends StatelessWidget {
  final int value;
  final String unit;
  final String imageUrl;
  const WeatherItem(
      {Key? key,
        required this.value,
        required this.unit,
        required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(imageUrl, width: 30, height: 30,
            errorBuilder: (_,__,___) =>
            const Icon(Icons.info_outline, size: 30)),
        const SizedBox(height: 4),
        Text(
          '$value$unit',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
