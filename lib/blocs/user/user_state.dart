part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
}

class LoadingUsersState extends UserState {}

class LoadedUsersState extends UserState {
  final List<User> users;
  const LoadedUsersState({required this.users});
  @override
  List<Object> get props => [users];
  @override
  String toString() => 'Loaded { users: ${users.length} }';
}

// class UpdateUserState extends UserState {}

class UpdatedUserState extends UserState {}

class FailureUserState extends UserState {
  final String message;
  const FailureUserState({required this.message});
  @override
  List<Object> get props => [message];

  @override
  String toString() => 'User Error Message {error: $message }';
}



class UserInitial extends UserState {}

class LoadingUser extends UserState  {}
class SuccessSaveUser extends UserState  {}

