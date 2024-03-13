import 'package:flutter/material.dart';
import 'package:mobile_project/models/location.dart';

class PlaceDetailScreen extends StatefulWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final Place place;

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(),
    );
  }
}
