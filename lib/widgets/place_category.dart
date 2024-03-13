// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const int ICON = 0;
const int COLOR = 1;
const int LABEL = 2;

late BuildContext mainContext;

class PlaceCategoryButton extends StatelessWidget {
  const PlaceCategoryButton({
    super.key,
    required this.items,
    required this.updateValue,
    required this.currentIndex,
  });

  final int currentIndex;
  final List<List<dynamic>> items;
  final Function(int) updateValue;

  @override
  Widget build(BuildContext context) {
    mainContext = context;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        items.length,
        (index) => _createButton(
          icon: items[index][ICON],
          buttonColor: (index == currentIndex)
              ? const Color(0xFF070A07)
              : items[index][COLOR],
          iconColor: (index == currentIndex)
              ? items[index][COLOR]
              : const Color(0xFF070A07),
          label: items[index][LABEL],
          index: index,
        ),
      ),
    );
  }

  Column _createButton({
    required Icon icon,
    required Color iconColor,
    required Color buttonColor,
    required String label,
    required int index,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: buttonColor,
          ),
          height: 45,
          width: 45,
          child: IconButton(
            onPressed: () {
              updateValue(index);
            },
            icon: icon,
            style: Theme.of(mainContext)
                .iconButtonTheme
                .style!
                .copyWith(iconColor: MaterialStatePropertyAll(iconColor)),
          ),
        ),
        Text(label),
      ],
    );
  }
}
