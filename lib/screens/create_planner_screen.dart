import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobile_project/services/firebase_loader.dart';
import 'package:mobile_project/widgets/date_picker.dart';
import 'package:mobile_project/widgets/place_plan_item.dart';

class CreatePlanner extends StatefulWidget {
  const CreatePlanner({Key? key}) : super(key: key);

  @override
  State<CreatePlanner> createState() => _CreatePlannerState();
}

class _CreatePlannerState extends State<CreatePlanner> {
  final TextEditingController _planNameController = TextEditingController();
  final TextEditingController _datePickerController = TextEditingController();
  late List<Map<String, dynamic>> _places;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final List<Map<String, dynamic>> places = [];
    final value = await FirebaseLoader.placeRef.get();
    for (var i in value.docs) {
      places.add(i.data());
    }
    setState(() {
      _places = places;
    });
  }

  @override
  Widget build(BuildContext context) {
    _datePickerController.text =
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
                    Ionicons.close_circle,
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
                        hintStyle: Theme.of(context).textTheme.labelSmall,
                        labelText: 'Your Plan',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // date picker
                  DatePickerCustom(
                    datePickerController: _datePickerController,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My trip',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const IconButton(
                onPressed: null,
                icon: Icon(
                  Ionicons.location_outline,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          _places != null
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: ReorderableListView.builder(
                    itemBuilder: (context, index) {
                      return ReorderableDragStartListener(
                        key: Key(_places[index]['image']),
                        index: index,
                        child: PlanPlace(
                          image: _places[index]['image'],
                          name: _places[index]['name'],
                          located: _places[index]['located'],
                        ),
                      );
                    },
                    itemCount: _places.length,
                    onReorder: (oldIndex, newIndex) {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      setState(() {
                        final place = _places.removeAt(oldIndex);
                        _places.insert(newIndex, place);
                      });
                    },
                  ),
                )
              : const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
