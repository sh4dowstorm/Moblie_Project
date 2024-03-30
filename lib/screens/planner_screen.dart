import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobile_project/screens/create_planner_screen.dart';
import 'package:mobile_project/services/current_user.dart';
import 'package:mobile_project/services/firebase_loader.dart';
import 'package:mobile_project/widgets/plan_item.dart';
import 'package:mobile_project/widgets/search_field.dart';
import 'package:provider/provider.dart';
import 'package:mobile_project/models/user.dart' as app_user;

final List<Map<String, dynamic>> plans = [
  {
    'name': 'Sud ton kon yang ter1',
    'date': DateTime(2024, 4, 5, 8, 0),
    'image': 'test-planner.jpg',
  },
  {
    'name': 'Sud ton kon yang ter2',
    'date': DateTime(2024, 4, 5, 8, 0),
    'image': 'test-planner.jpg',
  },
  {
    'name': 'Sud ton kon yang ter3',
    'date': DateTime(2024, 4, 5, 8, 0),
    'image': 'test-planner.jpg',
  },
  {
    'name': 'Sud ton kon yang ter4',
    'date': DateTime(2024, 4, 5, 8, 0),
    'image': 'test-planner.jpg',
  },
  {
    'name': 'Sud ton kon yang ter5',
    'date': DateTime(2024, 4, 5, 8, 0),
    'image': 'test-planner.jpg',
  },
];

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentUser>(
      builder: (context, currentUser, child) => Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),

              // My Plan
              SliverToBoxAdapter(
                child: Text(
                  "My Plan",
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

              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),

              // plan widget
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: getPlanners(currentUser.inUse),
                builder: (context, planners) {
                  if (planners.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: CircularProgressIndicator(),
                    );
                  } else if (planners.hasError) {
                    return SliverToBoxAdapter(
                      child: Text(
                        planners.error.toString(),
                      ),
                    );
                  } else {
                    return SlidableAutoCloseBehavior(
                      closeWhenOpened: true,
                      child: SliverList.builder(
                        itemCount: planners.data!.docs.length,
                        itemBuilder: (context, index) {
                          final rootData = planners.data!.docs[index];
                          final planData = rootData.data();
                          final firebaseRef = FirebaseLoader.plannerRef
                              .doc(currentUser.inUse.uid)
                              .collection('plans');

                          return GestureDetector(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Slidable(
                                  key: Key(rootData.id),
                                  endActionPane: ActionPane(
                                    motion: const DrawerMotion(),
                                    dismissible: DismissiblePane(
                                      onDismissed: () {
                                        // remove plan from firebase
                                        setState(() async {
                                          await FirebaseLoader.deleteData(
                                              reference: firebaseRef,
                                              deletedId: rootData.id);
                                        });
                                      },
                                    ),
                                    children: [
                                      SlidableAction(
                                        backgroundColor: Colors.red,
                                        icon: Icons.delete_rounded,
                                        label: 'Delete',
                                        onPressed: (context) {
                                          setState(() async {
                                            // remove plan from firebase
                                            await FirebaseLoader.deleteData(
                                                reference: firebaseRef,
                                                deletedId: rootData.id);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  child: PlanItem(
                                    planName: planData['trip-name'],
                                    image: planData['trip-image'],
                                    date: DateTime.fromMillisecondsSinceEpoch(planData['trip-date'].millisecondsSinceEpoch),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),

              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
            ],
          ),

          // floating action button
          Transform.translate(
            offset: Offset(MediaQuery.of(context).size.width * 0.78,
                MediaQuery.of(context).size.height * 0.78),
            child: GestureDetector(
              onTap: () {
                _createPlannerBottomSheet(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).colorScheme.onPrimary,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.6),
                      blurRadius: 3,
                    ),
                  ],
                ),
                height: 60,
                width: 60,
                child: Icon(
                  Ionicons.pencil_sharp,
                  color: Theme.of(context).colorScheme.primary,
                  size: 35,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPlanners(app_user.User cuser) {
    return FirebaseLoader.loadData(
      reference: FirebaseLoader.plannerRef.doc(cuser.uid).collection('plans'),
    );
  }

  Future _createPlannerBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => const CreatePlanner(),
    );
  }
}
