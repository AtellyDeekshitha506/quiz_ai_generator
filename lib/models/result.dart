class QuizResult {
  final String id;
  final String quizId;
  final String userId;
  final int score;
  final int totalQuestions;
  final Map<String, int> answers; // questionId -> selectedIndex
  final DateTime completedAt;
  final Duration timeTaken;

  QuizResult({
    required this.id,
    required this.quizId,
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.answers,
    required this.completedAt,
    required this.timeTaken,
  });

  double get percentage => (score / totalQuestions) * 100;
}
