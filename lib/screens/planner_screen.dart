import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobile_project/screens/create_planner_screen.dart';
import 'package:mobile_project/widgets/date_picker.dart';
import 'package:mobile_project/widgets/place_plan_item.dart';
import 'package:mobile_project/widgets/plan_item.dart';
import 'package:mobile_project/widgets/search_field.dart';

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
    return Stack(
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
            SlidableAutoCloseBehavior(
              closeWhenOpened: true,
              child: SliverList.builder(
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Slidable(
                          key: Key(plans[index]['name']),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            dismissible: DismissiblePane(
                              onDismissed: () {
                                setState(() {
                                  plans.removeAt(index);
                                });
                              },
                            ),
                            children: [
                              SlidableAction(
                                backgroundColor: Colors.red,
                                icon: Icons.delete_rounded,
                                label: 'Delete',
                                onPressed: (context) {
                                  setState(() {
                                    plans.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                          child: PlanItem(
                            planName: plans[index]['name'],
                            image: plans[index]['image'],
                            date: plans[index]['date'],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
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
                Icons.create,
                color: Theme.of(context).colorScheme.primary,
                size: 30,
              ),
            ),
          ),
        )
      ],
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
