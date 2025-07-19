class FeedbackRepository {
  static final List<Map<String, dynamic>> _feedbacks = [];

  static List<Map<String, dynamic>> get feedbacks => _feedbacks;

  static void addFeedback(Map<String, dynamic> feedback) {
    _feedbacks.insert(0, feedback); // insert newest at top
  }
}
