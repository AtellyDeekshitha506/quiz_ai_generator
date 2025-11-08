import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_ai/screens/results_screen.dart';
import 'package:quiz_ai/providers/quiz_provider.dart';

class QuizAttemptScreen extends StatefulWidget {
  const QuizAttemptScreen({Key? key}) : super(key: key);

  @override
  State<QuizAttemptScreen> createState() => _QuizAttemptScreenState();
}

class _QuizAttemptScreenState extends State<QuizAttemptScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  late Duration _remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    final quiz = Provider.of<QuizProvider>(context, listen: false).currentQuiz!;
    _remainingTime = Duration(minutes: quiz.duration);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        });

        if (_remainingTime.inMinutes == 5 && _remainingTime.inSeconds == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('⏰ 5 minutes remaining!'),
              backgroundColor: Colors.orange,
            ),
          );
        }

        if (_remainingTime.inMinutes == 1 && _remainingTime.inSeconds == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('⏰ 1 minute remaining!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        timer.cancel();
        _submitQuiz();
      }
    });
  }

  void _submitQuiz() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Submit Quiz?'),
        content: const Text('Are you sure you want to submit your quiz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _timer?.cancel();
              final result = Provider.of<QuizProvider>(
                context,
                listen: false,
              ).submitQuiz();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final quiz = quizProvider.currentQuiz;

    if (quiz == null) {
      return const Scaffold(body: Center(child: Text('No quiz found!')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentPage + 1}/${quiz.questions.length}'),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _remainingTime.inMinutes < 5
                  ? Colors.red.withOpacity(0.1)
                  : Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer,
                  color: _remainingTime.inMinutes < 5
                      ? Colors.red
                      : Colors.blue,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '${_remainingTime.inMinutes}:${(_remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: _remainingTime.inMinutes < 5
                        ? Colors.red
                        : Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentPage + 1) / quiz.questions.length,
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: quiz.questions.length,
              itemBuilder: (context, index) {
                final question = quiz.questions[index];
                final selectedAnswer = quizProvider.currentAnswers[question.id];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            question.text,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ...question.options.asMap().entries.map((entry) {
                        final isSelected = selectedAnswer == entry.key;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              quizProvider.answerQuestion(
                                question.id,
                                entry.key,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer
                                    : null,
                                border: Border.all(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        String.fromCharCode(65 + entry.key),
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      entry.value,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
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
              if (_currentPage > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text('Previous'),
                  ),
                ),
              if (_currentPage > 0) const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < quiz.questions.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _submitQuiz();
                    }
                  },
                  child: Text(
                    _currentPage < quiz.questions.length - 1
                        ? 'Next'
                        : 'Submit',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
