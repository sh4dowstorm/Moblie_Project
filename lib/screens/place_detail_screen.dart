import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_project/screens/opinion_screen.dart';
import 'package:mobile_project/services/firebase_loader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_project/models/user.dart' as app_user;

class PlaceDetailScreen extends StatefulWidget {
  const PlaceDetailScreen({
    super.key,
    required this.placeId,
    required this.user,
  });

  final String placeId;
  final app_user.User user;

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen>
    with TickerProviderStateMixin {
  late final AnimationController _errorAnimationController;

  Future<void> _openUrl(String link) async {
    Uri uri = Uri.parse(link);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.inAppWebView,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // animation
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
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future:
              FirebaseLoader.placeRef.doc(widget.placeId).get().then((value) {
            return value.data()!;
          }),
          builder: (contex, snapshort) {
            if (snapshort.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshort.hasError) {
              return Text('Error: ${snapshort.error}');
            } else {
              Map<String, dynamic> place = snapshort.data!;

              LatLng onmap = LatLng(double.parse(place['latitude']),
                  double.parse(place['longtitude']));
              String detail = place['description'] as String;
              detail = detail.replaceAll(r'\t', '\t').replaceAll(r'\n', '\n');

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.40,
                          width: MediaQuery.of(context).size.width,
                          child: GoogleMap(
                            mapType: MapType.normal,
                            compassEnabled: true,
                            markers: {
                              Marker(
                                markerId: MarkerId(place['name']),
                                position: onmap,
                                onTap: () async {
                                  String link =
                                      'https://google.com/maps?q=${place['name']}';
                                  log(link);

                                  await _openUrl(link);
                                },
                              ),
                            },
                            initialCameraPosition: CameraPosition(
                              zoom: 14,
                              target: onmap,
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(
                              0, MediaQuery.of(context).size.height * 0.385),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              color: Theme.of(context).colorScheme.background,
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 6,
                                  ),

                                  // located
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 16,
                                      ),
                                      Text(
                                        place['located'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),

                                  // name
                                  Text(
                                    place['name'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),

                                  // rated
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        size: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                      ),
                                      FutureBuilder<int>(
                                        future: FirebaseLoader.placeRef
                                            .doc(widget.placeId)
                                            .collection('opinion')
                                            .get()
                                            .then((value) => value.docs.length),
                                        builder: (context, rated) {
                                          if (rated.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (rated.hasError) {
                                            return Text(rated.error.toString());
                                          } else {
                                            int totalScore =
                                                place['score'] as int;

                                            String text = rated.hasData
                                                ? '${(totalScore / rated.data!).toStringAsFixed(1)} (${rated.data} ratings)'
                                                : rated.error.toString();
                                            return Text(
                                              text,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondary,
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),

                              // go to rated page
                              IconButton(
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => OpinionScreen(
                                            placeId: widget.placeId,
                                            user: widget.user,
                                          )),
                                ),
                                icon: const Icon(
                                    Icons.keyboard_arrow_right_rounded),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          // line
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 1,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onBackground,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 20,
                    ),
                  ),

                  // detail
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Text(
                        detail,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
