import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'favorite_flowers.dart';
import 'flower_list.dart';

void main() {
  runApp(MyApp());
}

class Flower {
  final String name;
  final String image;
  final String description;
  final String temperaturePreference;
  final String wateringFrequency;
  final String origin;
  final String latinName;
  bool isFavorite;

  Flower({
    required this.name,
    required this.image,
    required this.description,
    required this.temperaturePreference,
    required this.wateringFrequency,
    required this.origin,
    required this.latinName,
    this.isFavorite = false
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<List<Flower>>(
        future: loadFlowers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final List<Flower> flowers = snapshot.data!;
            return FlowerListScreen(flowers);
          }
        },
      ),
    );
  }
}

Future<List<Flower>> loadFlowers() async {
  String jsonString = await rootBundle.loadString('assets/flowers.json');
  List<Map<String, dynamic>> flowerData = List<Map<String, dynamic>>.from(json.decode(jsonString));

  return flowerData.map((data) => Flower(
    name: data['name'],
    image: data['image'],
    description: data['description'],
    temperaturePreference: data['temperaturePreference'],
    wateringFrequency: data['wateringFrequency'],
    origin: data['origin'],
    latinName: data['latinName'],
  )).toList();
}
