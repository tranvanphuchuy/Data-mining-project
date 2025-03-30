import 'dart:math';

class Question {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String? hint;

  const Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.hint,
  });
}

class Questions {
  static Question getQuestion(int floor, int section, int questionNumber) {
    final key = '${floor}_${section}_$questionNumber';
    return _questions[key] ?? _defaultQuestion;
  }

  static final Map<String, Question> _questions = {
    // Floor 1 Questions
    '1_0_0': Question(
      question: 'What is the name of LSU\'s student union?',
      options: [
        'Student Union',
        'LSU Union',
        'Tiger Union',
        'Louisiana Union'
      ],
      correctAnswer: 1,
      hint: 'It\'s officially named after the university',
    ),
    '1_0_1': Question(
      question: 'What restaurant is located in the LSU Student Union?',
      options: [
        'McDonald\'s',
        'Panda Express',
        'Chick-fil-A',
        'Subway'
      ],
      correctAnswer: 2,
      hint: 'Famous for their chicken sandwiches',
    ),
    '1_1_0': Question(
      question: 'What is the name of the computer lab in PFT?',
      options: [
        'Tiger Lab',
        'Campus Computer Lab',
        'Engineering Lab',
        'LSU Lab'
      ],
      correctAnswer: 1,
      hint: 'Look at the map for this one',
    ),
    '1_1_1': Question(
      question: 'What type of space is available in PFT for senior projects?',
      options: [
        'Study Room',
        'Meeting Room',
        'Capstone Design Space',
        'Workshop'
      ],
      correctAnswer: 2,
      hint: 'It\'s specifically for final year projects',
    ),
    '1_2_0': Question(
      question: 'Which engineering discipline has labs on the first floor?',
      options: [
        'Chemical Engineering',
        'Computer Engineering',
        'Mechanical Engineering',
        'Electrical Engineering'
      ],
      correctAnswer: 3,
      hint: 'These labs often deal with circuits',
    ),
    '1_2_1': Question(
      question: 'What is the name of the central area in PFT first floor?',
      options: [
        'Central Hall',
        'Main Atrium',
        'Commons Area',
        'Student Lounge'
      ],
      correctAnswer: 1,
      hint: 'It\'s a large open space in the middle',
    ),
    '1_3_0': Question(
      question: 'What type of classroom is available for computer science students?',
      options: [
        'Regular Classroom',
        'Computer Lab',
        'Modular Classroom',
        'Lecture Hall'
      ],
      correctAnswer: 2,
      hint: 'Students need computers for programming',
    ),
    '1_3_1': Question(
      question: 'What facility is located at the end of the first floor?',
      options: [
        'Cafeteria',
        'Library',
        'Auditorium',
        'Study Room'
      ],
      correctAnswer: 2,
      hint: 'It\'s a large space for presentations',
    ),

    // Floor 2 Questions
    '2_0_0': Question(
      question: 'What is the name of the main office on the second floor?',
      options: [
        'Administrative Office',
        'Main Office',
        'PFT Office',
        'LSU Office',
      ],
      correctAnswer: 0,
      hint: 'It\'s where administrative staff work.',
    ),
    '2_0_1': Question(
      question: 'What color is the carpet in the administrative office?',
      options: [
        'Red',
        'Purple',
        'Gray',
        'Blue',
      ],
      correctAnswer: 2,
      hint: 'It\'s a neutral color.',
    ),
    '2_1_0': Question(
      question: 'What is the name of the conference room?',
      options: [
        'Tiger Room',
        'LSU Room',
        'Conference Room',
        'Meeting Room',
      ],
      correctAnswer: 2,
      hint: 'It\'s a standard name for a meeting space.',
    ),
    '2_1_1': Question(
      question: 'How many chairs are in the conference room?',
      options: [
        '8',
        '10',
        '12',
        '14',
      ],
      correctAnswer: 2,
      hint: 'It\'s a standard conference room size.',
    ),
    '2_2_0': Question(
      question: 'What is the name of the fitness studio?',
      options: [
        'Tiger Studio',
        'LSU Studio',
        'Fitness Studio',
        'PFT Studio',
      ],
      correctAnswer: 2,
      hint: 'It\'s a general fitness space.',
    ),
    '2_2_1': Question(
      question: 'What type of flooring is in the fitness studio?',
      options: [
        'Wood',
        'Carpet',
        'Rubber',
        'Tile',
      ],
      correctAnswer: 2,
      hint: 'It\'s designed for exercise.',
    ),
    '2_3_0': Question(
      question: 'What is the name of the equipment storage room?',
      options: [
        'Storage Room',
        'Equipment Room',
        'Supply Room',
        'Gear Room',
      ],
      correctAnswer: 1,
      hint: 'It\'s where equipment is kept.',
    ),
    '2_3_1': Question(
      question: 'What color are the storage shelves?',
      options: [
        'Red',
        'Purple',
        'Gray',
        'Black',
      ],
      correctAnswer: 2,
      hint: 'It\'s a neutral color.',
    ),

    // Floor 3 Questions
    '3_0_0': Question(
      question: 'What is the name of the main classroom on the third floor?',
      options: [
        'Lecture Hall',
        'Main Classroom',
        'PFT Classroom',
        'LSU Classroom',
      ],
      correctAnswer: 0,
      hint: 'It\'s a large teaching space.',
    ),
    '3_0_1': Question(
      question: 'How many seats are in the lecture hall?',
      options: [
        '50',
        '75',
        '100',
        '125',
      ],
      correctAnswer: 2,
      hint: 'It\'s a standard lecture hall size.',
    ),
    '3_1_0': Question(
      question: 'What is the name of the computer lab?',
      options: [
        'Computer Lab',
        'Tech Lab',
        'Digital Lab',
        'IT Lab',
      ],
      correctAnswer: 0,
      hint: 'It\'s a standard name for a computer space.',
    ),
    '3_1_1': Question(
      question: 'How many computers are in the lab?',
      options: [
        '15',
        '20',
        '25',
        '30',
      ],
      correctAnswer: 2,
      hint: 'It\'s a standard computer lab size.',
    ),
    '3_2_0': Question(
      question: 'What is the name of the study area?',
      options: [
        'Study Room',
        'Learning Space',
        'Quiet Area',
        'Reading Room',
      ],
      correctAnswer: 0,
      hint: 'It\'s a space for studying.',
    ),
    '3_2_1': Question(
      question: 'What type of lighting is in the study area?',
      options: [
        'Fluorescent',
        'LED',
        'Natural',
        'Mixed',
      ],
      correctAnswer: 3,
      hint: 'It uses multiple types of lighting.',
    ),
    '3_3_0': Question(
      question: 'What is the name of the faculty office area?',
      options: [
        'Faculty Offices',
        'Teacher Offices',
        'Staff Offices',
        'Admin Offices',
      ],
      correctAnswer: 0,
      hint: 'It\'s where faculty members work.',
    ),
    '3_3_1': Question(
      question: 'How many faculty offices are there?',
      options: [
        '5',
        '8',
        '10',
        '12',
      ],
      correctAnswer: 2,
      hint: 'It\'s a standard number of offices.',
    ),
  };

  static const Question _defaultQuestion = Question(
    question: 'Question not found',
    options: ['Error', 'Error', 'Error', 'Error'],
    correctAnswer: 0,
  );
} 