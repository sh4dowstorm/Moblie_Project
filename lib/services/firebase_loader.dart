import 'dart:async';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseLoader {
  static final CollectionReference<Map<String, dynamic>> placeRef =
      FirebaseFirestore.instance.collection('place');

  static final CollectionReference<Map<String, dynamic>> plannerRef =
      FirebaseFirestore.instance.collection('planner');

  static final CollectionReference<Map<String, dynamic>> userRef =
      FirebaseFirestore.instance.collection('users');

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

  static Future<void> deleteImage({
    required String imageUrl,
    String? exceptPath,
  }) async {
    if (exceptPath == imageUrl) return;
    Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
    await imageRef.delete();
  }

  static Future<void> updateData({
    required CollectionReference<Map<String, dynamic>> ref,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    ref.doc(docId).set(data);
  }
}