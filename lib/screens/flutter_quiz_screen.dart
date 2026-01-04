// lib/screens/flutter_quiz_screen.dart
import 'dart:convert';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_guide/core/loads/notes_loaders.dart';
import 'package:flutter_guide/screens/notes_screen.dart';
import '../models/flutter_quiz.dart';

class FlutterQuizScreen extends StatefulWidget {
  const FlutterQuizScreen({super.key});

  @override
  State<FlutterQuizScreen> createState() => _FlutterQuizScreenState();
}

class _FlutterQuizScreenState extends State<FlutterQuizScreen> {
  late Future<QuizSet> _quizFuture;
  String _currentLevel = 'Beginner';
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedOption;
  bool _showFeedback = false;
  bool _isCorrect = false;
  bool _showCompletionPage = false;
  bool _isTransitioning = false; // New flag for transition state
  Set<int> _correctlyAnsweredIndices = {};

  late ConfettiController _confettiController;

  List<QuizQuestion> _shuffledQuestions = [];

  @override
  void initState() {
    super.initState();
    _quizFuture = NotesLoaders().loadQuiz();
    _confettiController = ConfettiController(duration: const Duration(seconds: 4));
    
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }



  void _shuffleAndReset(QuizSet quizSet) {
    final allQuestions = quizSet.questionsForLevel(_currentLevel);
    _shuffledQuestions = List.from(allQuestions)..shuffle(Random());
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _selectedOption = null;
      _showFeedback = false;
      _isCorrect = false;
      _showCompletionPage = false;
      _isTransitioning = false;
      _correctlyAnsweredIndices = {};
    });
  }

  void _changeLevel(String level, QuizSet quizSet) {
    setState(() {
      _currentLevel = level;
    });
    _shuffleAndReset(quizSet);
  }

  void _onOptionSelected(String value) {
    if (!_showFeedback) {
      setState(() {
        _selectedOption = value;
      });
    }
  }

  void _onNext(QuizSet quizSet) {
  if (_selectedOption == null) return;

  final currentQuestion = _shuffledQuestions[_currentIndex];
  final correct = currentQuestion.isCorrect(_selectedOption!);

  if (_showFeedback && !_isCorrect) {
    // This means user tapped "Try Again" after a wrong answer
    setState(() {
      _selectedOption = null;     // Clear selection so they can choose again
      _showFeedback = false;     // Hide feedback banner
      _isCorrect = false;        // Reset
    });
    return;
  }

  // First time checking the answer (or after reset)
  setState(() {
    _showFeedback = true;
    _isCorrect = correct;
  });

  if (correct) {
  // Only add score if this question wasn't already answered correctly
  if (!_correctlyAnsweredIndices.contains(_currentIndex)) {
    _correctlyAnsweredIndices.add(_currentIndex);
    _score++;
  }

  if (_currentIndex < _shuffledQuestions.length - 1) {
    setState(() {
      _isTransitioning = true;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _showFeedback = false;
        _isTransitioning = false;
      });
    });
  } else {
    setState(() {
      _isTransitioning = true;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _showCompletionPage = true;
        _isTransitioning = false;
      });
      _confettiController.play();
    });
  }
}
  // If incorrect → do nothing else (stay on question, feedback shown, wait for "Try Again")
}

  void _restart(QuizSet quizSet) {
    _shuffleAndReset(quizSet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFEFF),
      appBar: AppBar(
        title: const Text('Flutter Quiz'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1F2937),
      ),
      body: Stack(
        children: [
          FutureBuilder<QuizSet>(
            future: _quizFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text('Failed to load quiz'),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => setState(() => _quizFuture = NotesLoaders().loadQuiz()),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final quizSet = snapshot.data!;

              if (_shuffledQuestions.isEmpty) {
                _shuffledQuestions = List.from(quizSet.questionsForLevel(_currentLevel))..shuffle(Random());
              }

              if (_showCompletionPage) {
                final percent = (_score / _shuffledQuestions.length * 100).round();
                return _buildCompletionPage(_shuffledQuestions.length, percent, quizSet);
              }

              final question = _shuffledQuestions[_currentIndex];

              return Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLevelSelector(quizSet),
                    const SizedBox(height: 16),
                    _buildProgressHeader(_shuffledQuestions.length),
                    const SizedBox(height: 24),
                    _buildQuestionCard(question),
                    const SizedBox(height: 20),
                    _buildOptionsList(question),
                    if (_showFeedback) _buildFeedbackBanner(),
                    const Spacer(),
                    _buildBottomBar(quizSet, _shuffledQuestions.length),
                  ],
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -pi / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.3,
              shouldLoop: false,
            ),
          ),
          // Add this just before the closing ] of the Stack children
_buildTransitionOverlay(),
        ],
      ),
    );
  }

  // ── Existing helper widgets ──
  Widget _buildLevelSelector(QuizSet quizSet) {
    final levels = ['Beginner', 'Advanced', 'Interview Prep'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: levels.map((level) {
          final isSelected = level == _currentLevel;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(level),
              selected: isSelected,
              onSelected: (_) => _changeLevel(level, quizSet),
              selectedColor: const Color(0xFF667EEA),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF1F2937),
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: Colors.grey[200],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProgressHeader(int totalQuestions) {
    final current = _currentIndex + 1;
    return Row(
      children: [
        Text(
          'Question $current of $totalQuestions',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF4B5563)),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, size: 18, color: Color(0xFF6366F1)),
              const SizedBox(width: 4),
              Text('Score: $_score', style: const TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(QuizQuestion question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 24, offset: Offset(0, 10))],
      ),
      child: Text(
        question.question,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF111827), height: 1.5),
      ),
    );
  }

  Widget _buildOptionsList(QuizQuestion question) {
    return Column(
      children: question.options.map((opt) {
        final isSelected = _selectedOption == opt;
        final isCorrectAnswer = question.isCorrect(opt);
        final showCorrect = _showFeedback && isCorrectAnswer;
        final showIncorrect = _showFeedback && isSelected && !isCorrectAnswer;

        final bool isDisabled = _showFeedback && _isCorrect;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            color: showCorrect
                ? const Color(0xFFE6F7EE)
                : showIncorrect
                    ? const Color(0xFFFFE6E6)
                    : isSelected
                        ? const Color(0xFFEEF2FF)
                        : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: showCorrect
                  ? Colors.green
                  : showIncorrect
                      ? Colors.red
                      : isSelected
                          ? const Color(0xFF6366F1)
                          : const Color(0xFFE5E7EB),
              width: showCorrect || showIncorrect ? 2.5 : 1.8,
            ),
          ),
          child: RadioListTile<String>(
            value: opt,
            groupValue: _selectedOption,
            onChanged: isDisabled ? null : (value) => _onOptionSelected(value!),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    opt,
                    style: TextStyle(
                      fontSize: 15,
                      color: const Color(0xFF111827),
                      fontWeight: showCorrect || (isSelected && !_showFeedback)
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (showCorrect)
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                if (showIncorrect)
                  const Icon(Icons.cancel, color: Colors.red, size: 20),
              ],
            ),
            activeColor: const Color(0xFF6366F1),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeedbackBanner() {
    return AnimatedOpacity(
      opacity: _showFeedback ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 400),
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: _isCorrect ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _isCorrect ? Colors.green : Colors.red, width: 2),
        ),
        child: Row(
          children: [
            Icon(
              _isCorrect ? Icons.celebration_rounded : Icons.lightbulb_outline_rounded,
              color: _isCorrect ? Colors.green : Colors.orange[700],
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _isCorrect
                    ? 'Great job! That\'s correct.'
                    : 'Not quite. Try another option!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _isCorrect ? Colors.green[800] : Colors.red[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(QuizSet quizSet, int totalQuestions) {
  final isLast = _currentIndex == totalQuestions - 1;
  final canCheck = _selectedOption != null;

  String buttonText;
  IconData buttonIcon;

  if (_showFeedback) {
    if (_isCorrect) {
      buttonText = isLast ? 'Finish' : 'Next';
      buttonIcon = isLast ? Icons.flag_rounded : Icons.chevron_right_rounded;
    } else {
      buttonText = 'Try Again';
      buttonIcon = Icons.refresh_rounded;
    }
  } else {
    buttonText = isLast ? 'Finish' : 'Check Answer';
    buttonIcon = Icons.task_alt_rounded;
  }

  return Row(
    children: [
      Expanded(
        child: OutlinedButton.icon(
          onPressed: (_currentIndex > 0 && !_showFeedback) || (_showFeedback && !_isCorrect)
              ? () {
                  setState(() {
                    _currentIndex--;
                    _selectedOption = null;
                    _showFeedback = false;
                    _isCorrect = false;
                  });
                }
              : null,
          icon: const Icon(Icons.chevron_left_rounded),
          label: const Text('Previous'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: ElevatedButton.icon(
          onPressed: canCheck ? () => _onNext(quizSet) : null,
          icon: Icon(buttonIcon),
          label: Text(buttonText),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            disabledBackgroundColor: const Color(0xFFCBD5F5),
          ),
        ),
      ),
    ],
  );
}

  // ── New Completion Page ──
  Widget _buildCompletionPage(int totalQuestions, int percent, QuizSet quizSet) {
    String title;
    String message;
    IconData icon;
    Color iconColor;

    if (percent >= 80) {
      title = 'Congratulations!';
      message = 'You mastered the $_currentLevel level!\nKeep up the great work! 🚀';
      icon = Icons.emoji_events_rounded;
      iconColor = Colors.amber;
    } else if (percent >= 50) {
      title = 'Well Done!';
      message = 'Solid performance on $_currentLevel level.\nTry to improve your score next time!';
      icon = Icons.thumb_up_alt_rounded;
      iconColor = Colors.blue;
    } else {
      title = 'Good Effort!';
      message = 'You completed the $_currentLevel level.\nReview the concepts and try again!';
      icon = Icons.trending_up_rounded;
      iconColor = Colors.orange;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 80, color: iconColor),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Score: $_score / $totalQuestions ($percent%)',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(fontSize: 16, height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _restart(quizSet),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry Level'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _currentLevel = 'Beginner';
                      });
                      _restart(quizSet);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>NotesScreen()));
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Back to home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransitionOverlay() {
  if (!_isTransitioning) return const SizedBox.shrink();

  return Container(
    color: Colors.white.withOpacity(0.95),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated circular progress
          SizedBox(
            width: 180,
            height: 14,
            child: TweenAnimationBuilder<double>(
  tween: Tween(begin: 0.0, end: 1.0),
  duration: const Duration(milliseconds: 1400),
  builder: (context, value, _) {
    return // Replace the SizedBox with TweenAnimationBuilder content:
SizedBox(
  height: 14,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1400),
      builder: (context, value, _) {
        return FractionallySizedBox(
          widthFactor: value,
          child: Container(
            height: 14,
            color: const Color(0xFF6366F1),
          ),
        );
      },
    ),
  ),
);
  },
),
          ),
          const SizedBox(height: 32),
          const Text(
            'Great job! 🎉',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _currentIndex < _shuffledQuestions.length - 1
                ? 'Moving to next question...'
                : 'Finishing up...',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    ),
  );
}
}