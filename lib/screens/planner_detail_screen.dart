import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:date_format/date_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_project/widgets/date_picker.dart';
import 'package:mobile_project/services/firebase_loader.dart';
import 'package:mobile_project/widgets/place_plan_item.dart';
import 'package:mobile_project/screens/search_place_for_plan.dart';
import 'package:mobile_project/models/user.dart';

class PlannerDetailScreen extends StatefulWidget {
  const PlannerDetailScreen({super.key, required this.planId});

  final String planId;

  @override
  State<PlannerDetailScreen> createState() => _PlannerDetailScreenState();
}

class _PlannerDetailScreenState extends State<PlannerDetailScreen> {
  final TextEditingController _datePickerController = TextEditingController();
  final TextEditingController _plannerNameController = TextEditingController();
  bool _isEditingName = false;
  String _planName = '';
  DateTime _planDate = DateTime.now();
  List<String> _places = [];

  Future<String?> _getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch data immediately on screen load
  }

  Future<void> _fetchData() async {
    try {
      final uid = await _getCurrentUserId();
      if (uid != null) {
        final docRef = FirebaseFirestore.instance
            .collection('planner')
            .doc(uid)
            .collection('plans')
            .doc(widget.planId);
        final doc = await docRef.get();
        final data = doc.data();
        if (data != null) {
          setState(() {
            _plannerNameController.text = data['trip-name'];
            _planName = data['trip-name'];
            _planDate = data['trip-date'].toDate();
            _datePickerController.text =
                formatDate(_planDate, [dd, '/', mm, '/', yyyy]);
            _places = List<String>.from(data['trip-list']);
          });
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _dialogSearch(BuildContext context) async {
    final firebasePlaces = await FirebaseLoader.placeRef.get();
    final places = firebasePlaces.docs;

    return showDialog<void>(
      context: context,
      builder: (context) {
        return SearchPlace(
          places: places,
          addFunc: (Map<String, dynamic> addedPlace, String key) {
            if (!_places.contains(addedPlace)) {
              setState(() {
                _places.add(key);
              });
            }
          },
        );
      },
    );
  }

  void _toggleEditMode() {
    setState(() {
      _isEditingName = !_isEditingName;
    });
  }

  void _handleChangePlannerName() {
    setState(() {
      _planName = _plannerNameController.text;
      _saveToFirestore();
      _toggleEditMode();
    });
  }

  void _handleChangePlanDate(DateTime newDate) {
    setState(() {
      _planDate = newDate;
      _saveToFirestore();
    });
  }

  void _addPlace(String placeId) {
    setState(() {
      _places.add(placeId);
      _saveToFirestore();
    });
  }

  void _removePlace(String placeId) {
    setState(() {
      _places.remove(placeId);
      _saveToFirestore();
    });
  }

  Future<void> _saveToFirestore() async {
  log('Saving to Firestore');
  try {
    final uid = await _getCurrentUserId();
    if (uid != null) {
      final docRef = FirebaseFirestore.instance
          .collection('planner') 
          .doc(uid)
          .collection('plans')
          .doc(widget.planId);

      // Only update if necessary to reduce writes
      if (_isEditingName || _planName != _plannerNameController.text) {
        await docRef.update({
          'trip-name': _planName,
          'trip-date': _planDate, 
          'trip-list': _places,
        });
      }
    }
  } catch (e) {
    print('Error updating Firestore: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Ionicons.chevron_back_outline),
                  onPressed: () async {
                    await _saveToFirestore();
                    Navigator.pop(context);
                  }
                ),
                const SizedBox(width: 20),
                Text(
                  "Planner Detail",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Planner Name Section
            Row(children: [
              const SizedBox(width: 20),
              if (_isEditingName)
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextField(
                      controller: _plannerNameController,
                      style: Theme.of(context).textTheme.titleMedium,
                      decoration: InputDecoration(
                        hintText: 'Please enter a plan name',
                        hintStyle: Theme.of(context).textTheme.titleMedium,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    _plannerNameController.text,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.15),
              IconButton(
                onPressed: _toggleEditMode,
                icon: Icon(
                  _isEditingName ? Ionicons.checkmark_outline : Ionicons.pencil,
                ),
              ),
            ]),
            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      DatePickerCustom(
                        datePickerController: _datePickerController,
                        onDateChanged: (DateTime newDate) {
                          setState(() {
                            _datePickerController.text =
                                formatDate(newDate, [dd, '/', mm, '/', yyyy]);
                          });
                        },
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.23),
                      IconButton(
                        onPressed: () => _dialogSearch(context),
                        icon: const Icon(
                          Ionicons.location_outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseLoader.loadData(
                          reference: FirebaseLoader.placeRef),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else {
                          Map<String, Map<String, dynamic>> placeData = {};

                          for (var i in snapshot.data!.docs) {
                            placeData.putIfAbsent(i.id, () => i.data());
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _places.length,
                            itemBuilder: (context, index) {
                              return PlanPlace(
                                name: placeData[_places[index]]!['name'],
                                image: placeData[_places[index]]!['image'],
                                located: placeData[_places[index]]!['located'],
                                removeFunc: () => _removePlace(_places[index]),
                              );
                            },
                          );
                        }
                      }),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
