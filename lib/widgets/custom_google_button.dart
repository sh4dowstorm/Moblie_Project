import 'package:flutter/material.dart';
import 'package:mobile_project/styles/google_logo.dart';

class CustomGoogleButton extends StatelessWidget {
  final Function() onPressed;

  const CustomGoogleButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF1F1F1F), 
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35), // Rounded corners
          side: BorderSide(color: Colors.grey.shade300, width: 1.0), // Stroke
        ), // Font color
        textStyle: const TextStyle(
          fontFamily: 'Roboto', 
          fontSize: 14.0, 
          height: 20.0 / 14.0, // Line height (adjust based on font size)
        ),
      ),
      icon: const GoogleLogo(size: 20),
      label: const Text('Sign in with Google'),
    );
  }
}
