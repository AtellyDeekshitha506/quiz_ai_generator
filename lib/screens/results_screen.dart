// results_screen.dart - Enhanced Version
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quiz_ai/models/result.dart';
import 'package:quiz_ai/providers/quiz_provider.dart';
import 'package:quiz_ai/models/quiz_model.dart';

// ADD TO pubspec.yaml:
// dependencies:
//   share_plus: ^7.0.0

class ResultScreen extends StatelessWidget {
  final QuizResult result;

  const ResultScreen({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPassed = result.percentage >= 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareResult(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Result Card
            Card(
              color: isPassed ? Colors.green.shade50 : Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      isPassed ? Icons.check_circle : Icons.cancel,
                      size: 80,
                      color: isPassed ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isPassed ? 'Congratulations!' : 'Keep Practicing!',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${result.percentage.toStringAsFixed(1)}%',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isPassed ? Colors.green : Colors.red,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${result.score} out of ${result.totalQuestions} correct',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${result.score}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('Correct'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(Icons.cancel, color: Colors.red, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            '${result.totalQuestions - result.score}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('Incorrect'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Time Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined),
                        const SizedBox(width: 8),
                        const Text('Time Taken:'),
                      ],
                    ),
                    Text(
                      '${result.timeTaken.inMinutes}:${(result.timeTaken.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExplanationScreen(result: result),
                    ),
                  );
                },
                icon: const Icon(Icons.visibility),
                label: const Text('View Detailed Explanations'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _shareResult(context),
                icon: const Icon(Icons.share),
                label: const Text('Share Result'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.home),
                label: const Text('Back to Home'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareResult(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final quiz = quizProvider.quizzes.firstWhere(
      (q) => q.id == result.quizId,
      orElse: () => Quiz(
        id: '',
        title: 'Quiz',
        description: '',
        questions: [],
        duration: 0,
        createdAt: DateTime.now(),
        createdBy: '',
        difficulty: Difficulty.medium,
      ),
    );

    final shareText = '''
🎯 Quiz Results 🎯

Quiz: ${quiz.title}
Score: ${result.score}/${result.totalQuestions} (${result.percentage.toStringAsFixed(1)}%)
Status: ${result.percentage >= 60 ? '✅ Passed' : '❌ Failed'}
Time Taken: ${result.timeTaken.inMinutes}:${(result.timeTaken.inSeconds % 60).toString().padLeft(2, '0')}

Generated with AI Quiz Generator 🚀
''';

    Share.share(shareText, subject: 'My Quiz Results');
  }
}

// ============================================
// EXPLANATION SCREEN - Detailed View
// ============================================

class ExplanationScreen extends StatelessWidget {
  final QuizResult result;

  const ExplanationScreen({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final quiz = quizProvider.quizzes.firstWhere(
      (q) => q.id == result.quizId,
      orElse: () => Quiz(
        id: '',
        title: 'Quiz',
        description: '',
        questions: [],
        duration: 0,
        createdAt: DateTime.now(),
        createdBy: '',
        difficulty: Difficulty.medium,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed Explanations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareExplanations(context, quiz),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'copy') {
                _copyExplanationsToClipboard(context, quiz);
              } else if (value == 'export') {
                _exportExplanations(context, quiz);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'copy',
                child: Row(
                  children: [
                    Icon(Icons.copy),
                    SizedBox(width: 8),
                    Text('Copy to Clipboard'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.file_download),
                    SizedBox(width: 8),
                    Text('Export as Text'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildSummaryChip(
                      icon: Icons.check_circle,
                      label: '${result.score} Correct',
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    _buildSummaryChip(
                      icon: Icons.cancel,
                      label: '${result.totalQuestions - result.score} Wrong',
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    _buildSummaryChip(
                      icon: Icons.percent,
                      label: '${result.percentage.toStringAsFixed(0)}%',
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Questions List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: quiz.questions.length,
              itemBuilder: (context, index) {
                final question = quiz.questions[index];
                final userAnswer = result.answers[question.id];
                final isCorrect = userAnswer == question.correctAnswerIndex;

                return _QuestionExplanationCard(
                  questionNumber: index + 1,
                  question: question,
                  userAnswerIndex: userAnswer,
                  isCorrect: isCorrect,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: const Icon(Icons.home),
            label: const Text('Back to Home'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(label, style: TextStyle(fontSize: 12)),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }

  void _shareExplanations(BuildContext context, Quiz quiz) {
    final explanationText = _buildExplanationText(quiz);
    Share.share(explanationText, subject: 'Quiz Explanations - ${quiz.title}');
  }

  void _copyExplanationsToClipboard(BuildContext context, Quiz quiz) {
    final explanationText = _buildExplanationText(quiz);
    Clipboard.setData(ClipboardData(text: explanationText));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Explanations copied to clipboard!'),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _exportExplanations(BuildContext context, Quiz quiz) {
    // In a real app, you would save this to a file
    final explanationText = _buildExplanationText(quiz);

    // For now, we'll just share it
    Share.share(
      explanationText,
      subject: 'Quiz_Explanations_${quiz.title.replaceAll(' ', '_')}.txt',
    );
  }

  String _buildExplanationText(Quiz quiz) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln('📚 QUIZ EXPLANATIONS 📚');
    buffer.writeln('========================\n');
    buffer.writeln('Quiz: ${quiz.title}');
    buffer.writeln('Total Questions: ${quiz.questions.length}');
    buffer.writeln('Score: ${result.score}/${result.totalQuestions}');
    buffer.writeln('Percentage: ${result.percentage.toStringAsFixed(1)}%\n');
    buffer.writeln('========================\n');

    for (int i = 0; i < quiz.questions.length; i++) {
      final question = quiz.questions[i];
      final userAnswer = result.answers[question.id];
      final isCorrect = userAnswer == question.correctAnswerIndex;

      buffer.writeln('Question ${i + 1}: ${question.text}');
      buffer.writeln('\nOptions:');
      for (int j = 0; j < question.options.length; j++) {
        buffer.write('${String.fromCharCode(65 + j)}. ${question.options[j]}');
        if (j == question.correctAnswerIndex) {
          buffer.write(' ✓ (Correct Answer)');
        }
        if (j == userAnswer) {
          buffer.write(isCorrect ? ' (Your Answer ✓)' : ' (Your Answer ✗)');
        }
        buffer.writeln();
      }

      buffer.writeln('\n💡 Explanation:');
      buffer.writeln(question.explanation ?? 'No explanation available.');
      buffer.writeln('\n------------------------\n');
    }

    buffer.writeln('Generated with AI Quiz Generator 🚀');
    return buffer.toString();
  }
}

// ============================================
// QUESTION EXPLANATION CARD WIDGET
// ============================================

class _QuestionExplanationCard extends StatefulWidget {
  final int questionNumber;
  final Question question;
  final int? userAnswerIndex;
  final bool isCorrect;

  const _QuestionExplanationCard({
    required this.questionNumber,
    required this.question,
    required this.userAnswerIndex,
    required this.isCorrect,
  });

  @override
  State<_QuestionExplanationCard> createState() =>
      _QuestionExplanationCardState();
}

class _QuestionExplanationCardState extends State<_QuestionExplanationCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: widget.isCorrect ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isCorrect
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.isCorrect ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.isCorrect ? Icons.check : Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${widget.questionNumber}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.isCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                      Text(
                        widget.isCorrect ? 'Correct' : 'Incorrect',
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.isCorrect
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () {
                    setState(() => _isExpanded = !_isExpanded);
                  },
                ),
              ],
            ),
          ),

          // Question Text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.question.text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: widget.question.options.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                final isCorrectAnswer =
                    index == widget.question.correctAnswerIndex;
                final isUserAnswer = index == widget.userAnswerIndex;

                Color? backgroundColor;
                Color? borderColor;
                IconData? icon;
                Color? iconColor;

                if (isCorrectAnswer) {
                  backgroundColor = Colors.green.withOpacity(0.1);
                  borderColor = Colors.green;
                  icon = Icons.check_circle;
                  iconColor = Colors.green;
                } else if (isUserAnswer && !widget.isCorrect) {
                  backgroundColor = Colors.red.withOpacity(0.1);
                  borderColor = Colors.red;
                  icon = Icons.cancel;
                  iconColor = Colors.red;
                } else {
                  backgroundColor = Colors.grey.withOpacity(0.05);
                  borderColor = Colors.grey.shade300;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border.all(color: borderColor!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: borderColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + index),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: borderColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontWeight: isCorrectAnswer || isUserAnswer
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (icon != null) Icon(icon, color: iconColor, size: 20),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Explanation (Expandable)
          if (_isExpanded && widget.question.explanation != null)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb,
                          color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Explanation',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.question.explanation!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade900,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
