import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/screens/place_detail_screen.dart';
import 'package:mobile_project/services/firebase_loader.dart';
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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String? _text;
  int _currentCategory = -1;
  late final AnimationController _errorAnimationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // initialize animaiton controller
    _errorAnimationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _errorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
                log(value.toString());
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
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: (_currentCategory == -1)
              ? FirebaseLoader.loadData(reference: FirebaseLoader.placeRef)
              : FirebaseLoader.loadWithCondition(
                  reference: FirebaseLoader.placeRef,
                  fieldName: 'category',
                  equalValue: _currentCategory,
                ),
          builder: (context, placeSnapshot) {
            if (placeSnapshot.hasData) {
              final placeData = placeSnapshot.data!.docs;

              return SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
                itemCount: placeData.length,
                itemBuilder: (context, index) {
                  final currentPlace = placeData[index].data();

                  return FutureBuilder(
                    future: FirebaseLoader.placeRef
                        .doc(placeData[index].id)
                        .collection('opinion')
                        .get()
                        .then((value) {
                      return currentPlace['score'] / value.docs.length;
                    }),
                    builder: (context, snapshot) {
                      return GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PlaceDetailScreen(
                                      placeId: placeData[index].id,
                                    ))),
                        child: PlaceDisplay(
                          image: currentPlace['image'],
                          located: currentPlace['located'],
                          place: currentPlace['name'],
                          score: snapshot.data ?? 0.0,
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              // incase having error
              return SliverToBoxAdapter(
                child: FirebaseLoader.createWaitAnimation(
                    context: context,
                    controller: _errorAnimationController,
                    error: placeSnapshot.hasError
                        ? placeSnapshot.error.toString()
                        : null),
              );
            }
          },
        ),
      ],
    );
  }
}
