import 'package:flutter/material.dart';
import 'package:pop/storage/history_storage.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historique')),
      body: FutureBuilder<List<String>>(
        future: HistoryStorage.load(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final dates = snapshot.data!;
          if (dates.isEmpty) {
            return const Center(child: Text('Aucun jour validé'));
          }

          return ListView.builder(
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = DateTime.parse(dates[index]);
              return ListTile(
                leading: const Text('🍿'),
                title: Text(
                  '${date.day}/${date.month}/${date.year}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
