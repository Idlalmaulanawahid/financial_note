import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/savings_goal_repository.dart';
import 'savings_event.dart';
import 'savings_state.dart';

class SavingsBloc extends Bloc<SavingsEvent, SavingsState> {
  final SavingsGoalRepository _repository;

  SavingsBloc(this._repository) : super(SavingsInitial()) {
    on<LoadSavingsGoals>(_onLoadSavingsGoals);
    on<AddSavingsGoal>(_onAddSavingsGoal);
    on<UpdateSavingsGoal>(_onUpdateSavingsGoal);
    on<DeleteSavingsGoal>(_onDeleteSavingsGoal);
    on<AddToSavings>(_onAddToSavings);
  }

  Future<void> _onLoadSavingsGoals(
    LoadSavingsGoals event,
    Emitter<SavingsState> emit,
  ) async {
    emit(SavingsLoading());
    try {
      final goals = await _repository.getAllSavingsGoals();
      emit(SavingsLoaded(goals));
    } catch (e) {
      emit(SavingsError(e.toString()));
    }
  }

  Future<void> _onAddSavingsGoal(
    AddSavingsGoal event,
    Emitter<SavingsState> emit,
  ) async {
    try {
      await _repository.insertSavingsGoal(event.goal);
      final goals = await _repository.getAllSavingsGoals();
      emit(SavingsLoaded(goals));
    } catch (e) {
      emit(SavingsError(e.toString()));
    }
  }

  Future<void> _onUpdateSavingsGoal(
    UpdateSavingsGoal event,
    Emitter<SavingsState> emit,
  ) async {
    try {
      await _repository.updateSavingsGoal(event.goal);
      final goals = await _repository.getAllSavingsGoals();
      emit(SavingsLoaded(goals));
    } catch (e) {
      emit(SavingsError(e.toString()));
    }
  }

  Future<void> _onDeleteSavingsGoal(
    DeleteSavingsGoal event,
    Emitter<SavingsState> emit,
  ) async {
    try {
      await _repository.deleteSavingsGoal(event.id);
      final goals = await _repository.getAllSavingsGoals();
      emit(SavingsLoaded(goals));
    } catch (e) {
      emit(SavingsError(e.toString()));
    }
  }

  Future<void> _onAddToSavings(
    AddToSavings event,
    Emitter<SavingsState> emit,
  ) async {
    try {
      await _repository.addToSavings(event.id, event.amount);
      final goals = await _repository.getAllSavingsGoals();
      emit(SavingsLoaded(goals));
    } catch (e) {
      emit(SavingsError(e.toString()));
    }
  }
}
