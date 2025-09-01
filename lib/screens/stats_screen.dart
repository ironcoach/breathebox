import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/session_controller.dart';
import '../models/session.dart';
import 'package:intl/intl.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Session> sessions = ref.watch(sessionHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Stats'),
      ),
      body: sessions.isEmpty
          ? const Center(
              child: Text(
                'No sessions recorded yet',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[sessions.length - 1 - index];
                final dateStr =
                    DateFormat.yMMMd().add_jm().format(session.date);
                return ListTile(
                  leading: const Icon(Icons.self_improvement),
                  title: Text('Breaths: ${session.breathsTaken}'),
                  subtitle: Text(dateStr),
                );
              },
            ),
    );
  }
}
