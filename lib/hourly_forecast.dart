import 'package:flutter/material.dart';

class Hourlyforecast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;

  const Hourlyforecast({
    super.key,
    required this.icon,
    required this.temp,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Icon(
                switch(icon){
                  'Clouds'=> Icons.cloud,
                  'Rain'=> Icons.beach_access,
                  _=> Icons.sunny,
                },
                size: 32,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(temp,
                  style: const TextStyle(
                    fontSize: 16,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}