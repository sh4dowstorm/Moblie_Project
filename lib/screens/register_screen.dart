import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobile_project/models/user.dart' as appUser;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _username = '';
  String _firstname = '';
  String _lastname = '';
  String _password = '';
  String _confirmPassword = '';

  String _error = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (_password == _confirmPassword) {
        try {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );
          UserCredential userCredential =
              await _auth.createUserWithEmailAndPassword(
            email: _email,
            password: _password,
          );

          appUser.User user = appUser.User(
            uid: userCredential.user!.uid,
            username: _username,
            email: _email,
            firstname: _firstname,
            lastname: _lastname,
            profilePictureUrl:
                'https://firebasestorage.googleapis.com/v0/b/mobile-project-trang.appspot.com/o/default-pfp.png?alt=media&token=016ca8b1-0568-45c3-bdfb-0bdadcba68ea',
          );

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(user.toMap());

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
      case 'invalid-email':
        return 'Please enter a valid email.';
      default:
        return 'An error occurred during registration';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Row(
          children: [
            Text("Register", style: Theme.of(context).textTheme.titleMedium),
            SizedBox(width: MediaQuery.of(context).size.width * 0.3),
            IconButton(
              icon: Icon(Ionicons.close_circle, color: Theme.of(context).colorScheme.error),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.outline),
                  fillColor: Theme.of(context).colorScheme.primary,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
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
                  labelText: 'Username',
                  labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.outline),
                  fillColor: Theme.of(context).colorScheme.primary,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
                onChanged: (value) {
                  setState(() {
                    _username = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                // Row to hold First Name and Last Name fields
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.outline),
                        fillColor: Theme.of(context).colorScheme.primary,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.outline),
                      onChanged: (value) {
                        setState(() {
                          _firstname = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                      width: 10), // Add a space between the text fields
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.outline),
                        fillColor: Theme.of(context).colorScheme.primary,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.outline),
                      onChanged: (value) {
                        setState(() {
                          _lastname = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a last name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.outline),
                  fillColor: Theme.of(context).colorScheme.primary,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.outline),
                  fillColor: Theme.of(context).colorScheme.primary,
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
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
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
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surfaceTint,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  ),
                  child: const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
