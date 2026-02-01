import 'package:flutter/material.dart';
import 'package:pop/models/task_model.dart';
import 'package:pop/models/user_model.dart';
import 'package:pop/storage/app_storage.dart';
import 'package:pop/services/notification_service.dart';
import 'package:pop/ui/widgets/corn_stalk.dart';

class HomePageNew extends StatefulWidget {
  const HomePageNew({super.key});

  @override
  State<HomePageNew> createState() => _HomePageNewState();
}

class _HomePageNewState extends State<HomePageNew> {
  final TextEditingController _taskController = TextEditingController();
  late UserProfile _user;
  Task? _todayTask;
  bool _isLoading = true;
  bool _isPopping = false;
  String? _selectedCategory;

  final List<String> _categories = [
    'Santé',
    'Apprentissage',
    'Travail',
    'Social',
    'Créatif',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await AppStorage.resetDailyGrains();
    final user = await AppStorage.loadUserProfile();
    final todayTask = await AppStorage.getTodayTask();

    setState(() {
      _user = user;
      _todayTask = todayTask;
      _isLoading = false;
    });
  }

  Future<void> _createTask() async {
    if (_taskController.text.trim().isEmpty) return;

    // Use grain
    await AppStorage.useGrain();

    final task = Task(
      title: _taskController.text.trim(),
      category: _selectedCategory ?? 'Santé',
      durationMinutes: 30,
    );

    await AppStorage.addTask(task);

    setState(() {
      _todayTask = task;
      _selectedCategory = null;
    });

    _taskController.clear();

    // Show feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Tâche créée! Un grain s\'est détaché 🌽'),
          duration: Duration(milliseconds: 800),
        ),
      );
    }

    await _loadData();
  }

  Future<void> _completeTask() async {
    if (_todayTask == null) return;

    setState(() {
      _isPopping = true;
    });

    // Simulate pop animation
    await Future.delayed(const Duration(milliseconds: 1200));

    // Complete task
    await AppStorage.completeTask(_todayTask!.id);
    await AppStorage.addToHistory(DateTime.now());
    await AppStorage.addPopCorn(1);
    await NotificationService.scheduleDailyAtHour(9);

    setState(() {
      _isPopping = false;
      _todayTask = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🍿 Pop Corn! Tâche complétée!'),
          duration: Duration(milliseconds: 1200),
        ),
      );
    }

    await _loadData();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.amber[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Header
                Text(
                  'POP',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700],
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Progresse chaque jour',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
                const SizedBox(height: 32),

                // Corn stalk with stats
                CornStalk(
                  grainsRemaining: _user.grainRemaining,
                  totalPopCorns: _user.totalPopCorns,
                  isPopping: _isPopping,
                  onGrainDetached: () {
                    // Animation feedback
                  },
                  onPopCornCreated: () {
                    // Animation feedback
                  },
                ),

                const SizedBox(height: 40),

                // Task display/creation
                if (_todayTask == null) ...[
                  Text(
                    'Crée ta tâche pour aujourd\'hui',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Category selector
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return GestureDetector(
                        onTap: () => setState(
                            () => _selectedCategory = category),
                        child: Chip(
                          label: Text(category),
                          backgroundColor: isSelected
                              ? Colors.orange
                              : Colors.grey[200],
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey[800],
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Task input
                  TextField(
                    controller: _taskController,
                    onChanged: (_) => setState(() {}),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'ex: Lire 30 pages',
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
                  ),
                  const SizedBox(height: 16),
                  // Create button
                  ElevatedButton(
                    onPressed: _taskController.text.trim().isNotEmpty &&
                            _selectedCategory != null &&
                            _user.grainRemaining > 0
                        ? _createTask
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                    ),
                    child: Text(
                      'Créer la tâche (${_user.grainRemaining}/10 grains)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ] else ...[
                  // Task display
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange[200]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Tâche du jour',
                          style: Theme.of(context).textTheme.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _todayTask!.title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _todayTask!.category,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Complete button
                  ElevatedButton.icon(
                    onPressed: _completeTask,
                    icon: _isPopping
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('✓'),
                    label: const Text('Valider la tâche'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[500],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
