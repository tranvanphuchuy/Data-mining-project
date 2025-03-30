import 'dart:math';

class Question {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String? hint;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.hint,
  });
}

class Questions {
  static final List<Question> _allQuestions = [
    Question(
      question: "What year was LSU founded?",
      options: ["1853", "1860", "1870", "1880"],
      correctAnswer: 0,
      hint: "LSU was established during the mid-19th century.",
    ),
    Question(
      question: "What is LSU's official mascot?",
      options: ["Tiger", "Lion", "Panther", "Wildcat"],
      correctAnswer: 0,
      hint: "The mascot is known for its distinctive purple and gold colors.",
    ),
    Question(
      question: "What is the name of LSU's football stadium?",
      options: ["Tiger Stadium", "Death Valley", "Mike the Tiger Stadium", "Louisiana Stadium"],
      correctAnswer: 0,
      hint: "It's known as 'Death Valley' to visiting teams.",
    ),
    Question(
      question: "What is LSU's official school color?",
      options: ["Purple and Gold", "Blue and White", "Red and Black", "Green and Yellow"],
      correctAnswer: 0,
      hint: "The colors are royal purple and old gold.",
    ),
    Question(
      question: "What is the name of LSU's student newspaper?",
      options: ["The Daily Reveille", "The Tiger", "The LSU Times", "The Louisiana News"],
      correctAnswer: 0,
      hint: "It's been published since 1887.",
    ),
    Question(
      question: "What is the name of LSU's main library?",
      options: ["Middleton Library", "Hill Memorial Library", "LSU Library", "Tiger Library"],
      correctAnswer: 0,
      hint: "It's named after a former LSU president.",
    ),
    Question(
      question: "What is the name of LSU's student union?",
      options: ["Student Union", "LSU Union", "Tiger Union", "Union Square"],
      correctAnswer: 0,
      hint: "It's the center of student life on campus.",
    ),
    Question(
      question: "What is LSU's official fight song?",
      options: ["Fight for LSU", "Tiger Rag", "LSU Fight Song", "Geaux Tigers"],
      correctAnswer: 0,
      hint: "It's played at every LSU sporting event.",
    ),
    Question(
      question: "What is the name of LSU's mascot tiger?",
      options: ["Mike the Tiger", "Tiger Mike", "LSU Mike", "King Mike"],
      correctAnswer: 0,
      hint: "The current Mike is Mike VII.",
    ),
    Question(
      question: "What is LSU's official motto?",
      options: ["Love Purple, Live Gold", "Geaux Tigers", "Fight for LSU", "Tiger Pride"],
      correctAnswer: 0,
      hint: "It's a popular phrase among LSU fans.",
    ),
  ];

  static Question getRandomQuestion() {
    final random = Random();
    return _allQuestions[random.nextInt(_allQuestions.length)];
  }

  static Question getQuestion(int floor, int section) {
    return getRandomQuestion();
  }
} 