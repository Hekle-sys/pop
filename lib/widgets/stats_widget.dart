import 'package:flutter/material.dart';
import '../storage/history_storage.dart';

class StatsWidget extends StatelessWidget {
  const StatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: HistoryStorage.load(),
      builder: (context, snapshot) {
        final dates = snapshot.data ?? [];
        final count = dates.length;
        final streak = HistoryStorage.computeStreak(dates);

        return Column(
          children: [
            Text(
              '🍿 $count',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            if (streak >= 2)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '$streak jours 🔥',
                  style: TextStyle(
                    fontSize: 13,
                    color: const Color(0x80000000),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
