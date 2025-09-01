import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/session_controller.dart';
import '../models/session.dart';
import 'package:intl/intl.dart';

// Enhanced lib/screens/stats_screen.dart
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Session> sessions = ref.watch(sessionHistoryProvider);

    if (sessions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Session Stats')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.self_improvement, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('No sessions recorded yet', style: TextStyle(fontSize: 18)),
              Text('Complete your first breathing session to see stats!'),
            ],
          ),
        ),
      );
    }

    // Calculate stats
    final totalSessions = sessions.length;
    final totalMinutes =
        sessions.fold(0, (sum, session) => sum + session.durationInSeconds) ~/
            60;
    final totalBreaths =
        sessions.fold(0, (sum, session) => sum + session.breathsTaken);
    final avgSessionLength = totalMinutes / totalSessions;

    // Recent sessions (last 7 days)
    final now = DateTime.now();
    final recentSessions = sessions.where((session) {
      return now.difference(session.date).inDays <= 7;
    }).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Stats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showClearDialog(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: _StatCard('Total Sessions',
                            totalSessions.toString(), Icons.timeline)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _StatCard('Total Minutes',
                            totalMinutes.toString(), Icons.timer)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                        child: _StatCard('Total Breaths',
                            totalBreaths.toString(), Icons.air)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _StatCard('This Week', recentSessions.toString(),
                            Icons.date_range)),
                  ],
                ),
                const SizedBox(height: 8),
                _StatCard(
                    'Avg Session',
                    '${avgSessionLength.toStringAsFixed(1)} min',
                    Icons.analytics),
              ],
            ),
          ),

          // Session History
          Expanded(
            child: ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[sessions.length - 1 - index];
                final dateStr =
                    DateFormat.yMMMd().add_jm().format(session.date);
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.withOpacity(0.1),
                      child: const Icon(Icons.self_improvement,
                          color: Colors.teal),
                    ),
                    title: Text('${session.breathsTaken} breaths'),
                    subtitle: Text(dateStr),
                    trailing: Text(session.formattedDuration),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Sessions?'),
        content: const Text(
            'This will permanently delete all your session history.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // You'd need to add a clear method to SessionController
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 24, color: Colors.teal),
            const SizedBox(height: 8),
            Text(value,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
