import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mobile_project/models/user.dart' as appUser;
import 'package:mobile_project/screens/about_us_screen.dart';
import 'package:mobile_project/screens/edit_account_screen.dart';
import 'package:mobile_project/widgets/forward_button.dart';
import 'package:mobile_project/widgets/setting_item.dart';

class SettingScreen extends StatefulWidget {
  appUser.User user;

  SettingScreen({super.key, required this.user});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  void _signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login'); 
  } catch (e) {
    print(e.toString()); // Handle any errors during sign out
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Settings",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 40),
              Text(
                "Account",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.user.profilePictureUrl),
                      radius: 35,
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.user.firstname} ${widget.user.lastname}",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.user.email,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ForwardButton(
                      onTap: () async {
                        final updatedUser = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditAccountScreen(user: widget.user),
                          ),
                        ) as appUser.User?;

                        if (updatedUser != null) {
                          // Create a new User object with updated data
                          final newUser = appUser.User.fromFirestore(
                              widget.user.toMap() as DocumentSnapshot);
                          newUser.updateFrom(updatedUser);

                          setState(() {
                            widget.user = newUser;
                          });
                        }
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Settings",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "Contact Us",
                icon: Ionicons.information_circle_sharp,
                bgColor: Colors.green.shade100,
                iconColor: Colors.green,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AboutUsScreen(),)),
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "Log Out",
                icon: Ionicons.log_out_outline,
                bgColor: Colors.red.shade100,
                iconColor: Colors.red,
                onTap: () => _signOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
