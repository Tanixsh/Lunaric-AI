import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

const api = 'https://lunaric-ai-4.onrender.com';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lunaric AI',
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xff0a0a11),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff8b7cff),
            brightness: Brightness.dark,
          ),
        ),
        home: const Start(),
      );
}

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool login = false;

  void enter() {
    if ([name.text, email.text, password.text]
        .any((x) => x.trim().isEmpty)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Fill in all fields.')));
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Home(name: name.text.trim())),
    );
  }

  Widget field(
    TextEditingController c,
    String hint,
    IconData icon, {
    bool hide = false,
  }) {
    return TextField(
      controller: c,
      obscureText: hide,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xff15151f),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🌙', style: TextStyle(fontSize: 42)),
                  const SizedBox(height: 20),
                  Text(
                    login ? 'Welcome back.' : 'Welcome to Lunaric.',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    login
                        ? 'Sign in and continue learning.'
                        : 'Your AI companion for learning, exams and Olympiads.',
                    style: const TextStyle(
                      color: Colors.white60,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (!login) ...[
                    field(name, 'Name', Icons.person_outline),
                    const SizedBox(height: 12),
                  ],
                  field(email, 'Email', Icons.mail_outline),
                  const SizedBox(height: 12),
                  field(
                    password,
                    'Password',
                    Icons.lock_outline,
                    hide: true,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      onPressed: enter,
                      child: Text(login ? 'Sign in' : 'Create account'),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () => setState(() => login = !login),
                      child: Text(
                        login
                            ? 'New to Lunaric? Create an account'
                            : 'Already have an account? Sign in',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class Home extends StatelessWidget {
  final String name;

  const Home({super.key, required this.name});

  Widget card(
    BuildContext context,
    IconData icon,
    String title,
    String sub,
    Widget page,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        ),
        child: Container(
          height: 145,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xff15151f),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 27),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sub,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🌙 Lunaric',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 35),
                Text(
                  'Hey, $name 👋',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'What are we learning today?',
                  style: TextStyle(color: Colors.white60),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    card(
                      context,
                      Icons.chat_bubble_outline,
                      'Chat',
                      'Talk to Lunaric',
                      const ChatPage(),
                    ),
                    const SizedBox(width: 12),
                    card(
                      context,
                      Icons.menu_book_outlined,
                      'Study',
                      'Learn smarter',
                      const StudySetup(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    card(
                      context,
                      Icons.emoji_events_outlined,
                      'Olympiad',
                      'Train harder',
                      const OlympiadSetup(),
                    ),
                    const SizedBox(width: 12),
                    card(
                      context,
                      Icons.image_outlined,
                      'Analyze',
                      'Ask about images',
                      const AnalyzePage(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final input = TextEditingController();
  final messages = <Map<String, String>>[];
  bool loading = false;

  Future<void> send() async {
    final text = input.text.trim();

    if (text.isEmpty || loading) return;

    setState(() {
      messages.add({'role': 'user', 'text': text});
      loading = true;
    });

    input.clear();

    try {
      final r = await http.post(
        Uri.parse('$api/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': text}),
      );

      final data = jsonDecode(r.body);

      setState(() {
        messages.add({
          'role': 'ai',
          'text': r.statusCode == 200
              ? data['reply'] ?? 'No response.'
              : 'Backend error: ${r.statusCode}',
        });
      });
    } catch (_) {
      setState(() {
        messages.add({
          'role': 'ai',
          'text': 'Could not connect to Lunaric.',
        });
      });
    }

    setState(() => loading = false);
  }

  void copy(String text) {
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied 📋')),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Lunaric')),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (_, i) {
                  final m = messages[i];
                  final user = m['role'] == 'user';

                  return Align(
                    alignment:
                        user ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 650),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: user
                            ? const Color(0xff2b2848)
                            : const Color(0xff15151f),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: user
                          ? Text(m['text'] ?? '')
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MarkdownBody(
                                  data: m['text'] ?? '',
                                  selectable: true,
                                  styleSheet: MarkdownStyleSheet(
                                    p: const TextStyle(
                                      fontSize: 15,
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    onPressed: () =>
                                        copy(m['text'] ?? ''),
                                    icon: const Icon(
                                      Icons.copy_rounded,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
            ),
            if (loading)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Lunaric is thinking...',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: input,
                        minLines: 1,
                        maxLines: 5,
                        onSubmitted: (_) => send(),
                        decoration: InputDecoration(
                          hintText: 'Ask Lunaric...',
                          filled: true,
                          fillColor: const Color(0xff171722),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: loading ? null : send,
                      icon: const Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

class StudySetup extends StatefulWidget {
  const StudySetup({super.key});

  @override
  State<StudySetup> createState() => _StudySetupState();
}

class _StudySetupState extends State<StudySetup> {
  String grade = 'Class 9';
  String board = 'ICSE';
  String subject = 'Physics';
  String topic = '';
  String goal = 'Learn';

  List<String> topics = [];
  bool loading = false;

  final grades = [
    ...List.generate(12, (i) => 'Class ${i + 1}'),
    'College / University',
    'Other',
  ];

  final boards = [
    'ICSE',
    'CBSE',
    'IGCSE',
    'State Board',
    'Other',
  ];

  final subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'History',
    'Civics',
    'Geography',
    'English',
    'Computer Science',
    'AI & Robotics',
    'Other',
  ];

  final goals = [
    'Learn',
    'Homework',
    'Revise',
    'Quiz',
    'Notes',
    'Exam Prep',
  ];

  final custom = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTopics();
  }

  Future<void> loadTopics() async {
    setState(() {
      loading = true;
      topic = '';
      topics = [];
    });

    try {
      final r = await http.post(
        Uri.parse('$api/topics'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'selected_class': grade,
          'curriculum': board,
          'subject': subject,
        }),
      );

      if (r.statusCode == 200) {
        final data = jsonDecode(r.body);
        topics = List<String>.from(data['topics'] ?? []);
      } else {
        topics = ['Other / Custom Topic'];
      }
    } catch (_) {
      topics = ['Other / Custom Topic'];
    }

    setState(() => loading = false);
  }

  void start() {
    final t =
        topic == 'Other / Custom Topic' ? custom.text.trim() : topic;

    if (t.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a topic first.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudySession(
          grade: grade,
          board: board,
          subject: subject,
          topic: t,
          goal: goal,
        ),
      ),
    );
  }

  Widget chips(
    List<String> items,
    String value,
    void Function(String) pick,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (x) => ChoiceChip(
              label: Text(x),
              selected: x == value,
              onSelected: (_) => pick(x),
            ),
          )
          .toList(),
    );
  }

  InputDecoration inputDecoration({String? hint}) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xff15151f),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide.none,
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Study Mode')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📚 Let’s study',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                '🎓 Class',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: grade,
                items: grades
                    .map(
                      (x) => DropdownMenuItem(
                        value: x,
                        child: Text(x),
                      ),
                    )
                    .toList(),
                onChanged: (x) {
                  grade = x!;
                  setState(() {});
                  loadTopics();
                },
                decoration: inputDecoration(),
              ),
              const SizedBox(height: 22),
              const Text(
                '🏫 Curriculum',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              chips(
                boards,
                board,
                (x) {
                  setState(() => board = x);
                  loadTopics();
                },
              ),
              const SizedBox(height: 22),
              const Text(
                '📖 Subject',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              chips(
                subjects,
                subject,
                (x) {
                  setState(() => subject = x);
                  loadTopics();
                },
              ),
              const SizedBox(height: 22),
              const Text(
                '📘 Chapter / Topic',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              loading
                  ? const Row(
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('Checking curriculum...'),
                      ],
                    )
                  : DropdownButtonFormField(
                      value: topic.isEmpty ? null : topic,
                      hint: const Text('Select a topic'),
                      items: topics
                          .map(
                            (x) => DropdownMenuItem(
                              value: x,
                              child: Text(x),
                            ),
                          )
                          .toList(),
                      onChanged: (x) =>
                          setState(() => topic = x!),
                      decoration: inputDecoration(),
                    ),
              if (topic == 'Other / Custom Topic') ...[
                const SizedBox(height: 10),
                TextField(
                  controller: custom,
                  decoration: inputDecoration(
                    hint: 'Enter your topic',
                  ),
                ),
              ],
              const SizedBox(height: 22),
              const Text(
                '🎯 Goal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              chips(
                goals,
                goal,
                (x) => setState(() => goal = x),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: start,
                  child: const Text(
                    'Start Study',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class StudySession extends StatefulWidget {
  final String grade;
  final String board;
  final String subject;
  final String topic;
  final String goal;

  const StudySession({
    super.key,
    required this.grade,
    required this.board,
    required this.subject,
    required this.topic,
    required this.goal,
  });

  @override
  State<StudySession> createState() => _StudySessionState();
}

class _StudySessionState extends State<StudySession> {
  String result = '';
  bool loading = false;

  Future<void> start() async {
    setState(() {
      loading = true;
      result = '';
    });

    final prompt = '''
You are Lunaric Study Mode.

Class: ${widget.grade}
Curriculum: ${widget.board}
Subject: ${widget.subject}
Topic: ${widget.topic}
Goal: ${widget.goal}

Teach the student at the correct level.

Learn: explain clearly with examples.
Homework: help step by step.
Revise: create concise revision material.
Quiz: create a quiz and wait for answers.
Notes: make organized notes.
Exam Prep: focus on important concepts and exam-style preparation.

Use clean Markdown.
''';

    try {
      final r = await http.post(
        Uri.parse('$api/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': prompt}),
      );

      final data = jsonDecode(r.body);

      setState(() {
        result = r.statusCode == 200
            ? data['reply'] ?? 'No response.'
            : 'Backend error: ${r.statusCode}';
      });
    } catch (_) {
      setState(() {
        result = 'Could not connect to Lunaric.';
      });
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Study Session')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.subject,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${widget.grade} • ${widget.board}',
                style: const TextStyle(color: Colors.white54),
              ),
              Text(
                '${widget.topic} • ${widget.goal}',
                style: const TextStyle(color: Colors.white38),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xff111118),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: result.isEmpty
                    ? const Text(
                        'Press Start Session to begin.',
                        style: TextStyle(color: Colors.white54),
                      )
                    : MarkdownBody(
                        data: result,
                        selectable: true,
                        styleSheet: MarkdownStyleSheet(
                          p: const TextStyle(
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: loading ? null : start,
                  child: Text(
                    loading
                        ? 'Lunaric is preparing...'
                        : 'Start Session',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class OlympiadSetup extends StatefulWidget {
  const OlympiadSetup({super.key});

  @override
  State<OlympiadSetup> createState() => _OlympiadSetupState();
}

class _OlympiadSetupState extends State<OlympiadSetup> {
  final subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'Computer Science',
    'AI & Robotics',
    'History',
    'Geography',
    'Civics',
  ];

  final selected = <String>{};
  String difficulty = 'Olympiad';
  String style = 'Adaptive';

  Widget chips(
    List<String> items,
    String value,
    void Function(String) pick,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (x) => ChoiceChip(
              label: Text(x),
              selected: x == value,
              onSelected: (_) => pick(x),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Olympiad Training')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🏆 Build your training session',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Subjects',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: subjects.map((x) {
                  return FilterChip(
                    label: Text(x),
                    selected: selected.contains(x),
                    onSelected: (v) => setState(() {
                      v ? selected.add(x) : selected.remove(x);
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 25),
              const Text(
                'Difficulty',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              chips(
                [
                  'Beginner',
                  'Intermediate',
                  'Advanced',
                  'Olympiad',
                ],
                difficulty,
                (x) => setState(() => difficulty = x),
              ),
              const SizedBox(height: 25),
              const Text(
                'Question style',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              chips(
                [
                  'Mixed',
                  'Subject Focused',
                  'Adaptive',
                ],
                style,
                (x) => setState(() => style = x),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: selected.isEmpty
                      ? null
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OlympiadSession(
                                subjects: selected.toList(),
                                difficulty: difficulty,
                                style: style,
                              ),
                            ),
                          ),
                  child: const Text('Start Training'),
                ),
              ),
            ],
          ),
        ),
      );
}

class OlympiadSession extends StatefulWidget {
  final List<String> subjects;
  final String difficulty;
  final String style;

  const OlympiadSession({
    super.key,
    required this.subjects,
    required this.difficulty,
    required this.style,
  });

  @override
  State<OlympiadSession> createState() => _OlympiadSessionState();
}

class _OlympiadSessionState extends State<OlympiadSession> {
  final answer = TextEditingController();

  String question = '';
  String feedback = '';

  bool generating = false;
  bool checking = false;

  Future<void> generate() async {
    setState(() {
      generating = true;
      feedback = '';
      answer.clear();
    });

    final prompt = '''
Create one challenging Olympiad problem.

Subjects: ${widget.subjects.join(', ')}
Difficulty: ${widget.difficulty}
Style: ${widget.style}

Use clean Markdown.
Start with ## Problem
Give only the problem.
Do not give hints or solution.
''';

    try {
      final r = await http.post(
        Uri.parse('$api/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': prompt}),
      );

      final data = jsonDecode(r.body);

      setState(() {
        question = r.statusCode == 200
            ? data['reply'] ?? 'No question.'
            : 'Backend error: ${r.statusCode}';
      });
    } catch (_) {
      setState(() {
        question = 'Could not connect to Lunaric.';
      });
    }

    setState(() => generating = false);
  }

  Future<void> check() async {
    final a = answer.text.trim();

    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Generate a question first.'),
        ),
      );
      return;
    }

    if (a.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Write your answer first.'),
        ),
      );
      return;
    }

    setState(() {
      checking = true;
      feedback = '';
    });

    final prompt = '''
Evaluate this Olympiad answer.

Problem:
$question

Student answer:
$a

Use exactly:

## Verdict
Correct, Partially Correct, or Incorrect.

## What You Did Well
Explain the strongest parts.

## What Needs Improvement
Explain mistakes or missing reasoning.

## Coach Feedback
Give useful improvement advice.

Use clean Markdown.
''';

    try {
      final r = await http.post(
        Uri.parse('$api/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': prompt}),
      );

      final data = jsonDecode(r.body);

      setState(() {
        feedback = r.statusCode == 200
            ? data['reply'] ?? 'No feedback.'
            : 'Backend error: ${r.statusCode}';
      });
    } catch (_) {
      setState(() {
        feedback = 'Could not connect to Lunaric.';
      });
    }

    setState(() => checking = false);
  }

  Widget panel(
    String text, {
    required IconData icon,
    String? copy,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 10, 10),
      decoration: BoxDecoration(
        color: const Color(0xff111118),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: 10),
              const Text(
                'Lunaric',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          MarkdownBody(
            data: text,
            selectable: true,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(
                fontSize: 16,
                height: 1.65,
              ),
            ),
          ),
          if (copy != null)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: copy),
                  );
                },
                icon: const Icon(
                  Icons.copy_rounded,
                  size: 19,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Olympiad Challenge'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.subjects.join(' • '),
                style: const TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 5),
              Text(
                '${widget.difficulty} • ${widget.style}',
                style: const TextStyle(color: Colors.white38),
              ),
              const SizedBox(height: 18),
              panel(
                question.isEmpty
                    ? 'Generate a challenge to begin.'
                    : question,
                icon: Icons.emoji_events_outlined,
                copy: question.isEmpty ? null : question,
              ),
              const SizedBox(height: 18),
              const Text(
                '✍️ Your solution',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: answer,
                minLines: 7,
                maxLines: 14,
                decoration: InputDecoration(
                  hintText:
                      'Write your answer and reasoning...',
                  filled: true,
                  fillColor: const Color(0xff15151f),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed:
                          generating ? null : generate,
                      child: Text(
                        generating
                            ? 'Generating...'
                            : 'New Challenge',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: checking ? null : check,
                      child: Text(
                        checking
                            ? 'Checking...'
                            : 'Check Answer',
                      ),
                    ),
                  ),
                ],
              ),
              if (feedback.isNotEmpty) ...[
                const SizedBox(height: 18),
                panel(
                  feedback,
                  icon: Icons.analytics_outlined,
                  copy: feedback,
                ),
              ],
            ],
          ),
        ),
      );
}

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  final picker = ImagePicker();
  final prompt = TextEditingController();

  XFile? image;
  String result = '';
  bool loading = false;

  Future<void> pick(ImageSource source) async {
    try {
      final file = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (file == null) return;

      setState(() {
        image = file;
        result = '';
      });
    } catch (_) {
      message('Could not select image.');
    }
  }

  Future<void> analyze() async {
    if (image == null) {
      message('Choose an image first.');
      return;
    }

    setState(() {
      loading = true;
      result = '';
    });

    try {
      final bytes = await image!.readAsBytes();
      final encoded = base64Encode(bytes);

      var type = 'image/jpeg';
      final fileName = image!.name.toLowerCase();

      if (fileName.endsWith('.png')) {
        type = 'image/png';
      }

      if (fileName.endsWith('.webp')) {
        type = 'image/webp';
      }

      final r = await http.post(
        Uri.parse('$api/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'image_base64': encoded,
          'mime_type': type,
          'prompt': prompt.text.trim().isEmpty
              ? 'Analyze this image for a student. If it contains a question, solve it. If it contains a diagram, graph, map or text, explain the important information. Use clean Markdown.'
              : prompt.text.trim(),
        }),
      );

      final data = jsonDecode(r.body);

      setState(() {
        result = r.statusCode == 200
            ? data['reply'] ?? 'No analysis received.'
            : 'Backend error: ${r.statusCode}';
      });
    } catch (_) {
      setState(() {
        result = 'Could not connect to Lunaric.';
      });
    }

    setState(() => loading = false);
  }

  void message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  Widget panel(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xff111118),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: MarkdownBody(
        data: text,
        selectable: true,
        styleSheet: MarkdownStyleSheet(
          p: const TextStyle(
            fontSize: 16,
            height: 1.6,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    prompt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Analyze')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🖼️ Analyze anything',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Questions, diagrams, maps, graphs, pages and more.',
                style: TextStyle(color: Colors.white60),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: loading
                          ? null
                          : () => pick(ImageSource.camera),
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                      ),
                      label: const Text('Camera'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: loading
                          ? null
                          : () => pick(ImageSource.gallery),
                      icon: const Icon(
                        Icons.photo_library_outlined,
                      ),
                      label: const Text('Gallery'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if (image != null)
                FutureBuilder<Uint8List>(
                  future: image!.readAsBytes(),
                  builder: (_, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox(
                        height: 250,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(
                        snapshot.data!,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
              const SizedBox(height: 18),
              TextField(
                controller: prompt,
                minLines: 2,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      'What should Lunaric focus on? (optional)',
                  filled: true,
                  fillColor: const Color(0xff15151f),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton.icon(
                  onPressed: loading ? null : analyze,
                  icon: loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.auto_awesome),
                  label: Text(
                    loading
                        ? 'Analyzing...'
                        : 'Analyze Image',
                  ),
                ),
              ),
              if (result.isNotEmpty) ...[
                const SizedBox(height: 20),
                panel(result),
              ],
            ],
          ),
        ),
      );
}