import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  String _errorMessage = '';

  void _handleSavePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser!;
    final cred = EmailAuthProvider.credential(
        email: user.email!, password: _currentPasswordController.text);

    try {
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(_newPasswordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _getErrorMessageFromCode(e.code);
      });
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
      case 'wrong-password':
        return 'Current password is incorrect.';
      default:
        return 'An error occurred during registration';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Change Password",
        style: Theme.of(context).textTheme.titleMedium),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Current Password',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.outline),
                fillColor: Theme.of(context).colorScheme.primary,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(40),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureCurrentPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureCurrentPassword = !_obscureCurrentPassword;
                    });
                  },
                ),
              ),
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
              controller: _currentPasswordController,
              obscureText: _obscureCurrentPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter current password';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'New Password',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.outline),
                fillColor: Theme.of(context).colorScheme.primary,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(40),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
              ),
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
              controller: _newPasswordController,
              obscureText: _obscureNewPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter new password';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.outline),
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
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter confirm new password';
                }
                return null;
              },
            ),

            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: _handleSavePassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surfaceTint,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          ),
          child: const Text('Change Password'),
        ),
      ],
    );
  }
}
