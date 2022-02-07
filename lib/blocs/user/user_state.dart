part of 'user_bloc.dart';

class UserState {
  final User? user;
  const UserState({this.user});

  factory UserState.initial() => const UserState();
}

class UserInitial extends UserState {}

class LoadingUser extends UserState  {}
class SuccessSaveUser extends UserState  {}
class FailureUser extends UserState {
  final String error;
  FailureUser(this.error);
}
