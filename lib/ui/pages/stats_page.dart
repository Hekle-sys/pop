import 'package:flutter/material.dart';
import 'package:pop/storage/app_storage.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late List<String> _history;
  late int _currentStreak;
  int _maxStreak = 0;
  int _totalDaysCompleted = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final history = await AppStorage.loadHistory();
    final currentStreak = AppStorage.computeStreak(history);

    // Calculate max streak (could be improved with more sophisticated logic)
    int maxStreak = 0;
    List<DateTime> dates = history
        .map((e) => DateTime.parse(e))
        .toList()
      ..sort((a, b) => a.compareTo(b));

    int tempStreak = 1;
    for (int i = 1; i < dates.length; i++) {
      final diff = dates[i].difference(dates[i - 1]).inDays;
      if (diff == 1) {
        tempStreak++;
      } else {
        maxStreak = maxStreak > tempStreak ? maxStreak : tempStreak;
        tempStreak = 1;
      }
    }
    maxStreak = maxStreak > tempStreak ? maxStreak : tempStreak;

    setState(() {
      _history = history;
      _currentStreak = currentStreak;
      _maxStreak = maxStreak;
      _totalDaysCompleted = history.length;
      _isLoading = false;
    });
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
      appBar: AppBar(
        title: const Text('Statistiques'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Cartes de statistiques principales
              Row(
                children: [
                  _buildStatCard(
                    title: 'Série actuelle',
                    value: '$_currentStreak',
                    icon: '🔥',
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    title: 'Série record',
                    value: '$_maxStreak',
                    icon: '🏆',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  _buildStatCard(
                    title: 'Jours complétés',
                    value: '$_totalDaysCompleted',
                    icon: '✓',
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    title: 'Moyenne/mois',
                    value: _calculateMonthlyAverage(),
                    icon: '📊',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Calendrier de progression (heatmap simplifié)
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progression du mois',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      _buildMonthCalendar(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Informations détaillées
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Détails',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('Total de jours complétés', '$_totalDaysCompleted'),
                      _buildInfoRow(
                        'Pourcentage ce mois',
                        '${((_totalDaysCompleted / 30) * 100).toStringAsFixed(1)}%',
                      ),
                      _buildInfoRow(
                        'Dernière tâche',
                        _history.isNotEmpty
                            ? _formatDate(DateTime.parse(_history.last))
                            : 'N/A',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String icon,
  }) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.orange[300]!, Colors.amber[200]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthCalendar() {
    final now = DateTime.now();
    final lastDay = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = lastDay.day;

    List<String> completedDates =
        _history.map((e) => DateTime.parse(e).toString().split(' ')[0]).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: daysInMonth,
      itemBuilder: (context, index) {
        final day = index + 1;
        final date = DateTime(now.year, now.month, day).toString().split(' ')[0];
        final isCompleted = completedDates.contains(date);
        final isToday = now.day == day;

        return Container(
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green[300] : Colors.grey[200],
            border: isToday ? Border.all(color: Colors.orange, width: 2) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '$day',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isCompleted ? Colors.white : Colors.grey[700],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  String _calculateMonthlyAverage() {
    if (_totalDaysCompleted == 0) return '0';
    // Simplified: assuming consistent rate
    return (((_totalDaysCompleted / 30) * 30).toInt()).toString();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
