import 'dart:async';

import '../models/fast_session.dart';
import 'base_repository.dart';

class FastingRepository extends BaseRepository<FastSession> {
  FastingRepository() : super('fast_sessions');

  Future<FastSession?> getActiveSession() async {
    final sessions = await getAll();
    return sessions.where((session) => session.isActive).firstOrNull;
  }

  Future<List<FastSession>> getCompletedSessions() async {
    final sessions = await getAll();
    return sessions.where((session) => !session.isActive).toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  Future<List<FastSession>> getSessionsForDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final sessions = await getAll();
    return sessions.where((session) {
      return session.startTime.isAfter(
            start.subtract(const Duration(days: 1)),
          ) &&
          session.startTime.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  Future<int> getCompletedStreakCount() async {
    final sessions = await getCompletedSessions();

    int streak = 0;
    DateTime? lastDate;

    for (final session in sessions) {
      if (!session.isCompleted) continue;

      final sessionDate = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );

      if (lastDate == null) {
        lastDate = sessionDate;
        streak = 1;
        continue;
      }

      final daysDifference = lastDate.difference(sessionDate).inDays;

      if (daysDifference == 1) {
        streak++;
        lastDate = sessionDate;
      } else {
        break;
      }
    }

    return streak;
  }

  Future<Duration> getTotalFastingTime(DateTime start, DateTime end) async {
    final sessions = await getSessionsForDateRange(start, end);
    var total = Duration.zero;
    for (final session in sessions.where((s) => s.isCompleted)) {
      total += session.duration;
    }
    return total;
  }

  Future<double> getAverageFastingHours(DateTime start, DateTime end) async {
    final sessions = await getSessionsForDateRange(start, end);
    final completedSessions = sessions
        .where((session) => session.isCompleted)
        .toList();

    if (completedSessions.isEmpty) return 0.0;

    final totalHours = completedSessions.fold(
      0.0,
      (total, session) => total + session.duration.inMinutes / 60,
    );

    return totalHours / completedSessions.length;
  }
}

extension on Iterable<FastSession> {
  FastSession? get firstOrNull {
    if (isEmpty) return null;
    return first;
  }
}
