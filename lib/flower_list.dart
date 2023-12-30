import 'package:flutter/material.dart';

import 'favorite_flowers.dart';
import 'flower_detail.dart';
import 'main.dart';

class FlowerListScreen extends StatefulWidget {
  final List<Flower> flowers;

  FlowerListScreen(this.flowers);

  @override
  _FlowerListScreenState createState() => _FlowerListScreenState();
}

class _FlowerListScreenState extends State<FlowerListScreen> {
  late List<Flower> filteredFlowers;

  @override
  void initState() {
    super.initState();
    filteredFlowers = widget.flowers;
  }

  void filterFlowers(String query) {
    setState(() {
      filteredFlowers = widget.flowers
          .where((flower) => flower.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void remindWatering(Flower flower) {
    bool isCustomTimeSelected = false;
    String selectedFrequency = 'Her Gün';
    double dialogHeight = 0.5;
    bool favoriteButtonToggled = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        TimeOfDay selectedTime = TimeOfDay.now();
        List<bool> selectedDays = List.generate(7, (index) => false);

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Anımsatma Seçenekleri'),
              content: Container(
                height: MediaQuery.of(context).size.height * dialogHeight,
                child: Column(
                  children: [
                    Row(
                      children: [
                        DropdownButton<String>(
                          value: selectedFrequency,
                          onChanged: (value) {
                            setState(() {
                              selectedFrequency = value!;
                            });
                          },
                          items: ['Her Gün', 'Hafta İçi Her Gün', 'Her Hafta', 'Her Ay'].map((String frequency) {
                            return DropdownMenuItem<String>(
                              value: frequency,
                              child: Text(frequency),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isCustomTimeSelected,
                          onChanged: (value) {
                            setState(() {
                              isCustomTimeSelected = value!;
                              dialogHeight = value ? 1.0 : 0.5;
                            });
                          },
                        ),
                        Text('Özel Zaman'),
                      ],
                    ),
                    if (isCustomTimeSelected)
                      Wrap(
                        spacing: 2.0,
                        children: buildDayCheckboxes(selectedDays, setState),
                      ),
                    Row(
                      children: [
                        Text('Saat Seçin: '),
                        ElevatedButton(
                          onPressed: () async {
                            selectedTime = (await showTimePicker(
                              context: context,
                              initialTime: selectedTime,
                            ))!;
                          },
                          child: Text(selectedTime.format(context)),
                        ),
                      ],
                    ),

                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            String daysMessage = isCustomTimeSelected
                                ? _getSelectedDays(selectedDays)
                                : 'Seçilen günler: ${selectedFrequency}';

                            String timeMessage = 'Saat: ${selectedTime.format(context)}';

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${flower.name} için anımsatma: $daysMessage $timeMessage',
                                ),
                              ),
                            );
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getSelectedDays(List<bool> selectedDays) {
    List<String> days = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];
    List<String> selectedDayNames = ['Her'];
    for (int i = 0; i < selectedDays.length; i++) {
      if (selectedDays[i]) {
        selectedDayNames.add(days[i]);
      }
    }
    return selectedDayNames.join(', ');
  }

  List<Widget> buildDayCheckboxes(List<bool> selectedDays, Function(void Function()) setStateCallback) {
    List<Widget> checkboxes = [];
    List<String> days = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];

    for (int i = 0; i < days.length; i++) {
      checkboxes.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Checkbox(
                value: selectedDays[i],
                onChanged: (value) {
                  setStateCallback(() {
                    selectedDays[i] = value!;
                  });
                },
              ),
              Text(days[i]),
            ],
          ),
        ),
      );
    }

    return checkboxes;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Çiçek Bakım Uygulaması'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0), // İstediğiniz değeri ayarlayabilirsiniz
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoriteFlowersScreen(filteredFlowers),
                  ),
                );
              },
              child: Text('Favoriler'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) => filterFlowers(query),
              decoration: InputDecoration(
                labelText: 'Çiçek Ara',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFlowers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(
                    filteredFlowers[index].image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(filteredFlowers[index].name),
                  subtitle: Text(filteredFlowers[index].description),
                  trailing: Wrap(
                    spacing: -16,
                    children: [
                      IconButton(
                        icon: Icon(
                          filteredFlowers[index].isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                        onPressed: () {
                          setState(() {
                            filteredFlowers[index].isFavorite = !filteredFlowers[index].isFavorite;
                          });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            remindWatering(filteredFlowers[index]);
                          },
                          child: Text('Sulama Anımsat'),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlowerDetailScreen(filteredFlowers[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}