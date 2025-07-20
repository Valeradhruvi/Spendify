// feedback_data.dart

class FeedbackModel {
  final String userId;
  final double rating;
  final String message;
  final DateTime timestamp;

  FeedbackModel({
    required this.userId,
    required this.rating,
    required this.message,
    required this.timestamp,
  });
}

List<FeedbackModel> feedbackList = [];
