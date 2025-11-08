import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              elevation: 4,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome back!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ready to test your knowledge?',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AIQuizGeneratorScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Create New Quiz'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.auto_awesome,
                      size: 80,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Stats Cards
            Text(
              'Your Statistics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.quiz,
                    title: 'Total Quizzes',
                    value: '24',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    icon: Icons.check_circle,
                    title: 'Completed',
                    value: '18',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.star,
                    title: 'Avg Score',
                    value: '85%',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    icon: Icons.trending_up,
                    title: 'Streak',
                    value: '7 days',
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Quizzes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Quizzes',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _QuizCard(
              title: 'Machine Learning Basics',
              questions: 15,
              difficulty: 'Medium',
              score: 92,
              date: '2 days ago',
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _QuizCard(
              title: 'Flutter Development',
              questions: 20,
              difficulty: 'Hard',
              score: 78,
              date: '5 days ago',
              color: Colors.purple,
            ),
            const SizedBox(height: 12),
            _QuizCard(
              title: 'Python Fundamentals',
              questions: 10,
              difficulty: 'Easy',
              score: 95,
              date: '1 week ago',
              color: Colors.green,
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    icon: Icons.history,
                    title: 'History',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionCard(
                    icon: Icons.star,
                    title: 'Favorites',
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionCard(
                    icon: Icons.analytics,
                    title: 'Analytics',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AIQuizGeneratorScreen(),
            ),
          );
        },
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Generate Quiz'),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  final String title;
  final int questions;
  final String difficulty;
  final int score;
  final String date;
  final Color color;

  const _QuizCard({
    required this.title,
    required this.questions,
    required this.difficulty,
    required this.score,
    required this.date,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$questions questions • $difficulty',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$score%',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        date,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                    ],
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

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Enums
enum InputMethod { text, pdf, both }

enum QuestionType { mcq, trueFalse, shortAnswer }

enum Difficulty { easy, medium, hard }

class AIQuizGeneratorScreen extends StatefulWidget {
  const AIQuizGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<AIQuizGeneratorScreen> createState() => _AIQuizGeneratorScreenState();
}

class _AIQuizGeneratorScreenState extends State<AIQuizGeneratorScreen> {
  final _notesController = TextEditingController();
  final _topicController = TextEditingController();
  QuestionType _selectedType = QuestionType.mcq;
  Difficulty _selectedDifficulty = Difficulty.medium;
  int _questionCount = 5;
  bool _isGenerating = false;
  InputMethod _inputMethod = InputMethod.text;
  String? _selectedFileName;
  bool _isPdfUploaded = false;

  @override
  void dispose() {
    _notesController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  // Mock PDF picker - In real app, use file_picker package
  void _pickPDF() async {
    // Simulate file picking
    setState(() {
      _selectedFileName = 'sample_document.pdf';
      _isPdfUploaded = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text('PDF uploaded: $_selectedFileName')),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _removePDF() {
    setState(() {
      _selectedFileName = null;
      _isPdfUploaded = false;
    });
  }

  void _generateQuiz() async {
    // Validation
    if (_inputMethod == InputMethod.text && _notesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your study notes')),
      );
      return;
    }

    if (_inputMethod == InputMethod.pdf && !_isPdfUploaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a PDF file')),
      );
      return;
    }

    if (_inputMethod == InputMethod.both &&
        _notesController.text.isEmpty &&
        !_isPdfUploaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide notes or upload a PDF')),
      );
      return;
    }

    setState(() => _isGenerating = true);

    // Simulate AI generation with PDF processing
    await Future.delayed(const Duration(seconds: 3));

    setState(() => _isGenerating = false);

    // Navigate to quiz preview or show success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quiz generated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _getRandomQuestion(int index) {
    final questions = [
      'What is the main concept discussed in the material?',
      'Which principle is most important in this topic?',
      'How does this relate to practical applications?',
      'What is the key takeaway from this section?',
      'Which statement best describes the concept?',
    ];
    return questions[index % questions.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Quiz Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              _showTipsBottomSheet(context);
            },
          ),
        ],
      ),
      body: _isGenerating
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                      Icon(
                        _isPdfUploaded
                            ? Icons.picture_as_pdf
                            : Icons.auto_awesome,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Generating your quiz...',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isPdfUploaded
                        ? 'AI is analyzing your PDF document'
                        : 'AI is analyzing your notes',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: LinearProgressIndicator(),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pro Tip Card
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Pro Tip',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Upload a PDF document or paste your study notes. AI will extract key concepts and generate intelligent questions!',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Topic Input
                  Text(
                    'Quiz Topic (Optional)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _topicController,
                    decoration: InputDecoration(
                      hintText: 'e.g., Machine Learning, Flutter Development',
                      prefixIcon: const Icon(Icons.topic),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Input Method Selector
                  Text(
                    'Choose Input Method',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<InputMethod>(
                    segments: const [
                      ButtonSegment(
                        value: InputMethod.text,
                        label: Text('Text'),
                        icon: Icon(Icons.text_fields),
                      ),
                      ButtonSegment(
                        value: InputMethod.pdf,
                        label: Text('PDF'),
                        icon: Icon(Icons.picture_as_pdf),
                      ),
                      ButtonSegment(
                        value: InputMethod.both,
                        label: Text('Both'),
                        icon: Icon(Icons.library_books),
                      ),
                    ],
                    selected: {_inputMethod},
                    onSelectionChanged: (Set<InputMethod> newSelection) {
                      setState(() => _inputMethod = newSelection.first);
                    },
                  ),
                  const SizedBox(height: 24),

                  // PDF Upload Section
                  if (_inputMethod == InputMethod.pdf ||
                      _inputMethod == InputMethod.both)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Upload PDF Document',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        if (!_isPdfUploaded)
                          GestureDetector(
                            onTap: _pickPDF,
                            child: Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer
                                    .withOpacity(0.3),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 48,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Tap to upload PDF',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Supports: .pdf files up to 10MB',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Card(
                            color: Colors.green.shade50,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.red.shade700,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _selectedFileName ?? 'Document.pdf',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Ready to process',
                                              style: TextStyle(
                                                color: Colors.green.shade700,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: _removePDF,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                      ],
                    ),

                  // Text Notes Section
                  if (_inputMethod == InputMethod.text ||
                      _inputMethod == InputMethod.both)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Your Study Notes',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _notesController,
                          maxLines: 8,
                          decoration: InputDecoration(
                            hintText:
                                'Paste your study notes, lecture content, or key concepts here...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .surfaceVariant
                                .withOpacity(0.3),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),

                  // Question Type
                  Text(
                    'Question Type',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Multiple Choice'),
                        selected: _selectedType == QuestionType.mcq,
                        onSelected: (selected) {
                          setState(() => _selectedType = QuestionType.mcq);
                        },
                        avatar: _selectedType == QuestionType.mcq
                            ? const Icon(Icons.check_circle, size: 18)
                            : null,
                      ),
                      ChoiceChip(
                        label: const Text('True/False'),
                        selected: _selectedType == QuestionType.trueFalse,
                        onSelected: (selected) {
                          setState(
                              () => _selectedType = QuestionType.trueFalse);
                        },
                        avatar: _selectedType == QuestionType.trueFalse
                            ? const Icon(Icons.check_circle, size: 18)
                            : null,
                      ),
                      ChoiceChip(
                        label: const Text('Short Answer'),
                        selected: _selectedType == QuestionType.shortAnswer,
                        onSelected: (selected) {
                          setState(
                              () => _selectedType = QuestionType.shortAnswer);
                        },
                        avatar: _selectedType == QuestionType.shortAnswer
                            ? const Icon(Icons.check_circle, size: 18)
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Difficulty Level
                  Text(
                    'Difficulty Level',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<Difficulty>(
                    segments: const [
                      ButtonSegment(
                        value: Difficulty.easy,
                        label: Text('Easy'),
                        icon: Icon(Icons.sentiment_satisfied),
                      ),
                      ButtonSegment(
                        value: Difficulty.medium,
                        label: Text('Medium'),
                        icon: Icon(Icons.sentiment_neutral),
                      ),
                      ButtonSegment(
                        value: Difficulty.hard,
                        label: Text('Hard'),
                        icon: Icon(Icons.sentiment_very_dissatisfied),
                      ),
                    ],
                    selected: {_selectedDifficulty},
                    onSelectionChanged: (Set<Difficulty> newSelection) {
                      setState(() => _selectedDifficulty = newSelection.first);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Number of Questions
                  Text(
                    'Number of Questions: $_questionCount',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Slider(
                    value: _questionCount.toDouble(),
                    min: 5,
                    max: 20,
                    divisions: 15,
                    label: _questionCount.toString(),
                    onChanged: (value) {
                      setState(() => _questionCount = value.toInt());
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '5 questions',
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12),
                      ),
                      Text(
                        '20 questions',
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Generate Button
                  ElevatedButton.icon(
                    onPressed: _generateQuiz,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Generate Quiz'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Info Card
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'AI will analyze your content and generate relevant questions automatically.',
                              style: TextStyle(
                                color: Colors.blue.shade900,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tips Section
                  _buildTipsSection(context),
                ],
              ),
            ),
    );
  }

  Widget _buildTipsSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.tips_and_updates,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Tips for Better Results',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTipItem(
                context,
                icon: Icons.description,
                title: 'Provide clear and detailed notes',
                description:
                    'More detailed content helps AI generate more accurate and relevant questions',
                color: Colors.blue,
              ),
              const SizedBox(height: 12),
              _buildTipItem(
                context,
                icon: Icons.emoji_objects,
                title: 'Specify key concepts',
                description:
                    'Highlight important topics you want to focus on in your quiz',
                color: Colors.orange,
              ),
              const SizedBox(height: 12),
              _buildTipItem(
                context,
                icon: Icons.shuffle,
                title: 'Mix question types',
                description:
                    'Combine MCQs, True/False, and Short Answer for comprehensive practice',
                color: Colors.purple,
              ),
              const SizedBox(height: 12),
              _buildTipItem(
                context,
                icon: Icons.trending_up,
                title: 'Progress gradually',
                description:
                    'Start with easier difficulty and increase complexity as you improve',
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pro Tip: Upload PDFs with structured content (headings, bullet points) for best results!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTipsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.lightbulb,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'How to Get Best Results',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailedTip(
                      context,
                      icon: Icons.description,
                      title: 'Provide Clear and Detailed Notes',
                      description:
                          'The more detailed your content, the better AI can understand context and generate accurate questions. Include definitions, examples, and explanations.',
                      examples: [
                        'Include key definitions and terminology',
                        'Add relevant examples and use cases',
                        'Explain concepts with context',
                      ],
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 20),
                    _buildDetailedTip(
                      context,
                      icon: Icons.emoji_objects,
                      title: 'Specify Key Concepts to Focus On',
                      description:
                          'Highlight the most important topics or concepts you want to master. This helps AI prioritize question generation around these areas.',
                      examples: [
                        'Use bold or headers for important topics',
                        'Create a bullet list of key concepts',
                        'Add notes about what to emphasize',
                      ],
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 20),
                    _buildDetailedTip(
                      context,
                      icon: Icons.shuffle,
                      title: 'Mix Different Question Types',
                      description:
                          'Using various question formats helps reinforce learning from different angles and keeps practice engaging.',
                      examples: [
                        'MCQs test recognition and recall',
                        'True/False verify understanding',
                        'Short answers test deeper comprehension',
                      ],
                      color: Colors.purple,
                    ),
                    const SizedBox(height: 20),
                    _buildDetailedTip(
                      context,
                      icon: Icons.trending_up,
                      title: 'Start Easy, Progress Gradually',
                      description:
                          'Build confidence by starting with easier questions, then increase difficulty as you master the material.',
                      examples: [
                        'Begin with Easy difficulty level',
                        'Review explanations after each quiz',
                        'Move to Medium/Hard when ready',
                      ],
                      color: Colors.green,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primaryContainer,
                            Theme.of(context).colorScheme.secondaryContainer,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.workspace_premium,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Pro Tips for PDFs',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildProTipItem(
                              'Use PDFs with clear structure and headings'),
                          _buildProTipItem(
                              'Ensure text is selectable (not scanned images)'),
                          _buildProTipItem(
                              'Combine PDF with additional notes for context'),
                          _buildProTipItem(
                              'Larger documents may take longer to process'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedTip(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required List<String> examples,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          ...examples.map((example) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        example,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildProTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
