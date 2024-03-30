import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

import 'package:mobile_project/models/user.dart' as appUser;
import 'package:mobile_project/screens/change_password_screen.dart';
import 'package:mobile_project/widgets/edit_item.dart';

class EditAccountScreen extends StatefulWidget {
  final appUser.User user;

  EditAccountScreen({super.key, required this.user});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _firstNameController = TextEditingController(text: widget.user.firstname);
    _lastNameController = TextEditingController(text: widget.user.lastname);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _showImageSourceOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () => _pickImage(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () => _pickImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    // Request camera and storage permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();

    // Handle permission results (If both permissions are granted)
    if (statuses[Permission.camera]!.isGranted &&
        statuses[Permission.storage]!.isGranted) {
      final XFile? pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        _uploadImage();
        Navigator.pop(context);
      }
    } else {
      // Show an error message or guide the user to enable permissions
      print('Permissions denied.');
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_profile_pictures/${widget.user.uid}');
        await storageRef.putFile(_imageFile!);
        final downloadURL = await storageRef.getDownloadURL();

        // Update the user's profile picture URL
        widget.user.updateProfilePicture(downloadURL);

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Image uploaded.")));
      } on FirebaseException catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('Error uploading image: ${e.message}'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), // Dismiss the dialog
                  child: Text('OK')),
            ],
          ),
        );
      }
    }
  }

  void _updateUserAndSave() async {
    widget.user.username = _usernameController.text;
    widget.user.firstname = _firstNameController.text;
    widget.user.lastname = _lastNameController.text;
    widget.user.email = _emailController.text;
    widget.user.updateProfilePicture(
        _imageFile?.path ?? widget.user.profilePictureUrl);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update(widget.user.toMap());

      await widget.user.updateEmail(widget.user.email);

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: const Text(
                    'Please check your email inbox and verify the new email address.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'))
                ],
              ));
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Profile updated")));
      Navigator.pop(context, widget.user);
    } on FirebaseException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('Error updating profile: ${e.message}'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), // Dismiss the dialog
                child: Text('OK')),
          ],
        ),
      );
    }
  }

  void _handleChangePassword() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ChangePasswordScreen();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, widget.user);
          },
          icon: const Icon(Ionicons.chevron_back_outline),
        ),
        leadingWidth: 80,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Account",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 40),
              EditItem(
                title: "Photo",
                widget: GestureDetector(
                  onTap: () => _showImageSourceOptions(context),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : NetworkImage(widget.user.profilePictureUrl)
                            as ImageProvider,
                    radius: 35,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              EditItem(
                title: "Username",
                widget: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primary,
                    hintText: "Enter your username",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 5,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              EditItem(
                title: "Change Password",
                widget: ElevatedButton(
                  onPressed: _handleChangePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.outline,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                  ),
                  child: const Text("Change Password"),
                ),
              ),
              const SizedBox(height: 30),
              EditItem(
                title: "First Name",
                widget: TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primary,
                    hintText: "Enter your First Name",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 5,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              EditItem(
                title: "Last Name",
                widget: TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primary,
                    hintText: "Enter your Last Name",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 5,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              EditItem(
                title: "Email",
                widget: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primary,
                    hintText: "Enter your email address",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 5,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    _updateUserAndSave();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surfaceTint,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
