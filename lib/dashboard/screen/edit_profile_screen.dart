import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final String username;
  final String email;

  const EditProfilePage({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }


  void _saveChanges() async {
    final uid = '101'; // or use FirebaseAuth.instance.currentUser?.uid
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();

    String? photoUrl;
    if (_profileImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$uid.jpg');
      final uploadTask = storageRef.putFile(_profileImage!);
      final snapshot = await uploadTask.whenComplete(() => null);
      photoUrl = await snapshot.ref.getDownloadURL();
    }

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'username': username,
      'email': email,
      if (photoUrl != null) 'photoUrl': photoUrl,
    });

    Navigator.pop(context);
  }



  void _cancelEdit() {
    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ADB5),
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black54,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField("Username", _usernameController),
            const SizedBox(height: 15),
            _buildTextField("Email", _emailController),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _cancelEdit,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text("Cancel", style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00ADB5)),
                  child: const Text("Save", style: TextStyle(color: Colors.black)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
