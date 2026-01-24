import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'storage/history_storage.dart';
import 'notification_service.dart';
import 'widgets/mascot.dart';
import 'widgets/action_button.dart';
import 'widgets/header.dart';
import 'widgets/stats_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Inter',
      ),
      home: const PopPage(),
    );
  }
}

class PopPage extends StatefulWidget {
  const PopPage({super.key});

  @override
  State<PopPage> createState() => _PopPageState();
}

class _PopPageState extends State<PopPage> {
  final TextEditingController controller = TextEditingController();
  String? task;
  DateTime? taskDate;
  bool _isShaking = false;
  bool _isPopping = false;

  Widget _mascot() {
    return Mascot(task: task, isShaking: _isShaking, isPopping: _isPopping);
  }

  DateTime _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _loadTask() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTask = prefs.getString('task');
    final storedDate = prefs.getString('task_date');

    if (storedTask == null || storedDate == null) {
      return;
    }

    final today = _today();
    final savedDate = DateTime.parse(storedDate);

    final isSameDay =
        today.year == savedDate.year &&
        today.month == savedDate.month &&
        today.day == savedDate.day;

    if (!isSameDay) {
      await prefs.remove('task');
      await prefs.remove('task_date');
      setState(() {
        task = null;
        taskDate = null;
      });
    } else {
      setState(() {
        task = storedTask;
        taskDate = savedDate;
      });
    }
  }


  Future<void> _saveTask(String value) async {
    final prefs = await SharedPreferences.getInstance();
    final today = _today();

    await prefs.setString('task', value);
    await prefs.setString('task_date', today.toIso8601String());

    setState(() {
      task = value;
      taskDate = today;
    });
  }

  Future<void> _clearTask() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('task');
    await prefs.remove('task_date');
    setState(() {
      task = null;
      taskDate = null;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _header(),
              const SizedBox(height: 24),

              _stats(),
              const SizedBox(height: 32),

              _mascot(),
              const SizedBox(height: 32),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: _content(),
              ),

const SizedBox(height: 24),

_actionButton(),

            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return const Header();
  }

  Widget _stats() {
    return const StatsWidget();
}

  Widget _content() {
  if (task == null) {
    return Center(
      child: SizedBox(
        width: 280, // ajuste selon ton Figma
        child: TextField(
          controller: controller,
          onChanged: (_) => setState(() {}),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            labelText: 'Quelle est la tâche du jour ?',
            hintText: 'ex : faire 30 min de sport',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  return Text(
    task!,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
  );
}

  Widget _actionButton() {
    final bool canCreate = controller.text.trim().isNotEmpty;

    return ActionButton(
      hasTask: task != null,
      canCreate: canCreate,
      onCreate: () {
        _saveTask(controller.text.trim());
        controller.clear();
        setState(() {});
      },
      onComplete: () async {
        await _completeTask();
      },
    );
  }

  Future<void> _completeTask() async {
    setState(() {
      _isShaking = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _isShaking = false;
      _isPopping = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    await HistoryStorage.add(_today());
    await NotificationService.scheduleDailyAtHour(9);
    await _clearTask();

    setState(() {
      _isPopping = false;
    });
  }
}


