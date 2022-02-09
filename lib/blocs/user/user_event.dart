part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object> get props => [];
}

class FetchUsersEvent extends UserEvent {}

class GetUserIdEvent extends UserEvent{
  final int id;
  const GetUserIdEvent({required this.id});

  @override
  List<Object> get props => [id];
  @override
  String toString() => 'GetUserIdEvent { id: $id }';
}

class DeleteUserEvent extends UserEvent {
  final int id;
  const DeleteUserEvent({required this.id});
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'Delete { id: $id }';
}

class DeletedUserEvent extends UserEvent {
  final int id;
  const DeletedUserEvent({required this.id});
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'DeletedUserEvent { id: $id }';
}

class AddUserEvent extends UserEvent {
  final dynamic user;
  const AddUserEvent({required this.user});
  @override
  List<Object> get props => [];
  @override
  String toString() => 'AddUserEvent { id: ${user.name} }';
}

class AddedUserEvent extends UserEvent {
  final User user;
  const AddedUserEvent({required this.user});
  @override
  List<Object> get props => [user];
  @override
  String toString() => 'AddedUserEvent { id: ${user.name} }';
}

class UpdateUserEvent extends UserEvent {
  final int id;
  final dynamic body;
  const UpdateUserEvent({required this.id, this.body});
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'UpdateUserEvent { id: $id }';
}

class UpdatedUserEvent extends UserEvent {
  final int id;
  const UpdatedUserEvent({required this.id});
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'UpdatedUserEvent { id: $id }';
}

class SaveEvent extends UserEvent{
  final int id;
  final String? firstName;
  final String? lastName;
  final File? file;
  const SaveEvent({required this.id, this.firstName, this.lastName, this.file});
}