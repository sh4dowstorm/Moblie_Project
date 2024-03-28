import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_project/firebase_options.dart';

class FirebaseLoader {
  static final CollectionReference<Map<String, dynamic>> placeRef =
      FirebaseFirestore.instance.collection('place');

  static Stream<QuerySnapshot<Map<String, dynamic>>> loadData({
    required CollectionReference<Map<String, dynamic>> reference,
  }) {
    return reference.snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>? loadWithCondition({
    required CollectionReference<Map<String, dynamic>> reference,
    required String fieldName,
    required Object equalValue,
  }) {
    return placeRef.where(fieldName, isEqualTo: equalValue).snapshots();
  }

  static Column createWaitAnimation(
      {required BuildContext context,
      required AnimationController controller,
      String? error}) {
    return Column(
      children: [
        Lottie.asset(
          'assets/animations/error-animation.json',
          controller: controller,
          onLoaded: (composition) {
            controller.duration = composition.duration;
            controller.repeat();
          },
        ),
        Text(
          (error != null) ? error : '',
          style: Theme.of(context).textTheme.labelSmall,
        )
      ],
    );
  }
}

// void main(List<String> args) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   FirebaseLoader.placeRef
//       .doc('VQv8dUEHEp1XIIpsb7iM')
//       .collection('opinion')
//       .get()
//       .then((value) {
//     for (var element in value.docs) {
//       log('${element.id} : ${element.data().toString()}');
//     }
//   });
// }
