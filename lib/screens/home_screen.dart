import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mobile_project/screens/place_detail_screen.dart';
import 'package:mobile_project/services/current_user.dart';
import 'package:mobile_project/services/firebase_loader.dart';
import 'package:mobile_project/widgets/place_display.dart';
import 'package:mobile_project/widgets/search_field.dart';
import 'package:mobile_project/widgets/place_category.dart';
import 'package:provider/provider.dart';

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
    Icon(LineIcons.umbrellaBeach),
    Color(0xFF83F8FF),
    'beach',
  ],
  [
    Icon(LineIcons.tree),
    Color(0xFF95D6A8),
    'forest',
  ],
  [
    Icon(LineIcons.mosque),
    Color(0xFFA6A7A7),
    'city',
  ],
  [
    Icon(Ionicons.restaurant_outline),
    Color(0xFFFBBC05),
    'resturent',
  ],
  [
    Icon(Ionicons.bed_outline),
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
  String _text = '';
  int _currentCategory = -1;

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
                _text = value ?? '';
              });
            },
          ),
        ),

        // test text
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
              List<QueryDocumentSnapshot<Map<String, dynamic>>> matchPlace = [];

              for (var place in placeData) {
                String placeName = place.data()['name'];
                if (placeName.contains(_text)) {
                  matchPlace.add(place);
                }
              }

              return SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
                itemCount: matchPlace.length,
                itemBuilder: (context, index) {
                  final currentPlace = matchPlace[index].data();

                  return Consumer<CurrentUser>(
                    builder: (context, value, child) => FutureBuilder(
                      future: FirebaseLoader.placeRef
                          .doc(placeData[index].id)
                          .collection('opinion')
                          .get()
                          .then((value) {
                        return currentPlace['score'] / value.docs.length;
                      }),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GestureDetector(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PlaceDetailScreen(
                                          placeId: placeData[index].id,
                                          user: value.inUse,
                                        ))),
                            child: PlaceDisplay(
                              image: currentPlace['image'],
                              located: currentPlace['located'],
                              place: currentPlace['name'],
                              score: snapshot.data ?? 0.0,
                            ),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          return Text(snapshot.error.toString());
                        }
                      },
                    ),
                  );
                },
              );
            } else if (placeSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const SliverToBoxAdapter(
                  child: CircularProgressIndicator());
            } else {
              // incase having error
              return SliverToBoxAdapter(
                child: SliverToBoxAdapter(
                    child: Text(placeSnapshot.error.toString())),
              );
            }
          },
        ),
      ],
    );
  }
}
