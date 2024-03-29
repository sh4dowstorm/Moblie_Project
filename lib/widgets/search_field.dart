import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.hintText,
    required this.changeValue,
  });

  final String? hintText;
  final Function(String?) changeValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE1E8E1),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(1),
      child: TextFormField(
        onChanged: (newValue) {
          changeValue(newValue);
        },
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(
            Ionicons.search,
          ),
        ),
      ),
    );
  }
}
