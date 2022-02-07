part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class GetIdEvent extends UserEvent{
  final int id;

  GetIdEvent({required this.id});
}

class SaveEvent extends UserEvent{
  final int id;
  final String? firstName;
  final String? lastName;
  final File? file;
  SaveEvent({required this.id, this.firstName, this.lastName, this.file});
}
