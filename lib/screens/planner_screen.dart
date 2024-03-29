import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    return CustomScrollView(
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
    );
  }
}
