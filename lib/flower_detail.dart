import 'package:flutter/material.dart';

import 'main.dart';

class FlowerDetailScreen extends StatelessWidget {
  final Flower flower;

  FlowerDetailScreen(this.flower);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(flower.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                flower.image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    flower.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    flower.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Toprak Sevgisi: ${flower.name}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Sıcaklık Tercihi: ${flower.temperaturePreference}',
                    style: TextStyle(fontWeight: FontWeight.bold),),
                  Text('Sulama Sıklığı: ${flower.wateringFrequency}',
                    style: TextStyle(fontWeight: FontWeight.bold),),
                  Text('Anavatanı: ${flower.origin}',
                    style: TextStyle(fontWeight: FontWeight.bold),),
                  Text('Latince Adı: ${flower.latinName}',
                    style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
