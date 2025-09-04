import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'fast_session.g.dart';

@HiveType(typeId: 4)
class FastSession extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime startTime;

  @HiveField(2)
  final DateTime? endTime;

  @HiveField(3)
  final FastProtocol protocolType;

  @HiveField(4)
  final String? notes;

  const FastSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.protocolType,
    this.notes,
  });

  bool get isActive => endTime == null;

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  bool get isCompleted {
    if (endTime == null) return false;
    return duration.inHours >= protocolType.targetHours;
  }

  FastSession copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    FastProtocol? protocolType,
    String? notes,
  }) {
    return FastSession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      protocolType: protocolType ?? this.protocolType,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, startTime, endTime, protocolType, notes];
}

@HiveType(typeId: 5)
enum FastProtocol {
  @HiveField(0)
  intermittent16_8(16, 8, "16:8"),

  @HiveField(1)
  intermittent18_6(18, 6, "18:6"),

  @HiveField(2)
  intermittent20_4(20, 4, "20:4"),

  @HiveField(3)
  omad(23, 1, "OMAD"),

  @HiveField(4)
  custom(0, 0, "Custom");

  const FastProtocol(this.fastHours, this.eatHours, this.displayName);

  final int fastHours;
  final int eatHours;
  final String displayName;

  int get targetHours => fastHours;
}
