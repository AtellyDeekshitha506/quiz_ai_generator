import 'package:flutter/material.dart';
import 'package:quiz_ai/models/result.dart';
import 'package:quiz_ai/models/quiz_model.dart';

class QuizProvider extends ChangeNotifier {
  List<Quiz> _quizzes = _getMockQuizzes();
  List<QuizResult> _results = _getMockResults();
  Quiz? _currentQuiz;
  Map<String, int> _currentAnswers = {};
  DateTime? _quizStartTime;

  List<Quiz> get quizzes => _quizzes;
  List<Quiz> get favoriteQuizzes =>
      _quizzes.where((q) => q.isFavorite).toList();
  List<QuizResult> get results => _results;
  Quiz? get currentQuiz => _currentQuiz;
  Map<String, int> get currentAnswers => _currentAnswers;

  void toggleFavorite(String quizId) {
    final quiz = _quizzes.firstWhere((q) => q.id == quizId);
    quiz.isFavorite = !quiz.isFavorite;
    notifyListeners();
  }

  void startQuiz(Quiz quiz) {
    _currentQuiz = quiz;
    _currentAnswers = {};
    _quizStartTime = DateTime.now();
    notifyListeners();
  }

  void answerQuestion(String questionId, int answerIndex) {
    _currentAnswers[questionId] = answerIndex;
    notifyListeners();
  }

  QuizResult submitQuiz() {
    if (_currentQuiz == null || _quizStartTime == null) {
      throw Exception('No active quiz');
    }

    int score = 0;
    for (var question in _currentQuiz!.questions) {
      if (_currentAnswers[question.id] == question.correctAnswerIndex) {
        score++;
      }
    }

    final result = QuizResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      quizId: _currentQuiz!.id,
      userId: 'user1',
      score: score,
      totalQuestions: _currentQuiz!.questions.length,
      answers: Map.from(_currentAnswers),
      completedAt: DateTime.now(),
      timeTaken: DateTime.now().difference(_quizStartTime!),
    );

    _results.add(result);
    _currentQuiz = null;
    _currentAnswers = {};
    _quizStartTime = null;
    notifyListeners();

    return result;
  }

  void addQuiz(Quiz quiz) {
    _quizzes.insert(0, quiz);
    notifyListeners();
  }

  static List<Quiz> _getMockQuizzes() {
    return [
      Quiz(
        id: '1',
        title: 'Flutter Basics',
        description: 'Test your knowledge of Flutter fundamentals',
        duration: 15,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        createdBy: 'AI Generator',
        difficulty: Difficulty.easy,
        questions: [
          Question(
            id: 'q1',
            text: 'What is Flutter?',
            type: QuestionType.mcq,
            options: [
              'A mobile game engine',
              'A UI framework for cross-platform apps',
              'A database system',
              'A programming language',
            ],
            correctAnswerIndex: 1,
            explanation:
                'Flutter is an open-source UI framework created by Google.',
          ),
          Question(
            id: 'q2',
            text: 'Which language is used to write Flutter apps?',
            type: QuestionType.mcq,
            options: ['Java', 'Kotlin', 'Dart', 'Swift'],
            correctAnswerIndex: 2,
            explanation: 'Flutter uses Dart as its programming language.',
          ),
          Question(
            id: 'q3',
            text: 'What is a widget in Flutter?',
            type: QuestionType.mcq,
            options: [
              'A database',
              'A building block of the UI',
              'A server',
              'A compiler',
            ],
            correctAnswerIndex: 1,
            explanation: 'Widgets are the basic building blocks of Flutter UI.',
          ),
          Question(
            id: 'q4',
            text: 'Which widget is used for layout in Flutter?',
            type: QuestionType.mcq,
            options: ['Container', 'Column', 'Row', 'All of the above'],
            correctAnswerIndex: 3,
            explanation: 'All these widgets can be used for layout purposes.',
          ),
          Question(
            id: 'q5',
            text: 'What does setState() do?',
            type: QuestionType.mcq,
            options: [
              'Deletes the app',
              'Updates the UI',
              'Creates a new widget',
              'Saves data',
            ],
            correctAnswerIndex: 1,
            explanation: 'setState() triggers a rebuild of the widget.',
          ),
          Question(
            id: 'q6',
            text: 'What is hot reload?',
            type: QuestionType.mcq,
            options: [
              'Restarting the app',
              'Updating code without losing state',
              'Debugging tool',
              'Build command',
            ],
            correctAnswerIndex: 1,
            explanation:
                'Hot reload allows instant code updates while preserving state.',
          ),
          Question(
            id: 'q7',
            text: 'Which is a stateful widget?',
            type: QuestionType.mcq,
            options: ['Text', 'Icon', 'StatefulWidget', 'Container'],
            correctAnswerIndex: 2,
            explanation: 'StatefulWidget maintains state that can change.',
          ),
          Question(
            id: 'q8',
            text: 'What is pubspec.yaml used for?',
            type: QuestionType.mcq,
            options: [
              'UI design',
              'Managing dependencies',
              'Database config',
              'Routing',
            ],
            correctAnswerIndex: 1,
            explanation:
                'pubspec.yaml manages project dependencies and assets.',
          ),
          Question(
            id: 'q9',
            text: 'What does MaterialApp provide?',
            type: QuestionType.mcq,
            options: [
              'Database',
              'Material Design wrapper',
              'Server connection',
              'Testing framework',
            ],
            correctAnswerIndex: 1,
            explanation:
                'MaterialApp provides Material Design theming and navigation.',
          ),
          Question(
            id: 'q10',
            text: 'Which method builds the UI?',
            type: QuestionType.mcq,
            options: ['main()', 'build()', 'create()', 'render()'],
            correctAnswerIndex: 1,
            explanation: 'The build() method returns the widget tree.',
          ),
        ],
      ),
      Quiz(
        id: '2',
        title: 'Machine Learning Basics',
        description: 'Introduction to ML concepts',
        duration: 20,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        createdBy: 'AI Generator',
        difficulty: Difficulty.medium,
        questions: [
          Question(
            id: 'q11',
            text: 'What is supervised learning?',
            type: QuestionType.mcq,
            options: [
              'Learning without labels',
              'Learning with labeled data',
              'Learning by trial and error',
              'Learning from games',
            ],
            correctAnswerIndex: 1,
            explanation: 'Supervised learning uses labeled training data.',
          ),
          Question(
            id: 'q12',
            text: 'What is a neural network?',
            type: QuestionType.mcq,
            options: [
              'A brain scan',
              'A network of interconnected nodes',
              'A database',
              'A type of algorithm',
            ],
            correctAnswerIndex: 1,
            explanation: 'Neural networks mimic biological neural connections.',
          ),
          Question(
            id: 'q13',
            text: 'What is overfitting?',
            type: QuestionType.mcq,
            options: [
              'Model too simple',
              'Model too complex for training data',
              'Perfect model',
              'Underfitting',
            ],
            correctAnswerIndex: 1,
            explanation:
                'Overfitting occurs when a model learns training data too well.',
          ),
          Question(
            id: 'q14',
            text: 'What is a training set?',
            type: QuestionType.mcq,
            options: [
              'Test data',
              'Data used to train the model',
              'Validation data',
              'Production data',
            ],
            correctAnswerIndex: 1,
            explanation: 'Training set is used to teach the model patterns.',
          ),
          Question(
            id: 'q15',
            text: 'What is a feature in ML?',
            type: QuestionType.mcq,
            options: [
              'Output variable',
              'Input variable',
              'Model name',
              'Algorithm type',
            ],
            correctAnswerIndex: 1,
            explanation: 'Features are input variables used for prediction.',
          ),
          Question(
            id: 'q16',
            text: 'What is classification?',
            type: QuestionType.mcq,
            options: [
              'Predicting categories',
              'Predicting numbers',
              'Clustering data',
              'Reducing dimensions',
            ],
            correctAnswerIndex: 0,
            explanation: 'Classification predicts discrete categories.',
          ),
          Question(
            id: 'q17',
            text: 'What is regression?',
            type: QuestionType.mcq,
            options: [
              'Predicting categories',
              'Predicting continuous values',
              'Clustering',
              'Classification',
            ],
            correctAnswerIndex: 1,
            explanation: 'Regression predicts continuous numerical values.',
          ),
          Question(
            id: 'q18',
            text: 'What is accuracy?',
            type: QuestionType.mcq,
            options: [
              'Speed of model',
              'Ratio of correct predictions',
              'Model size',
              'Training time',
            ],
            correctAnswerIndex: 1,
            explanation:
                'Accuracy measures correct predictions vs total predictions.',
          ),
        ],
      ),
      Quiz(
        id: '3',
        title: 'Python Programming',
        description: 'Test your Python skills',
        duration: 25,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        createdBy: 'AI Generator',
        difficulty: Difficulty.medium,
        questions: [
          Question(
            id: 'q19',
            text: 'What is Python?',
            type: QuestionType.mcq,
            options: [
              'A snake',
              'A high-level programming language',
              'A database',
              'An operating system',
            ],
            correctAnswerIndex: 1,
            explanation:
                'Python is a versatile high-level programming language.',
          ),
          Question(
            id: 'q20',
            text: 'Which keyword is used to define a function?',
            type: QuestionType.mcq,
            options: ['function', 'def', 'func', 'define'],
            correctAnswerIndex: 1,
            explanation:
                'The def keyword is used to define functions in Python.',
          ),
          Question(
            id: 'q21',
            text: 'What is a list in Python?',
            type: QuestionType.mcq,
            options: [
              'Immutable collection',
              'Mutable ordered collection',
              'Dictionary',
              'Set',
            ],
            correctAnswerIndex: 1,
            explanation: 'Lists are mutable ordered collections in Python.',
          ),
          Question(
            id: 'q22',
            text: 'What does len() return?',
            type: QuestionType.mcq,
            options: [
              'First element',
              'Last element',
              'Length of object',
              'Type of object',
            ],
            correctAnswerIndex: 2,
            explanation: 'len() returns the number of items in an object.',
          ),
          Question(
            id: 'q23',
            text: 'Which is a Python web framework?',
            type: QuestionType.mcq,
            options: ['React', 'Django', 'Angular', 'Vue'],
            correctAnswerIndex: 1,
            explanation: 'Django is a popular Python web framework.',
          ),
          Question(
            id: 'q24',
            text: 'What is pip?',
            type: QuestionType.mcq,
            options: [
              'Python function',
              'Package installer',
              'IDE',
              'Compiler',
            ],
            correctAnswerIndex: 1,
            explanation: 'pip is the package installer for Python.',
          ),
          Question(
            id: 'q25',
            text: 'What is indentation used for?',
            type: QuestionType.mcq,
            options: [
              'Comments',
              'Code blocks',
              'Variables',
              'Functions',
            ],
            correctAnswerIndex: 1,
            explanation: 'Indentation defines code blocks in Python.',
          ),
          Question(
            id: 'q26',
            text: 'Which data type is immutable?',
            type: QuestionType.mcq,
            options: ['List', 'Dictionary', 'Tuple', 'Set'],
            correctAnswerIndex: 2,
            explanation: 'Tuples are immutable in Python.',
          ),
        ],
      ),
      Quiz(
        id: '4',
        title: 'Data Structures',
        description: 'Fundamental data structures',
        duration: 30,
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        createdBy: 'AI Generator',
        difficulty: Difficulty.hard,
        questions: [
          Question(
            id: 'q27',
            text: 'What is Big O notation?',
            type: QuestionType.mcq,
            options: [
              'Data structure',
              'Algorithm complexity measure',
              'Programming language',
              'Database query',
            ],
            correctAnswerIndex: 1,
            explanation:
                'Big O notation describes algorithm time/space complexity.',
          ),
          Question(
            id: 'q28',
            text: 'What is a stack?',
            type: QuestionType.mcq,
            options: [
              'FIFO structure',
              'LIFO structure',
              'Tree structure',
              'Graph structure',
            ],
            correctAnswerIndex: 1,
            explanation: 'Stack follows Last In First Out (LIFO) principle.',
          ),
          Question(
            id: 'q29',
            text: 'What is a queue?',
            type: QuestionType.mcq,
            options: [
              'LIFO structure',
              'FIFO structure',
              'Random access',
              'Tree structure',
            ],
            correctAnswerIndex: 1,
            explanation: 'Queue follows First In First Out (FIFO) principle.',
          ),
          Question(
            id: 'q30',
            text: 'What is a binary tree?',
            type: QuestionType.mcq,
            options: [
              'Tree with max 2 children per node',
              'Tree with 3 children',
              'Linear structure',
              'Graph',
            ],
            correctAnswerIndex: 0,
            explanation: 'Binary tree has at most 2 children per node.',
          ),
          Question(
            id: 'q31',
            text: 'What is a hash table?',
            type: QuestionType.mcq,
            options: [
              'Array',
              'Key-value data structure',
              'Tree',
              'Graph',
            ],
            correctAnswerIndex: 1,
            explanation: 'Hash tables store key-value pairs for fast lookup.',
          ),
          Question(
            id: 'q32',
            text: 'What is O(1) complexity?',
            type: QuestionType.mcq,
            options: [
              'Linear time',
              'Constant time',
              'Logarithmic time',
              'Quadratic time',
            ],
            correctAnswerIndex: 1,
            explanation: 'O(1) means constant time regardless of input size.',
          ),
        ],
      ),
    ];
  }

  static List<QuizResult> _getMockResults() {
    final now = DateTime.now();
    return [
      QuizResult(
        id: 'r1',
        quizId: '1',
        userId: 'user1',
        score: 8,
        totalQuestions: 10,
        answers: {},
        completedAt: now.subtract(const Duration(days: 1)),
        timeTaken: const Duration(minutes: 12),
      ),
      QuizResult(
        id: 'r2',
        quizId: '2',
        userId: 'user1',
        score: 6,
        totalQuestions: 8,
        answers: {},
        completedAt: now.subtract(const Duration(days: 2)),
        timeTaken: const Duration(minutes: 15),
      ),
      QuizResult(
        id: 'r3',
        quizId: '1',
        userId: 'user1',
        score: 9,
        totalQuestions: 10,
        answers: {},
        completedAt: now.subtract(const Duration(days: 3)),
        timeTaken: const Duration(minutes: 10),
      ),
      QuizResult(
        id: 'r4',
        quizId: '3',
        userId: 'user1',
        score: 7,
        totalQuestions: 8,
        answers: {},
        completedAt: now.subtract(const Duration(days: 5)),
        timeTaken: const Duration(minutes: 18),
      ),
      QuizResult(
        id: 'r5',
        quizId: '2',
        userId: 'user1',
        score: 5,
        totalQuestions: 8,
        answers: {},
        completedAt: now.subtract(const Duration(days: 7)),
        timeTaken: const Duration(minutes: 20),
      ),
      QuizResult(
        id: 'r6',
        quizId: '4',
        userId: 'user1',
        score: 4,
        totalQuestions: 6,
        answers: {},
        completedAt: now.subtract(const Duration(days: 10)),
        timeTaken: const Duration(minutes: 25),
      ),
      QuizResult(
        id: 'r7',
        quizId: '1',
        userId: 'user1',
        score: 10,
        totalQuestions: 10,
        answers: {},
        completedAt: now.subtract(const Duration(days: 12)),
        timeTaken: const Duration(minutes: 14),
      ),
      QuizResult(
        id: 'r8',
        quizId: '3',
        userId: 'user1',
        score: 6,
        totalQuestions: 8,
        answers: {},
        completedAt: now.subtract(const Duration(days: 14)),
        timeTaken: const Duration(minutes: 16),
      ),
      QuizResult(
        id: 'r9',
        quizId: '2',
        userId: 'user1',
        score: 7,
        totalQuestions: 8,
        answers: {},
        completedAt: now.subtract(const Duration(days: 18)),
        timeTaken: const Duration(minutes: 17),
      ),
      QuizResult(
        id: 'r10',
        quizId: '1',
        userId: 'user1',
        score: 8,
        totalQuestions: 10,
        answers: {},
        completedAt: now.subtract(const Duration(days: 20)),
        timeTaken: const Duration(minutes: 13),
      ),
    ];
  }
}
