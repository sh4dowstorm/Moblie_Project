import 'package:flutter/material.dart';
import 'package:mobile_project/styles/google_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:mobile_project/screens/register_screen.dart';
import 'package:mobile_project/screens/main_layout_screen.dart';
import 'package:mobile_project/widgets/social_button.dart';

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
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainLayoutScreen()),
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

  Future<void> _signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainLayoutScreen()),
        );
      }
    } catch (e) {
      // Handle sign-in errors
      print('Google Sign in error: $e');
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);

        await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainLayoutScreen()),
        );
      }
    } catch (e) {
      print('Facebook Sign in error: $e');
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
                                const TextStyle(color: Color(0xFF9DB1A3)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SocialButton(
                          onPressed: _signInWithGoogle,
                          icon: GoogleLogo(size: 20)),
                      SocialButton(
                          onPressed: _signInWithFacebook,
                          icon: const Icon(Icons.facebook,
                              size: 20, color: Color(0xFF0866FF))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
