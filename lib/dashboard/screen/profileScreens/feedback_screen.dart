import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  double rating = 0;

  String get currentTimestamp =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      final userId = userIdController.text.trim();
      final message = messageController.text.trim();

      // Handle feedback submission logic here (e.g., store to database, send to server)
      debugPrint("User ID: $userId");
      debugPrint("Rating: $rating");
      debugPrint("Message: $message");
      debugPrint("Timestamp: $currentTimestamp");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feedback submitted!")),
      );
      Navigator.pop(context);

      // Optionally clear fields
      userIdController.clear();
      messageController.clear();
      setState(() => rating = 0);
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
              _buildLabel("User ID"),
              TextFormField(
                controller: userIdController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Enter your user ID"),
                validator: (value) =>
                value == null || value.isEmpty ? 'User ID is required' : null,
              ),
              const SizedBox(height: 20),

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
