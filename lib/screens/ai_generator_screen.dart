import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:quiz_ai/models/quiz_model.dart';
import 'package:quiz_ai/screens/quiz_preview_screen.dart';
import 'package:quiz_ai/screens/api_service.dart';

enum InputMethod { text, files, both }

class AIQuizGeneratorScreen extends StatefulWidget {
  const AIQuizGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<AIQuizGeneratorScreen> createState() => _AIQuizGeneratorScreenState();
}

class _AIQuizGeneratorScreenState extends State<AIQuizGeneratorScreen> {
  final _topicController = TextEditingController();
  final _notesController = TextEditingController();

  QuestionType _selectedType = QuestionType.mcq;
  Difficulty _selectedDifficulty = Difficulty.medium;
  int _questionCount = 5;
  InputMethod _inputMethod = InputMethod.text;
  bool _isGenerating = false;
  bool _isBackendConnected = false;

  List<PlatformFile> _pickedFiles = [];

  @override
  void initState() {
    super.initState();
    _checkBackendConnection();
  }

  @override
  void dispose() {
    _topicController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _checkBackendConnection() async {
    final isConnected = await ApiService.checkHealth();
    if (mounted) {
      setState(() {
        _isBackendConnected = isConnected;
      });

      if (!isConnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('⚠️ Backend is not running. Please start the server.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _pickedFiles.addAll(result.files);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('${result.files.length} file(s) uploaded successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _removeFile(int index) {
    setState(() => _pickedFiles.removeAt(index));
  }

  void _clearAllFiles() {
    setState(() => _pickedFiles.clear());
  }

  Future<String> _extractTextFromFiles() async {
    StringBuffer allText = StringBuffer();

    for (var file in _pickedFiles) {
      if (file.bytes != null) {
        if (file.extension == 'txt') {
          String text = utf8.decode(file.bytes!);
          allText.writeln('\n--- ${file.name} ---\n');
          allText.writeln(text);
        } else if (file.extension == 'pdf') {
          allText.writeln('\n--- ${file.name} (PDF content) ---\n');
          // TODO: Implement PDF extraction if needed
        }
      }
    }

    return allText.toString();
  }

  Future<void> _generateQuizWithBackend() async {
    if (_topicController.text.isEmpty &&
        _notesController.text.isEmpty &&
        _pickedFiles.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a topic, notes, or upload files'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() => _isGenerating = true);

    try {
      String? fileContent;
      if (_pickedFiles.isNotEmpty) {
        fileContent = await _extractTextFromFiles();
      }

      String questionType;
      switch (_selectedType) {
        case QuestionType.mcq:
          questionType = 'mcq';
          break;
        case QuestionType.trueFalse:
          questionType = 'trueFalse';
          break;
        case QuestionType.shortAnswer:
          questionType = 'shortAnswer';
          break;
      }

      final response = await ApiService.generateQuiz(
        topic: _topicController.text.isNotEmpty ? _topicController.text : null,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        fileContent: fileContent,
        questionType: questionType,
        difficulty: _selectedDifficulty.name,
        questionCount: _questionCount,
      );

      if (response['success'] == true) {
        List<dynamic> questionsJson = response['questions'];
        if (questionsJson.isEmpty) {
          throw Exception('No questions generated');
        }
        List<Question> questions = [];
        for (int i = 0; i < questionsJson.length; i++) {
          var q = questionsJson[i];
          questions.add(Question(
            id: '${DateTime.now().millisecondsSinceEpoch}_$i',
            text: q['question'] ?? 'Question text',
            type: _selectedType,
            options: _selectedType == QuestionType.trueFalse
                ? ['True', 'False']
                : List<String>.from(q['options'] ?? []),
            correctAnswerIndex: q['correctAnswerIndex'] ?? 0,
            explanation: q['explanation'] ?? '',
          ));
        }

        Quiz generatedQuiz = Quiz(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _topicController.text.isNotEmpty
              ? 'Quiz: ${_topicController.text}'
              : 'Generated Quiz',
          description: 'AI generated quiz via Backend',
          questions: questions,
          duration: _questionCount * 2,
          createdAt: DateTime.now(),
          createdBy: 'Backend AI',
          difficulty: _selectedDifficulty,
        );

        if (mounted) {
          setState(() => _isGenerating = false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => QuizPreviewScreen(quiz: generatedQuiz),
            ),
          );
        }
      } else {
        throw Exception(response['message'] ?? 'Failed to generate quiz');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGenerating = false);
        print('Error generating quiz: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _generateQuizWithBackend,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Quiz Generator (Backend)'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _isBackendConnected ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isBackendConnected ? Icons.cloud_done : Icons.cloud_off,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isBackendConnected ? 'Connected' : 'Offline',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkBackendConnection,
            tooltip: 'Check Connection',
          ),
        ],
      ),
      body:
          _isGenerating ? _buildLoadingScreen(context) : _buildFormUI(context),
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              Icon(
                Icons.auto_awesome,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Generating your quiz with Backend AI...',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Processing your content',
              style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: LinearProgressIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormUI(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildBackendStatusCard(),
          const SizedBox(height: 24),

          // Topic Input
          _buildSectionTitle('Quiz Topic'),
          TextField(
            controller: _topicController,
            decoration: InputDecoration(
              hintText: 'e.g., Machine Learning, Python Basics',
              prefixIcon: const Icon(Icons.topic),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 24),

          // Input Method Selection
          _buildSectionTitle('Input Method'),
          Wrap(
            spacing: 8,
            children: InputMethod.values.map((method) {
              return ChoiceChip(
                label: Text(method.name.toUpperCase()),
                selected: _inputMethod == method,
                onSelected: (_) => setState(() => _inputMethod = method),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Notes Section
          if (_inputMethod == InputMethod.text ||
              _inputMethod == InputMethod.both) ...[
            _buildSectionTitle('Study Notes (Optional)'),
            TextField(
              controller: _notesController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Paste your study notes or key concepts...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // File Upload Section
          if (_inputMethod == InputMethod.files ||
              _inputMethod == InputMethod.both) ...[
            _buildSectionTitle('Upload Files (Optional)'),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickFiles,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Pick Files'),
                ),
                const SizedBox(width: 12),
                if (_pickedFiles.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: _clearAllFiles,
                    icon: const Icon(Icons.delete),
                    label: const Text('Clear All'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                  ),
              ],
            ),
            if (_pickedFiles.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 8),
                  ..._pickedFiles.asMap().entries.map((entry) {
                    int index = entry.key;
                    var file = entry.value;
                    return ListTile(
                      leading: const Icon(Icons.insert_drive_file),
                      title: Text(file.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _removeFile(index),
                      ),
                    );
                  }),
                ],
              ),
            const SizedBox(height: 24),
          ],

          // Question Type
          _buildSectionTitle('Question Type'),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Multiple Choice'),
                selected: _selectedType == QuestionType.mcq,
                onSelected: (selected) =>
                    setState(() => _selectedType = QuestionType.mcq),
              ),
              ChoiceChip(
                label: const Text('True/False'),
                selected: _selectedType == QuestionType.trueFalse,
                onSelected: (selected) =>
                    setState(() => _selectedType = QuestionType.trueFalse),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Difficulty
          _buildSectionTitle('Difficulty Level'),
          SegmentedButton<Difficulty>(
            segments: const [
              ButtonSegment(value: Difficulty.easy, label: Text('Easy')),
              ButtonSegment(value: Difficulty.medium, label: Text('Medium')),
              ButtonSegment(value: Difficulty.hard, label: Text('Hard')),
            ],
            selected: {_selectedDifficulty},
            onSelectionChanged: (Set<Difficulty> newSelection) {
              setState(() => _selectedDifficulty = newSelection.first);
            },
          ),
          const SizedBox(height: 24),

          // Number of Questions
          _buildSectionTitle('Number of Questions: $_questionCount'),
          Slider(
            value: _questionCount.toDouble(),
            min: 5,
            max: 20,
            divisions: 15,
            label: _questionCount.toString(),
            onChanged: (value) =>
                setState(() => _questionCount = value.toInt()),
          ),
          const SizedBox(height: 32),

          // Generate Button
          ElevatedButton.icon(
            onPressed: _isGenerating || !_isBackendConnected
                ? null
                : _generateQuizWithBackend,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Generate Quiz with Backend'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackendStatusCard() {
    return Card(
      color: _isBackendConnected ? Colors.green.shade50 : Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              _isBackendConnected ? Icons.check_circle : Icons.warning,
              color: _isBackendConnected ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _isBackendConnected
                    ? 'Backend connected - Using FastAPI + Gemini'
                    : 'Backend offline - Please start your FastAPI server',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
