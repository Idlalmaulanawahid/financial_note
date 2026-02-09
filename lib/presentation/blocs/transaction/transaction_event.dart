import 'package:equatable/equatable.dart';

import '../../../domain/entities/transaction_entity.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {}

class LoadTransactionsByMonth extends TransactionEvent {
  final int year;
  final int month;

  const LoadTransactionsByMonth(this.year, this.month);

  @override
  List<Object?> get props => [year, month];
}

class AddTransaction extends TransactionEvent {
  final TransactionEntity transaction;

  const AddTransaction(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class UpdateTransaction extends TransactionEvent {
  final TransactionEntity transaction;

  const UpdateTransaction(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class DeleteTransaction extends TransactionEvent {
  final int id;

  const DeleteTransaction(this.id);

  @override
  List<Object?> get props => [id];
}
