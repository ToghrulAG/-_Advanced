import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_practice/providers/cities_provider.dart';
import 'package:weather_app_practice/UI/widgets/weather_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<String> _allCities = [
    'Moscow,RU',
    'Baku,AZ',
    'Istanbul,TR',
    'Madrid,ES',
    'Bangkok,TH',
    'London,GB',
    'Paris,FR',
    'Berlin,DE',
    'Rome,IT',
    'Barcelona,ES',
    'Amsterdam,NL',
    'Vienna,AT',
    'Prague,CZ',
    'Warsaw,PL',
    'Zurich,CH',
    'New York,US',
    'Los Angeles,US',
    'Toronto,CA',
    'Vancouver,CA',
    'Dubai,AE',
    'Abu Dhabi,AE',
    'Doha,QA',
    'Tokyo,JP',
    'Osaka,JP',
    'Seoul,KR',
    'Singapore,SG',
    'Hong Kong,HK',
    'Kuala Lumpur,MY',
    'Sydney,AU',
    'Melbourne,AU',
    'Sao Paulo,BR',
    'Rio de Janeiro,BR',
  ];

  List<String> _filteredCities = [];

  void initState() {
    super.initState();
    _controller.addListener(_filterCities);
  }

  void _filterCities() {
    final query = _controller.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredCities = [];
      } else {
        _filteredCities = _allCities
            .where((city) => city.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final citiesProvider = context.watch<CitiesProvider>();
    final cities = citiesProvider.cities;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40),
          Text(
            'Pick Location',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 5.0),
          Text(
            'Lorem ipsum solor der color salam necesen',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 350,
            child: SearchBar(
              ///
              leading: Icon(Icons.search),
              hintText: 'Search City',
              controller: _controller,
            ),
          ),
          SizedBox(height: 40),

          Expanded(
            child: _filteredCities.isEmpty
                ? Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 255, 255, 255),
                          Color.fromARGB(255, 122, 205, 224),
                        ],
                      ),
                    ),
                    child: ReorderableListView.builder(
                      itemCount: cities.length,
                      onReorder: (oldIndex, newIndex) {
                        if (newIndex > oldIndex) newIndex -= 1;
                        citiesProvider.dragAndDrop(oldIndex, newIndex);
                      },
                      itemBuilder: (context, index) {
                        final city = cities[index];
                        return Container(
                          height: 100,
                          key: ValueKey('$city-$index'),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                              255,
                              57,
                              79,
                              102,
                            ), // вот твой фон
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: ListTile(
                            title: Text(
                              city,
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () => citiesProvider.removeCity(city),
                            ),
                            onTap: () => Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (context) =>
                                    WeatherDetailsScreen(cityName: city),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredCities.length,
                    itemBuilder: (contex, index) {
                      final city = _filteredCities[index];

                      return ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WeatherDetailsScreen(cityName: city),
                          ),
                        ),
                        title: Text(city),
                        trailing: Container(
                          width: 60,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.cyan.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            onPressed: () {
                              citiesProvider.addCity(city);
                              _controller.clear();
                              FocusScope.of(context).unfocus();
                            },
                            icon: Icon(Icons.add),
                          ),
                        ),
                      );
                    },
                  ),

            // cities.isEmpty
            //     ? const Center(child: Text('Pustoooooo'))
            //     :
          ),
        ],
      ),
    );
  }
}
