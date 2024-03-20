import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FirebaseLoader {
  static final CollectionReference<Map<String, dynamic>> placeRef =
      FirebaseFirestore.instance.collection('place');
  static final CollectionReference<Map<String, dynamic>> ratedRef =
      FirebaseFirestore.instance.collection('rated');

  static Stream<QuerySnapshot<Map<String, dynamic>>> loadData({
    required CollectionReference<Map<String, dynamic>> reference,
  }) {
    return reference.snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>?
      loadFoodWithNameCondition({required String name}) {
    return placeRef.where('name', isEqualTo: name).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      loadFoodWithCategoryCondition({
    required int categoryIndex,
  }) {
    return placeRef.where('category', isEqualTo: categoryIndex).snapshots();
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
