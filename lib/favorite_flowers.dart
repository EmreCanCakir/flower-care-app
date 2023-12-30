import 'package:flutter/material.dart';

import 'main.dart';

class FavoriteFlowersScreen extends StatelessWidget {
  final List<Flower> favoriteFlowers;

  FavoriteFlowersScreen(this.favoriteFlowers);

  @override
  Widget build(BuildContext context) {
    final List<Flower> favoriteList = favoriteFlowers.where((flower) => flower.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favori Çiçekler'),
      ),
      body: ListView.builder(
        itemCount: favoriteList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(
              favoriteList[index].image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(favoriteList[index].name),
            subtitle: Text(favoriteList[index].description),
          );
        },
      ),
    );
  }
}
