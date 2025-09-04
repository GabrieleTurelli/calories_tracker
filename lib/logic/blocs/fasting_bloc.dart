import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/fast_session.dart';
import '../../data/repositories/fasting_repository.dart';

abstract class FastingEvent extends Equatable {
  const FastingEvent();

  @override
  List<Object?> get props => [];
}

class LoadFastingData extends FastingEvent {}

class StartFastingSession extends FastingEvent {
  final FastProtocol protocol;
  final String? notes;

  const StartFastingSession(this.protocol, {this.notes});

  @override
  List<Object?> get props => [protocol, notes];
}

class EndFastingSession extends FastingEvent {
  final String sessionId;

  const EndFastingSession(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class UpdateFastingSession extends FastingEvent {
  final FastSession session;

  const UpdateFastingSession(this.session);

  @override
  List<Object?> get props => [session];
}

abstract class FastingState extends Equatable {
  const FastingState();

  @override
  List<Object?> get props => [];
}

class FastingInitial extends FastingState {}

class FastingLoading extends FastingState {}

class FastingLoaded extends FastingState {
  final FastSession? activeSession;
  final List<FastSession> completedSessions;
  final int streakCount;

  const FastingLoaded({
    this.activeSession,
    required this.completedSessions,
    required this.streakCount,
  });

  @override
  List<Object?> get props => [activeSession, completedSessions, streakCount];
}

class FastingError extends FastingState {
  final String message;

  const FastingError(this.message);

  @override
  List<Object?> get props => [message];
}

class FastingBloc extends Bloc<FastingEvent, FastingState> {
  final FastingRepository _fastingRepository;

  FastingBloc(this._fastingRepository) : super(FastingInitial()) {
    on<LoadFastingData>(_onLoadFastingData);
    on<StartFastingSession>(_onStartFastingSession);
    on<EndFastingSession>(_onEndFastingSession);
    on<UpdateFastingSession>(_onUpdateFastingSession);
  }

  Future<void> _onLoadFastingData(
    LoadFastingData event,
    Emitter<FastingState> emit,
  ) async {
    emit(FastingLoading());
    try {
      final activeSession = await _fastingRepository.getActiveSession();
      final completedSessions = await _fastingRepository.getCompletedSessions();
      final streakCount = await _fastingRepository.getCompletedStreakCount();

      emit(
        FastingLoaded(
          activeSession: activeSession,
          completedSessions: completedSessions,
          streakCount: streakCount,
        ),
      );
    } catch (e) {
      emit(FastingError('Errore nel caricamento dei dati del digiuno: $e'));
    }
  }

  Future<void> _onStartFastingSession(
    StartFastingSession event,
    Emitter<FastingState> emit,
  ) async {
    try {
      final activeSession = await _fastingRepository.getActiveSession();
      if (activeSession != null) {
        emit(const FastingError('C\'è già una sessione di digiuno attiva'));
        return;
      }

      final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
      final newSession = FastSession(
        id: sessionId,
        startTime: DateTime.now(),
        protocolType: event.protocol,
        notes: event.notes,
      );

      await _fastingRepository.add(sessionId, newSession);

      add(LoadFastingData());
    } catch (e) {
      emit(FastingError('Errore nell\'avvio della sessione di digiuno: $e'));
    }
  }

  Future<void> _onEndFastingSession(
    EndFastingSession event,
    Emitter<FastingState> emit,
  ) async {
    try {
      final session = await _fastingRepository.get(event.sessionId);
      if (session == null) {
        emit(const FastingError('Sessione non trovata'));
        return;
      }

      final endedSession = session.copyWith(endTime: DateTime.now());
      await _fastingRepository.update(event.sessionId, endedSession);

      add(LoadFastingData());
    } catch (e) {
      emit(FastingError('Errore nella conclusione della sessione: $e'));
    }
  }

  Future<void> _onUpdateFastingSession(
    UpdateFastingSession event,
    Emitter<FastingState> emit,
  ) async {
    try {
      await _fastingRepository.update(event.session.id, event.session);

      add(LoadFastingData());
    } catch (e) {
      emit(FastingError('Errore nell\'aggiornamento della sessione: $e'));
    }
  }
}
