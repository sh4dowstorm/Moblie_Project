import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _error = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (_password == _confirmPassword) {
        try {
          // Show progress indicator
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );

          await _auth.createUserWithEmailAndPassword(
            email: _email,
            password: _password,
          );

          // Hide progress indicator
          Navigator.pop(context);
          Navigator.of(context).pop(); // Dismiss the registration screen
        } on FirebaseAuthException catch (e) {
          setState(() {
            _error = _getErrorMessageFromCode(e.code);
          });

          // Hide progress indicator
          Navigator.pop(context);
        }
      } else {
        setState(() {
          _error = 'Passwords do not match';
        });
      }
    }
  }

  String _getErrorMessageFromCode(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return 'Password is too weak.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      // Add more cases for other error codes
      default:
        return 'An error occurred during registration';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Register", style: Theme.of(context).textTheme.titleMedium),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Color(0xFF9DB1A3)),
                fillColor: const Color(0xFFDAEEE0),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              style: const TextStyle(color: Color(0xFF9DB1A3)),
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Email';
                } else if (!EmailValidator.validate(value)) {
                  return 'Please enter a valid Email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Color(0xFF9DB1A3)),
                fillColor: const Color(0xFFDAEEE0),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(40),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFF9DB1A3),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              style: const TextStyle(color: Color(0xFF9DB1A3)),
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
              obscureText: _obscurePassword,
              validator: (value) {
                // ... your password validation logic ...
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: const TextStyle(color: Color(0xFF9DB1A3)),
                fillColor: const Color(0xFFDAEEE0),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(40),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: const Color(0xFF9DB1A3),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              style: const TextStyle(color: Color(0xFF9DB1A3)),
              onChanged: (value) {
                setState(() {
                  _confirmPassword = value;
                });
              },
              obscureText: _obscureConfirmPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                return null;
              },
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                _error,
                style: TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF95D6A8),
                  foregroundColor: const Color(0xFF62A675),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
