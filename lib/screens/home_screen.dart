import 'package:flutter/material.dart';
import 'package:mobile_project/models/location.dart';
import 'package:mobile_project/screens/place_detail_screen.dart';
import 'package:mobile_project/widgets/place_display.dart';
import 'package:mobile_project/widgets/search_field.dart';
import 'package:mobile_project/widgets/place_category.dart';

const Map<int, String> topicLabel = {
  -1: 'Top',
  0: 'Beaches',
  1: 'Forest',
  2: 'City',
  3: 'Resturent',
  4: 'Hotel',
};

List<Place> dummy = [
  Place(
    name: 'เกาะลิบง',
    category: PlaceCategory.beach,
    description: '',
    imagePath: 'login-page-image.jpg',
    located: 'ตำบลเกาะลิบง',
    rated: 4.8,
  ),
  Place(
    name: 'เกาะลิบง',
    category: PlaceCategory.beach,
    description: '',
    imagePath: 'login-page-image.jpg',
    located: 'ตำบลเกาะลิบง',
    rated: 4.8,
  ),
  Place(
    name: 'เกาะลิบง',
    category: PlaceCategory.beach,
    description: '',
    imagePath: 'login-page-image.jpg',
    located: 'ตำบลเกาะลิบง',
    rated: 4.8,
  ),
  Place(
    name: 'เกาะลิบง',
    category: PlaceCategory.beach,
    description: '',
    imagePath: 'login-page-image.jpg',
    located: 'ตำบลเกาะลิบง',
    rated: 4.8,
  ),
];
const List<List<dynamic>> categoryIcon = [
  [
    Icon(Icons.beach_access_rounded),
    Color(0xFF83F8FF),
    'beach',
  ],
  [
    Icon(Icons.forest_rounded),
    Color(0xFF95D6A8),
    'forest',
  ],
  [
    Icon(Icons.location_city_rounded),
    Color(0xFFA6A7A7),
    'city',
  ],
  [
    Icon(Icons.restaurant_menu_rounded),
    Color(0xFFFBBC05),
    'resturent',
  ],
  [
    Icon(Icons.hotel_rounded),
    Color(0xFFE1BEE7),
    'hotel',
  ],
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _text;
  int _currentCategory = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
              // Point of Interest
              SliverToBoxAdapter(
                child: Text(
                  "Point of Interest",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),

              // search bar
              SliverToBoxAdapter(
                child: SearchField(
                  hintText: 'Spots, Areas',
                  changeValue: (value) {
                    setState(() {
                      print(value);
                      _text = value;
                    });
                  },
                ),
              ),

              // test text
              SliverToBoxAdapter(child: Text(_text ?? "")),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),

              // category selection field
              SliverToBoxAdapter(
                child: PlaceCategoryButton(
                  currentIndex: _currentCategory,
                  updateValue: (updateIndex) {
                    setState(() {
                      _currentCategory =
                          (_currentCategory == updateIndex) ? -1 : updateIndex;
                    });
                  },
                  items: categoryIcon,
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),

              // label
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${topicLabel[_currentCategory]} Destination',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.filter_alt_rounded,
                      ),
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),

              // place display
              SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
                itemCount: dummy.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PlaceDetailScreen(
                        place: dummy[index],
                      )
                    )),
                    child: PlaceDisplay(place: dummy[index]),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
