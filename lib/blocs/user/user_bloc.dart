import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  late UserRepository repository;
  UserBloc({required this.repository}) : super(LoadingUsersState()) {
    on<UserEvent>((event, emit) async {
      if (event is FetchUsersEvent) {
        try {
          final users = await repository.getUsers();
          emit(LoadedUsersState(users: users));
        } catch (_) {
          emit(FailureUserState(message: _.toString()));
        }
      }

      if (event is AddUserEvent) {
        try {
          final listState = state;
          if (listState is LoadedUsersState) {
            final List<User> updatedUsers = listState.users;
            // var user2 = User(
            //     id: 28,
            //     email: event.user['email'],
            //     name: event.user['first_name'],
            //     lastName: event.user['last_name'],
            //     avatar: event.user['avatar'],
            //     status: '',
            //     gender: '');
            // updatedUsers.add(user2);
            repository.addUser(event.user).listen((user) {
              add(AddedUserEvent(user: user));
            });
            emit(LoadedUsersState(users: updatedUsers));
          }
        } catch (_) {
          emit(FailureUserState(message: _.toString()));
        }
      }

      if (event is AddedUserEvent) {
        try {
          final listState = state;
          if (listState is LoadedUsersState) {
            final List<User> updatedUsers = listState.users;
            updatedUsers.add(event.user);
            emit(LoadedUsersState(users: updatedUsers));
          }
        } catch (_) {
          emit(FailureUserState(message: _.toString()));
        }
      }

      if (event is UpdateUserEvent) {
        try {
          final listState = state;
          if (listState is LoadedUsersState) {
            final List<User> updatedUsers =
                List<User>.from(listState.users).map((User user) {
              return user.id == event.id
                  ? user.copyWith(
                      id: user.id,
                      name: event.body['name'],
                      lastName: event.body['lastName'])
                  : user;
            }).toList();
            repository.updateUser(event.id, event.body).listen((id) {
              add(UpdatedUserEvent(id: id));
            });
            emit(LoadedUsersState(users: updatedUsers));
          }
        } catch (_) {
          emit(FailureUserState(message: _.toString()));
        }
      }

      if (event is UpdatedUserEvent) {
        try {
          final listState = state;
          if (listState is LoadedUsersState) {
            final List<User> updatedUsers =
                List<User>.from(listState.users).map((User user) {
              return user.id == event.id
                  ? user.copyWith(isEditing: false)
                  : user;
            }).toList();
            emit(LoadedUsersState(users: updatedUsers));
          }
        } catch (_) {
          emit(FailureUserState(message: _.toString()));
        }
      }

      if (event is DeleteUserEvent) {
        try {
          final listState = state;
          if (listState is LoadedUsersState) {
            final List<User> updatedUsers =
                List<User>.from(listState.users).map((User user) {
              return user.id == event.id
                  ? user.copyWith(isDeleting: true)
                  : user;
            }).toList();
            emit(LoadedUsersState(users: updatedUsers));
            repository.deleteUser(event.id).listen((id) {
              add(DeletedUserEvent(id: id));
            });
          }
        } catch (_) {
          emit(FailureUserState(message: _.toString()));
        }
      }

      if (event is DeletedUserEvent) {
        try {
          final listState = state;
          if (listState is LoadedUsersState) {
            final List<User> updatedUsers = List<User>.from(listState.users)
              ..removeWhere((user) => user.id == event.id);
            emit(LoadedUsersState(users: updatedUsers));
          }
        } catch (_) {
          emit(FailureUserState(message: _.toString()));
        }
      }

      // if (event is GetUserIdEvent) {
      //   try {
      //     event.id;
      //     // final user = await repository.getUsers();
      //     // emit( UserInitial());
      //   } catch (_) {
      //     emit(FailureUserState(message: _.toString()));
      //   }
      // }

      // if (event is GetIdEvent) {
      //   try {
      //     emit(LoadingUser());
      //     await Future.delayed(const Duration(seconds: 1));

      //     final data = await APIWeb().load(UserRepository.getId(event.id));

      //     emit(const UserState());
      //   } catch (ex) {
      //     emit(FailureUser(ex.toString()));
      //   }
      // }

      // if (event is SaveEvent) {
      //   try {
      //     emit(LoadingUser());
      //     await Future.delayed(const Duration(seconds: 1));
      //     dynamic formData;

      //     formData = {
      //       'id': event.id,
      //       'name': event.firstName,
      //       // 'lastName': event.lastName,
      //     };

      //     await APIWeb().put(UserRepository.update(formData, event.file));

      //     emit(SuccessSaveUser());
      //   } catch (ex) {
      //     emit(FailureUser(ex.toString()));
      //   }
      // }
    });
  }
}
