import 'package:flutter/material.dart';
import 'package:weather_app_practice/UI/widgets/weather_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

 final List<String> _allCities = [
  'Moscow,RU',
  'Baku,AZ',
  'Istanbul,TR',
  'Madrid,ES',
  'Bangkok,TH',
  'London,GB'
];

  List<String> _filteredCities = [];

  @override
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
    return Scaffold(
      body: _filteredCities.isEmpty
          ? ListView.builder(itemBuilder: (context, index) {})
          ////
          : ListView.builder(
              itemCount: _filteredCities.length,
              itemBuilder: (context, index) {
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
                        Navigator.pop(context, city);
                        
                      },
                      icon: const Icon(Icons.add, color: Colors.black),
                    ),
                  ),
                );
              },
            ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: SizedBox(
          width: 300,
          height: 40,
          child: SearchBar(
            controller: _controller,
            hintText: 'Search City',
            leading: const Icon(Icons.search),
            autoFocus: true,
          ),
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _controller.clear();
              },
              icon: Icon(Icons.clear),
            ),
        ],
      ),
    );
  }
}
