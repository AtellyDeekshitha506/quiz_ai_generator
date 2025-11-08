import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_ai/screens/quiz_attempt_screen.dart';
import 'package:quiz_ai/providers/quiz_provider.dart';
import 'package:quiz_ai/models/quiz_model.dart';

class QuizPreviewScreen extends StatelessWidget {
  final Quiz quiz;

  const QuizPreviewScreen({Key? key, required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Preview'),
        actions: [IconButton(icon: const Icon(Icons.edit), onPressed: () {})],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Chip(
                      avatar: const Icon(Icons.timer, size: 16),
                      label: Text('${quiz.duration} min'),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      avatar: const Icon(Icons.quiz, size: 16),
                      label: Text('${quiz.questions.length} questions'),
                    ),
                    const SizedBox(width: 8),
                    Chip(label: Text(quiz.difficulty.name.toUpperCase())),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: quiz.questions.length,
              itemBuilder: (context, index) {
                final question = quiz.questions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(child: Text('${index + 1}')),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                question.text,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...question.options.asMap().entries.map((entry) {
                          final isCorrect =
                              entry.key == question.correctAnswerIndex;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isCorrect
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.05),
                              border: Border.all(
                                color: isCorrect
                                    ? Colors.green
                                    : Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${String.fromCharCode(65 + entry.key)}. ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(child: Text(entry.value)),
                                if (isCorrect)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Provider.of<QuizProvider>(
                      context,
                      listen: false,
                    ).addQuiz(quiz);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Quiz saved!')),
                    );
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('Save'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<QuizProvider>(
                      context,
                      listen: false,
                    ).addQuiz(quiz);
                    Provider.of<QuizProvider>(
                      context,
                      listen: false,
                    ).startQuiz(quiz);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const QuizAttemptScreen(),
                      ),
                    );
                  },
                  child: const Text('Start Quiz'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
