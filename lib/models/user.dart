import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  String uid;
  String username;
  String email;
  String firstname;
  String lastname;
  String profilePictureUrl;

  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.profilePictureUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      uid: doc.id,
      username: data['username'],
      email: data['email'],
      firstname: data['firstname'],
      lastname: data['lastname'],
      profilePictureUrl: data['profilePictureUrl'],
    );
  }

  void updateFrom(User user) {
    username = user.username;
    email = user.email;
    firstname = user.firstname;
    lastname = user.lastname;
    profilePictureUrl = user.profilePictureUrl;
  }

  void updateProfilePicture(String url) {
    profilePictureUrl = url;
    _updateUserInFirestore(); 
  }

  void updateUsername(String username) {
    this.username = username;
    _updateUserInFirestore(); 
  }

Future<void> updateEmail(String newEmail) async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.verifyBeforeUpdateEmail(newEmail);
  }

  Future<void> _updateUserInFirestore() async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update(toMap());
  }
}