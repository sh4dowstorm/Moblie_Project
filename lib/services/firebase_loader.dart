import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_project/firebase_options.dart';

class FirebaseLoader {
  static final CollectionReference<Map<String, dynamic>> placeRef =
      FirebaseFirestore.instance.collection('place');

  static final CollectionReference<Map<String, dynamic>> plannerRef =
      FirebaseFirestore.instance.collection('planner');

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

  static Future<void> deleteData({
    required CollectionReference<Map<String, dynamic>> reference,
    required String deletedId,
  }) async {
    await reference.doc(deletedId).delete();
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

  static String idRandomGenerator(int idSize) {
    String upperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String lowerCase = upperCase.toLowerCase();
    String num = '0123456789';

    String combind = upperCase + lowerCase + num;

    String id = '';

    for (int i = 0; i < idSize; i++) {
      int rand = math.Random().nextInt(combind.length);
      id += combind[rand];
    }

    return id;
  }
}

// void main(List<String> args) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   log(FirebaseLoader.idRandomGenerator(28));
// }
