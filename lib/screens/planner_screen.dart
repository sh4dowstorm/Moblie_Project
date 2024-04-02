import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobile_project/screens/create_planner_screen.dart';
import 'package:mobile_project/screens/planner_detail_screen.dart';
import 'package:mobile_project/services/current_user.dart';
import 'package:mobile_project/services/firebase_loader.dart';
import 'package:mobile_project/widgets/plan_item.dart';
import 'package:mobile_project/widgets/search_field.dart';
import 'package:provider/provider.dart';
import 'package:mobile_project/models/user.dart' as app_user;

const String initImagePath =
    'https://firebasestorage.googleapis.com/v0/b/mobile-project-trang.appspot.com/o/test-planner.jpg?alt=media&token=1fc2f4f6-9029-445c-9465-fc2b68204a99';

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
                    List<QueryDocumentSnapshot<Map<String, dynamic>>>
                        matchPlan = [];

                    for (var plan in planners.data!.docs) {
                      String tripName = plan.data()['trip-name'];
                      if (tripName.contains(_text)) {
                        matchPlan.add(plan);
                      }
                    }

                    return SlidableAutoCloseBehavior(
                      closeWhenOpened: true,
                      child: SliverList.builder(
                        itemCount: matchPlan.length,
                        itemBuilder: (context, index) {
                          final rootData = matchPlan[index];
                          final planData = rootData.data();
                          final firebaseRef = FirebaseLoader.plannerRef
                              .doc(currentUser.inUse.uid)
                              .collection('plans');

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context, // Use the current context
                                MaterialPageRoute(
                                    builder: (context) => PlannerDetailScreen(planId: rootData.id)),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Slidable(
                                  key: Key(rootData.id),
                                  endActionPane: ActionPane(
                                    motion: const DrawerMotion(),
                                    dismissible: DismissiblePane(
                                      onDismissed: () async {
                                        // remove plan from firebase
                                        await FirebaseLoader.deleteData(
                                            reference: firebaseRef,
                                            deletedId: rootData.id);
                                        await FirebaseLoader.deleteImage(
                                          imageUrl: planData['trip-image'],
                                          exceptPath: initImagePath,
                                        );
                                      },
                                    ),
                                    children: [
                                      SlidableAction(
                                        backgroundColor: Colors.red,
                                        icon: Icons.delete_rounded,
                                        label: 'Delete',
                                        onPressed: (context) async {
                                          await FirebaseLoader.deleteData(
                                              reference: firebaseRef,
                                              deletedId: rootData.id);
                                          await FirebaseLoader.deleteImage(
                                            imageUrl: planData['trip-image'],
                                            exceptPath: initImagePath,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  child: PlanItem(
                                    planName: planData['trip-name'],
                                    image: planData['trip-image'],
                                    date: DateTime.fromMillisecondsSinceEpoch(
                                        planData['trip-date']
                                            .millisecondsSinceEpoch),
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
                _createPlannerBottomSheet(context, currentUser);
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

  Future _createPlannerBottomSheet(
      BuildContext context, CurrentUser cuser) async {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => CreatePlanner(cuser: cuser),
    );
  }
}
