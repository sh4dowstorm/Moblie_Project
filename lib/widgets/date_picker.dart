import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class DatePickerCustom extends StatefulWidget {
  const DatePickerCustom({
    super.key,
    required this.datePickerController,
  });

  final TextEditingController datePickerController;

  @override
  State<DatePickerCustom> createState() => _DatePickerCustomState();
}

class _DatePickerCustomState extends State<DatePickerCustom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
            blurRadius: 4,
          )
        ],
      ),
      child: TextFormField(
        onTap: () {
          _pickDate(
            context: context,
            changeDate: (pickedDate) {
              setState(() {
                widget.datePickerController.text = pickedDate;
              });
            },
          );
        },
        readOnly: true,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Ionicons.calendar_clear_outline,
          ),
          contentPadding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
          hintText: widget.datePickerController.text,
          hintStyle: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    );
  }

  Future<void> _pickDate({
    required BuildContext context,
    required Function(String) changeDate,
  }) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(widget.datePickerController.text),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    log(pickedDate.toString());

    if (pickedDate != null) {
      changeDate(formatDate(pickedDate, [yyyy, '-', mm, '-', dd]));
    }
  }
}
