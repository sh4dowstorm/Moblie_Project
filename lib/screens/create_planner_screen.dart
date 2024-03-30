import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobile_project/screens/planner_screen.dart';
import 'package:mobile_project/screens/search_place_for_plan.dart';
import 'package:mobile_project/services/current_user.dart';
import 'package:mobile_project/services/firebase_loader.dart';
import 'package:mobile_project/widgets/date_picker.dart';
import 'package:mobile_project/widgets/place_plan_item.dart';
import 'package:mobile_project/models/user.dart' as user_app;
import 'package:provider/provider.dart';

class CreatePlanner extends StatefulWidget {
  const CreatePlanner({Key? key, required this.cuser}) : super(key: key);

  final CurrentUser cuser;

  @override
  State<CreatePlanner> createState() => _CreatePlannerState();
}

class _CreatePlannerState extends State<CreatePlanner> {
  final TextEditingController _planNameController = TextEditingController();
  final TextEditingController _datePickerController = TextEditingController();
  final List<Map<String, dynamic>> _places = [];
  /*
  [
    {'adfkoononwdskfj': Map<String, dynamic>}
  ]
  */
  ImageProvider _image = const AssetImage('assets/images/test-planner.jpg');
  String? _imagePath;

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
              GestureDetector(
                onTap: () async {
                  // take photo
                  ImagePicker imagePicker = ImagePicker();
                  XFile? image =
                      await imagePicker.pickImage(source: ImageSource.camera);

                  if (image != null) {
                    setState(() {
                      Image pic = Image.file(File(image.path));
                      _image = pic.image;
                      _imagePath = image.path;
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: _image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                ),
              ),

              Column(
                children: [
                  // text field
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    padding: const EdgeInsets.all(4),
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
                      controller: _planNameController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 20),
                        labelStyle: Theme.of(context).textTheme.labelSmall,
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
              IconButton(
                onPressed: () => _dialogSearch(context),
                icon: const Icon(
                  Ionicons.location_outline,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),

          // places plan
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            child: ReorderableListView.builder(
              itemBuilder: (context, index) {
                final iterator = _places[index].keys.toList()[0];
                return ReorderableDragStartListener(
                  key: Key(iterator),
                  index: index,
                  child: PlanPlace(
                    image: _places[index][iterator]['image'],
                    name: _places[index][iterator]['name'],
                    located: _places[index][iterator]['located'],
                    removeFunc: () {
                      setState(() {
                        _places.removeAt(index);
                      });
                    },
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
          ),

          // create trip button
          GestureDetector(
            onTap: () {
              // on tap action
              _uploadData(widget.cuser.inUse);
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.secondary,
              ),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
              child: Center(
                child: Text(
                  'Add Plan',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          )
        ],
      ),
    );
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
                _places.add({key: addedPlace});
              });
            }
          },
        );
      },
    );
  }

  Future<void> _uploadData(user_app.User cuser) async {
    // uploadImage
    // defind uniqe file name
    String uniqeNameFile = DateTime.now().millisecondsSinceEpoch.toString();

    Reference reference = FirebaseStorage.instance.ref();
    Reference refImageDir = reference.child('user-image');

    Reference refImage = refImageDir.child(uniqeNameFile);

    late String imageUrl;
    try {
      if (_imagePath != null) {
        await refImage.putFile(File(_imagePath!));
        imageUrl = await refImage.getDownloadURL();
      } else {
        imageUrl =
            'https://firebasestorage.googleapis.com/v0/b/mobile-project-trang.appspot.com/o/test-planner.jpg?alt=media&token=1fc2f4f6-9029-445c-9465-fc2b68204a99';
      }

      // add to firebase
      // data
      List<String> idPlaceList = [];
      for (var i in _places) {
        idPlaceList.add(i.keys.toList()[0]);
      }

      Map<String, dynamic> map = {
        'trip-name': _planNameController.text,
        'trip-image': imageUrl,
        'trip-date':
            Timestamp.fromDate(DateTime.parse(_datePickerController.text)),
        'trip-list': idPlaceList,
      };
      // root => planner -> owner -have many-> plans -> each plan
      String planId = FirebaseLoader.idRandomGenerator(20);
      FirebaseLoader.plannerRef
          .doc(cuser.uid)
          .collection('plans')
          .doc(planId)
          .set(map);
    } catch (error) {
      log(error.toString());
    }
  }
}
