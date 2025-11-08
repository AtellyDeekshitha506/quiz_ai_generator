import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.9:8000";

  // Change for production

  // ============================================
  // AUTHENTICATION METHODS
  // ============================================

  /// Register new user
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'role': role,
            }),
          )
          .timeout(const Duration(minutes: 5));

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);
        return {'success': true, 'data': data};
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'error': error['detail'] ?? 'Registration failed'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  /// Login user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(minutes: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);
        return {'success': true, 'data': data};
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'error': error['detail'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  /// Get current user info
  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {'success': false, 'error': 'No token found'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': 'Failed to get user'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  /// Logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // ============================================
  // QUIZ GENERATION METHODS
  // ============================================

  /// Generate quiz using the backend API
  static Future<Map<String, dynamic>> generateQuiz({
    String? topic,
    String? notes,
    String? fileContent,
    required String questionType,
    required String difficulty,
    required int questionCount,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {'success': false, 'error': 'Not authenticated'};
      }

      // Build the comprehensive prompt
      String prompt = _buildPrompt(
        topic: topic,
        notes: notes,
        fileContent: fileContent,
        questionType: questionType,
        difficulty: difficulty,
        questionCount: questionCount,
      );

      print('📤 Sending to backend: ${prompt.substring(0, 100)}...');

      // Send request with authentication
      final response = await http
          .post(
            Uri.parse('$baseUrl/chat'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'prompt': prompt,
            }),
          )
          .timeout(const Duration(minutes: 3));

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Received quiz, parsing...');

        // Parse the quiz response
        return _parseQuizResponse(data['quiz'], questionType);
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'error': 'Authentication failed. Please login again.'
        };
      } else if (response.statusCode == 422) {
        print('❌ 422 Error - Body: ${response.body}');
        return {
          'success': false,
          'error': 'Validation error: ${response.body}'
        };
      } else if (response.statusCode == 429) {
        return {
          'success': false,
          'error': 'Rate limit exceeded. Please try again later.'
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to generate quiz: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('❌ Error in generateQuiz: $e');
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  // ============================================
  // HELPER METHODS
  // ============================================

  /// Build a comprehensive prompt from all inputs
  static String _buildPrompt({
    String? topic,
    String? notes,
    String? fileContent,
    required String questionType,
    required String difficulty,
    required int questionCount,
  }) {
    StringBuffer prompt = StringBuffer();

    prompt.writeln('Generate a quiz with the following specifications:\n');

    // Difficulty and count
    prompt.writeln('- Difficulty: $difficulty');
    prompt.writeln('- Number of questions: $questionCount');

    // Question type
    if (questionType == 'mcq') {
      prompt.writeln(
          '- Question type: Multiple Choice (provide 4 options for each question)');
    } else if (questionType == 'trueFalse') {
      prompt.writeln('- Question type: True/False');
    } else if (questionType == 'shortAnswer') {
      prompt.writeln('- Question type: Short Answer');
    }

    // Topic
    if (topic != null && topic.isNotEmpty) {
      prompt.writeln('\nTopic: $topic');
    }

    // Notes
    if (notes != null && notes.isNotEmpty) {
      prompt.writeln('\nStudy Notes to base questions on:\n$notes');
    }

    // File content
    if (fileContent != null && fileContent.isNotEmpty) {
      prompt.writeln('\nAdditional content from uploaded files:\n$fileContent');
    }

    // Format instructions
    prompt.writeln('\n--- IMPORTANT: Response Format ---');
    prompt.writeln(
        'You must respond with ONLY a valid JSON object in this exact format:');
    prompt.writeln('''
{
  "questions": [
    {
      "question": "What is the question text?",
      "options": ["Option A", "Option B", "Option C", "Option D"],
      "correctAnswerIndex": 0,
      "explanation": "Why this answer is correct"
    }
  ]
}
''');
    prompt.writeln('\nDo not include any text before or after the JSON.');
    prompt.writeln('For True/False questions, use options: ["True", "False"]');
    if (questionType == 'shortAnswer') {
      prompt.writeln(
          'For Short Answer questions, omit the "options" field and use "correctAnswer" instead of "correctAnswerIndex".');
    }

    return prompt.toString();
  }

  /// Parse the quiz response from AI
  static Map<String, dynamic> _parseQuizResponse(
      String quizText, String questionType) {
    try {
      print('🔍 Parsing quiz response...');

      String jsonStr = quizText.trim();

      // Remove markdown code blocks if present
      if (jsonStr.contains('```json')) {
        jsonStr = jsonStr.substring(jsonStr.indexOf('```json') + 7);
        jsonStr = jsonStr.substring(0, jsonStr.indexOf('```'));
      } else if (jsonStr.contains('```')) {
        jsonStr = jsonStr.substring(jsonStr.indexOf('```') + 3);
        jsonStr = jsonStr.substring(0, jsonStr.lastIndexOf('```'));
      }

      jsonStr = jsonStr.trim();

      final parsed = jsonDecode(jsonStr);

      if (parsed is Map && parsed.containsKey('questions')) {
        print('✅ Found ${parsed['questions'].length} questions');
        return {
          'success': true,
          'questions': parsed['questions'],
        };
      } else {
        throw Exception('Invalid response format - missing "questions" key');
      }
    } catch (e) {
      print('❌ Parsing error: $e');

      return {
        'success': false,
        'error': 'Failed to parse quiz response: $e',
        'raw_response': quizText,
      };
    }
  }

  /// Check if backend is running
  static Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/'),
          )
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Health check failed: $e');
      return false;
    }
  }

  // ============================================
  // TOKEN MANAGEMENT (PRIVATE)
  // ============================================

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<String?> getToken() async {
    return await _getToken();
  }
}
