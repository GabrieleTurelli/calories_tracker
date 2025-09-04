import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/diary_entry.dart';
import '../../data/repositories/diary_repository.dart';

abstract class DiaryEvent extends Equatable {
  const DiaryEvent();

  @override
  List<Object?> get props => [];
}

class LoadDiaryEntry extends DiaryEvent {
  final DateTime date;

  const LoadDiaryEntry(this.date);

  @override
  List<Object?> get props => [date];
}

class AddMealToDiary extends DiaryEvent {
  final DateTime date;
  final MealEntry meal;

  const AddMealToDiary(this.date, this.meal);

  @override
  List<Object?> get props => [date, meal];
}

class UpdateMealInDiary extends DiaryEvent {
  final DateTime date;
  final MealEntry meal;

  const UpdateMealInDiary(this.date, this.meal);

  @override
  List<Object?> get props => [date, meal];
}

class RemoveMealFromDiary extends DiaryEvent {
  final DateTime date;
  final String mealId;

  const RemoveMealFromDiary(this.date, this.mealId);

  @override
  List<Object?> get props => [date, mealId];
}

class UpdateWaterIntake extends DiaryEvent {
  final DateTime date;
  final double waterIntake;

  const UpdateWaterIntake(this.date, this.waterIntake);

  @override
  List<Object?> get props => [date, waterIntake];
}

abstract class DiaryState extends Equatable {
  const DiaryState();

  @override
  List<Object?> get props => [];
}

class DiaryInitial extends DiaryState {}

class DiaryLoading extends DiaryState {}

class DiaryLoaded extends DiaryState {
  final DiaryEntry diaryEntry;

  const DiaryLoaded(this.diaryEntry);

  @override
  List<Object?> get props => [diaryEntry];
}

class DiaryError extends DiaryState {
  final String message;

  const DiaryError(this.message);

  @override
  List<Object?> get props => [message];
}

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final DiaryRepository _diaryRepository;

  DiaryBloc(this._diaryRepository) : super(DiaryInitial()) {
    on<LoadDiaryEntry>(_onLoadDiaryEntry);
    on<AddMealToDiary>(_onAddMealToDiary);
    on<UpdateMealInDiary>(_onUpdateMealInDiary);
    on<RemoveMealFromDiary>(_onRemoveMealFromDiary);
    on<UpdateWaterIntake>(_onUpdateWaterIntake);
  }

  Future<void> _onLoadDiaryEntry(
    LoadDiaryEntry event,
    Emitter<DiaryState> emit,
  ) async {
    emit(DiaryLoading());
    try {
      DiaryEntry? entry = await _diaryRepository.getEntryForDate(event.date);

      entry ??= DiaryEntry(
        id: '${event.date.year}-${event.date.month}-${event.date.day}',
        date: event.date,
        meals: [],
        waterIntake: 0.0,
      );

      emit(DiaryLoaded(entry));
    } catch (e) {
      emit(DiaryError('Errore nel caricamento del diario: $e'));
    }
  }

  Future<void> _onAddMealToDiary(
    AddMealToDiary event,
    Emitter<DiaryState> emit,
  ) async {
    if (state is DiaryLoaded) {
      try {
        final currentEntry = (state as DiaryLoaded).diaryEntry;
        final updatedMeals = List<MealEntry>.from(currentEntry.meals)
          ..add(event.meal);

        final updatedEntry = currentEntry.copyWith(meals: updatedMeals);
        await _diaryRepository.saveEntryForDate(event.date, updatedEntry);

        emit(DiaryLoaded(updatedEntry));
      } catch (e) {
        emit(DiaryError('Errore nell\'aggiunta del pasto: $e'));
      }
    }
  }

  Future<void> _onUpdateMealInDiary(
    UpdateMealInDiary event,
    Emitter<DiaryState> emit,
  ) async {
    if (state is DiaryLoaded) {
      try {
        final currentEntry = (state as DiaryLoaded).diaryEntry;
        final updatedMeals = currentEntry.meals
            .map((meal) => meal.id == event.meal.id ? event.meal : meal)
            .toList();

        final updatedEntry = currentEntry.copyWith(meals: updatedMeals);
        await _diaryRepository.saveEntryForDate(event.date, updatedEntry);

        emit(DiaryLoaded(updatedEntry));
      } catch (e) {
        emit(DiaryError('Errore nell\'aggiornamento del pasto: $e'));
      }
    }
  }

  Future<void> _onRemoveMealFromDiary(
    RemoveMealFromDiary event,
    Emitter<DiaryState> emit,
  ) async {
    if (state is DiaryLoaded) {
      try {
        final currentEntry = (state as DiaryLoaded).diaryEntry;
        final updatedMeals = currentEntry.meals
            .where((meal) => meal.id != event.mealId)
            .toList();

        final updatedEntry = currentEntry.copyWith(meals: updatedMeals);
        await _diaryRepository.saveEntryForDate(event.date, updatedEntry);

        emit(DiaryLoaded(updatedEntry));
      } catch (e) {
        emit(DiaryError('Errore nella rimozione del pasto: $e'));
      }
    }
  }

  Future<void> _onUpdateWaterIntake(
    UpdateWaterIntake event,
    Emitter<DiaryState> emit,
  ) async {
    if (state is DiaryLoaded) {
      try {
        final currentEntry = (state as DiaryLoaded).diaryEntry;
        final updatedEntry = currentEntry.copyWith(
          waterIntake: event.waterIntake,
        );

        await _diaryRepository.saveEntryForDate(event.date, updatedEntry);
        emit(DiaryLoaded(updatedEntry));
      } catch (e) {
        emit(DiaryError('Errore nell\'aggiornamento dell\'acqua: $e'));
      }
    }
  }
}
