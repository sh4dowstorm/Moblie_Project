import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/services/firebase_loader.dart';
import 'package:mobile_project/widgets/date_picker.dart';
import 'package:mobile_project/widgets/place_plan_item.dart';

final TextEditingController planNameController = TextEditingController();
final TextEditingController datePickerController = TextEditingController();

class CreatePlanner extends StatefulWidget {
  const CreatePlanner({super.key});

  @override
  State<CreatePlanner> createState() => _CreatePlannerState();
}

class _CreatePlannerState extends State<CreatePlanner> {
  // demo
  Future<List<Map<String, dynamic>>> loadData() async {
    final List<Map<String, dynamic>> places = [];
    await FirebaseLoader.placeRef.get().then((value) {
      for (var i in value.docs) {
        places.add(i.data());
      }
    });

    return places;
  }

  @override
  Widget build(BuildContext context) {
    datePickerController.text =
        formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(10),
        ),
        color: Theme.of(context).colorScheme.background,
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'What are you planning?',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              // close button
              Transform.translate(
                offset: const Offset(7, -8),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // image
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage(
                      'assets/images/test-planner.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.27,
                height: MediaQuery.of(context).size.width * 0.27,
              ),

              Column(
                children: [
                  // text field
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.3),
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 20),
                        hintText: 'Your Plan',
                        hintStyle: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // date picker
                  DatePickerCustom(
                    datePickerController: datePickerController,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
              'My trip',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: loadData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                final places = snapshot.data;

                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: ReorderableListView.builder(
                    itemBuilder: (context, index) {
                      return ReorderableDragStartListener(
                        key: Key(places![index]['image']),
                        index: index,
                        child: PlanPlace(
                          image: places[index]['image'],
                          name: places[index]['name'],
                          located: places[index]['located'],
                        ),
                      );
                    },
                    itemCount: places?.length ?? 0,
                    onReorder: (oldIndex, newIndex) {
                      newIndex =
                          (oldIndex < newIndex) ? newIndex - 1 : newIndex;

                      setState(() {
                        final place = places!.removeAt(oldIndex);

                        places.add(place);
                      });
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
