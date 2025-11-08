import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_ai/providers/quiz_provider.dart';
import 'package:quiz_ai/screens/quiz_attempt_screen.dart';
import 'package:quiz_ai/screens/quiz_preview_screen.dart';
import 'package:quiz_ai/models/quiz_model.dart';

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({Key? key}) : super(key: key);

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizzes'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Quizzes'),
            Tab(text: 'Favorites'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _searchQuery = value.toLowerCase());
              },
              decoration: InputDecoration(
                hintText: 'Search quizzes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _QuizList(searchQuery: _searchQuery, showFavoritesOnly: false),
                _QuizList(searchQuery: _searchQuery, showFavoritesOnly: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizList extends StatelessWidget {
  final String searchQuery;
  final bool showFavoritesOnly;

  const _QuizList({required this.searchQuery, required this.showFavoritesOnly});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, _) {
        var quizzes = showFavoritesOnly
            ? quizProvider.favoriteQuizzes
            : quizProvider.quizzes;

        if (searchQuery.isNotEmpty) {
          quizzes = quizzes
              .where(
                (quiz) =>
                    quiz.title.toLowerCase().contains(searchQuery) ||
                    quiz.description.toLowerCase().contains(searchQuery),
              )
              .toList();
        }

        if (quizzes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  showFavoritesOnly ? Icons.star_border : Icons.quiz_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  showFavoritesOnly
                      ? 'No favorite quizzes yet'
                      : 'No quizzes found',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: quizzes.length,
          itemBuilder: (context, index) {
            final quiz = quizzes[index];
            return _QuizCard(quiz: quiz);
          },
        );
      },
    );
  }
}

class _QuizCard extends StatelessWidget {
  final Quiz quiz;

  const _QuizCard({required this.quiz});

  Color _getDifficultyColor(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return Colors.green;
      case Difficulty.medium:
        return Colors.orange;
      case Difficulty.hard:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => _QuizDetailSheet(quiz: quiz),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      quiz.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Consumer<QuizProvider>(
                    builder: (context, quizProvider, _) {
                      return IconButton(
                        icon: Icon(
                          quiz.isFavorite ? Icons.star : Icons.star_border,
                          color: quiz.isFavorite ? Colors.amber : null,
                        ),
                        onPressed: () {
                          quizProvider.toggleFavorite(quiz.id);
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                quiz.description,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    avatar: const Icon(Icons.quiz, size: 16),
                    label: Text('${quiz.questions.length} questions'),
                    padding: EdgeInsets.zero,
                  ),
                  Chip(
                    avatar: const Icon(Icons.timer, size: 16),
                    label: Text('${quiz.duration} min'),
                    padding: EdgeInsets.zero,
                  ),
                  Chip(
                    label: Text(quiz.difficulty.name.toUpperCase()),
                    backgroundColor: _getDifficultyColor(
                      quiz.difficulty,
                    ).withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: _getDifficultyColor(quiz.difficulty),
                      fontWeight: FontWeight.bold,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizDetailSheet extends StatelessWidget {
  final Quiz quiz;

  const _QuizDetailSheet({required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            quiz.title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(quiz.description, style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                'Created: ${quiz.createdAt.toString().substring(0, 10)}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                'By: ${quiz.createdBy}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Provider.of<QuizProvider>(context, listen: false).startQuiz(quiz);
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const QuizAttemptScreen()),
              );
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Quiz'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => QuizPreviewScreen(quiz: quiz),
                ),
              );
            },
            icon: const Icon(Icons.visibility),
            label: const Text('Preview Questions'),
          ),
        ],
      ),
    );
  }
}
