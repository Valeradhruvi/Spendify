import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController messageController = TextEditingController();
  double rating = 0;

  String get currentTimestamp =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      // Get userId from Firebase Auth (null if not signed in)
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
      final message = messageController.text.trim();

      try {
        // 1. Add to main feedback collection (userId not needed)
        await FirebaseFirestore.instance.collection('feedback').add({
          // 'userId': userId, // Optional: omit here if you don't want it
          'message': message,
          'rating': rating,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // 2. Add to admin collection with only userId and rating
        await FirebaseFirestore.instance
            .collection('admin')
            .doc('feedbacks')
            .collection('entries')
            .add({
          'userId': userId,
          'rating': rating,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Feedback submitted!")),
        );
        Navigator.pop(context);

        messageController.clear();
        setState(() => rating = 0);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit feedback: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ADB5),
        title: const Text("Feedback"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildLabel("Rate the App"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: index < rating ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () => setState(() => rating = index + 1.0),
                  );
                }),
              ),
              const SizedBox(height: 20),
              _buildLabel("Message / Suggestions"),
              const SizedBox(height: 20),
              TextFormField(
                controller: messageController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Enter your feedback or suggestion"),
                validator: (value) =>
                value == null || value.isEmpty ? 'Message is required' : null,
              ),
              const SizedBox(height: 20),
              _buildLabel("Timestamp"),
              Text(currentTimestamp, style: GoogleFonts.poppins(color: Colors.white70)),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text("Submit Feedback",),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00ADB5)),
                onPressed: _submitFeedback,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: const Color(0xFF162447),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
