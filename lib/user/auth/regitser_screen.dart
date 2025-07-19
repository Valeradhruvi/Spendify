import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spendify/functions/database_fucntions.dart';

import '../../functions/authFunctions.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  int count=100;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1B1B2F), Color(0xFF162447)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: size.height * 0.28,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00ADB5), Color(0xFF393E46)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(80),
                    bottomRight: Radius.circular(80),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Create Your Account",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ).animate().slideY(duration: 900.ms).fadeIn(),
            ),

            Center(
              child: GlassmorphicContainer(
                width: size.width * 0.9,
                height: size.height * 0.65,
                borderRadius: 25,
                blur: 20,
                alignment: Alignment.center,
                border: 2,
                linearGradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white38.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderGradient: const LinearGradient(
                  colors: [Colors.white24, Colors.white10],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInput("Full Name", Icons.person, controller: nameController, validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Please enter your name';
                        return null;
                      }),
                      const SizedBox(height: 15),
                      _buildInput("Email", Icons.email, controller: emailController, validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your email';
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
                        return null;
                      }),
                      const SizedBox(height: 15),
                      _buildInput("Password", Icons.lock, obscure: true, controller: passwordController, validator: (value) {
                        if (value == null || value.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      }),
                      const SizedBox(height: 15),
                      _buildInput("Confirm Password", Icons.lock_outline, obscure: true, controller: confirmPasswordController, validator: (value) {
                        if (value != passwordController.text) return 'Passwords do not match';
                        return null;
                      }),
                      const SizedBox(height: 25),

                      ElevatedButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // proceed with registration logic
                            _formKey.currentState!.save();
                            signup(emailController.text, passwordController.text, nameController.text);
                            count++;
                            createData('users' ,count.toString() , nameController.text.toString() , emailController.text.toString() , passwordController.text.toString());
                            // Navigator.pushNamed(context, '/home');
                            await  FirebaseFirestore.instance.collection('admin').doc('A01').update({'userID':FieldValue.arrayUnion([count])}).then((value) => print('USER ADDED TO ADMIN'),);
                            print('::::::::::::${FirebaseAuth.instance.currentUser?.uid}:::::::::');
                          }
                        },
                        icon: const Icon(Icons.app_registration, color: Colors.white),
                        label: const Text("Register", style: TextStyle(fontSize: 16, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00ADB5),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ).animate().fadeIn(delay: 400.ms),

                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 1, end: 0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
      String hint,
      IconData icon, {
        bool obscure = false,
        required TextEditingController controller,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.transparent,
        prefixIcon: Icon(icon, color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}