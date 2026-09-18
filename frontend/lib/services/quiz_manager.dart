import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/quiz_data.dart';

class QuizManager {
  QuizManager({required this.data, required this.preferences, Random? random})
    : _random = random ?? Random();

  static const int questionsPerSession = 25;
  static const String _cycleHistoryKey = 'quiz_cycle_history_v2';

  final QuizData data;
  final SharedPreferences preferences;
  final Random _random;
  List<QuizQuestion> _sessionQuestions = [];
  List<QuizCategory> _sessionCategories = [];
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;

  QuizCategory? get currentCategory => _currentCategory;
  QuizCategory? _currentCategory;
  List<QuizQuestion> get sessionQuestions =>
      List.unmodifiable(_sessionQuestions);
  int get currentIndex => _currentIndex;
  int get score => _score;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  bool get hasSession => _sessionQuestions.isNotEmpty;
  QuizQuestion? get currentQuestion =>
      hasSession ? _sessionQuestions[_currentIndex] : null;
  bool get isLastQuestion =>
      hasSession && _currentIndex == _sessionQuestions.length - 1;

  Future<void> startRandomQuiz() async {
    final allQuestions = [
      for (final category in data.categories)
        for (final question in category.questions)
          (category: category, question: question),
    ];
    if (allQuestions.isEmpty) return;

    var cycleHistory = _loadCycleHistory();
    final randomMode = cycleHistory.length >= allQuestions.length;
    if (randomMode) {
      cycleHistory = [];
    }

    final historyKeys = cycleHistory.toSet();
    final available =
        allQuestions
            .where((entry) => !historyKeys.contains(_questionKey(entry)))
            .toList()
          ..shuffle(_random);
    final selected = <({QuizCategory category, QuizQuestion question})>[];
    final selectedKeys = <String>{};

    void addFrom(
      Iterable<({QuizCategory category, QuizQuestion question})> entries,
    ) {
      for (final entry in entries) {
        if (selected.length == questionsPerSession) break;
        if (selectedKeys.add(_questionKey(entry))) selected.add(entry);
      }
    }

    addFrom(available);

    // The third 25-question session has 21 new questions left, so fill the
    // remaining slots with questions from the first session only.
    if (selected.length < questionsPerSession && cycleHistory.length >= 50) {
      final firstSessionKeys = cycleHistory.take(questionsPerSession).toSet();
      final firstSessionQuestions =
          allQuestions
              .where((entry) => firstSessionKeys.contains(_questionKey(entry)))
              .toList()
            ..shuffle(_random);
      addFrom(firstSessionQuestions);
    }

    if (selected.isEmpty) return;
    _sessionQuestions = selected.map((entry) => entry.question).toList();
    _sessionCategories = selected.map((entry) => entry.category).toList();
    _currentCategory = _sessionCategories.first;
    _currentIndex = 0;
    _score = 0;
    _selectedAnswerIndex = null;
    if (!randomMode) {
      cycleHistory.addAll(
        selected.map(_questionKey).where((key) => !cycleHistory.contains(key)),
      );
      await preferences.setStringList(_cycleHistoryKey, cycleHistory);
    }
  }

  Future<void> selectAnswer(int answerIndex) async {
    if (_selectedAnswerIndex != null || currentQuestion == null) return;
    _selectedAnswerIndex = answerIndex;
    if (answerIndex == currentQuestion!.answerIndex) _score++;
  }

  Future<bool> nextQuestion() async {
    if (!hasSession || _selectedAnswerIndex == null) return false;
    if (isLastQuestion) return true;

    _currentIndex++;
    _currentCategory = _sessionCategories[_currentIndex];
    _selectedAnswerIndex = null;
    return false;
  }

  void resetSession() {
    _sessionQuestions = [];
    _sessionCategories = [];
    _currentCategory = null;
    _currentIndex = 0;
    _score = 0;
    _selectedAnswerIndex = null;
  }

  List<String> _loadCycleHistory() {
    return preferences.getStringList(_cycleHistoryKey) ?? <String>[];
  }

  String _questionKey(({QuizCategory category, QuizQuestion question}) entry) =>
      '${entry.category.id}:${entry.question.id}';
}
