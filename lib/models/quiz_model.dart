enum QuestionType { mcq, trueFalse, shortAnswer }

enum Difficulty { easy, medium, hard }

class Quiz {
  final String id;
  final String title;
  final String description;
  final List<Question> questions;
  final int duration; // in minutes
  final DateTime createdAt;
  final String createdBy;
  final Difficulty difficulty;
  bool isFavorite;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.duration,
    required this.createdAt,
    required this.createdBy,
    required this.difficulty,
    this.isFavorite = false,
  });

  // JSON serialization
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      questions:
          (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
      duration: json['duration'],
      createdAt: DateTime.parse(json['createdAt']),
      createdBy: json['createdBy'],
      difficulty: Difficulty.values.byName(json['difficulty']),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'questions': questions.map((q) => q.toJson()).toList(),
      'duration': duration,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'difficulty': difficulty.name,
      'isFavorite': isFavorite,
    };
  }
}

class Question {
  final String id;
  final String text;
  final QuestionType type;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;

  Question({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      type: QuestionType.values.byName(json['type']),
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.name,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
    };
  }
}
