import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_project/models/user.dart' as appUser;
import 'package:mobile_project/screens/register_screen.dart';
import 'package:mobile_project/screens/main_layout_screen.dart';
import 'package:mobile_project/widgets/social_button.dart';
import 'package:mobile_project/styles/google_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String _email = '';
  String _password = '';
  String _error = '';
  bool _obscurePassword = true;

  final _formKey = GlobalKey<FormState>();

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        appUser.User user = appUser.User.fromFirestore(userDoc);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainLayoutScreen(user: user)),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _error = e.message ?? 'Login Failed';
        });
      }
    }
  }

  void _handleRegister() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return const RegisterScreen();
        });
  }

  Future<void> _logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in with the obtained Google credentials
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        // Fetch or create user data in Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        appUser.User user;
        if (userDoc.exists) {
          user = appUser.User.fromFirestore(userDoc);
        } else {
          user = appUser.User(
            uid: userCredential.user!.uid,
            username: googleUser.displayName ?? 'username',
            email: googleUser.email,
            firstname: googleUser.displayName?.split(' ').first ?? 'firstname',
            lastname: googleUser.displayName?.split(' ').last ?? 'lastname',
            profilePictureUrl: googleUser.photoUrl ??
                'https://firebasestorage.googleapis.com/v0/b/mobile-project-trang.appspot.com/o/default-pfp.png?alt=media&token=016ca8b1-0568-45c3-bdfb-0bdadcba68ea',
          );
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(user.toMap());
        }

        // Navigate to the MainLayoutScreen, carrying the user data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainLayoutScreen(user: user)),
        );
      }
    } catch (e) {
      // Handle sign-in errors
      print('Google Sign in error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            'assets/images/login-page-image.jpg',
            height: MediaQuery.of(context).size.height / 3,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Login', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle:
                                const TextStyle(color: Color.fromRGBO(157, 177, 163, 1)),
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
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle:
                                const TextStyle(color: Color(0xFF9DB1A3)),
                            fillColor: const Color(0xFFDAEEE0),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
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
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _handleRegister,
                    child: const Text('Sign Up',
                        style: TextStyle(
                            color:
                                Color(0xFF62A675))), // Changed color and text
                  ),
                  const SizedBox(height: 10),
                  if (_error.isNotEmpty)
                    Text(
                      _error,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF95D6A8),
                        foregroundColor: const Color(0xFF62A675),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Color(0xFFDAEEE0),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Or Login with',
                        style: TextStyle(color: Color(0xFF95D6A8)),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Color(0xFFDAEEE0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: SocialButton(
                        onPressed: _logInWithGoogle,
                        icon: const GoogleLogo(size: 20)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
