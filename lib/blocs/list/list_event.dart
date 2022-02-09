import 'package:equatable/equatable.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();
  @override
  List<Object> get props => [];
}

class Fetch extends ListEvent {}

class Delete extends ListEvent {
  final String id;
  const Delete({required this.id});
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'Delete { id: $id }';
}

class Deleted extends ListEvent {
  final String id;
  const Deleted({required this.id});
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'Deleted { id: $id }';
}

class Update extends ListEvent {
  final String id;
  const Update({required this.id});
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'Update { id: $id }';
}

class Updated extends ListEvent {
  final String id;
  const Updated({required this.id});
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'Updated { id: $id }';
}
