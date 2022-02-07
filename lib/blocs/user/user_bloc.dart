import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/repositories/user_repository.dart';
import 'package:myapp/services/api_service.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) async {
      if(event is GetIdEvent){
      try{
        emit(LoadingUser());
        await Future.delayed(const Duration(seconds: 1));
        
        final data = await APIWeb().load(UserRepository.getId(event.id));

        emit(UserState(user: data));

      }catch(ex){
        emit(FailureUser(ex.toString()));
      }
    }

    if(event is SaveEvent){
      try{
        emit(LoadingUser());
        await Future.delayed(const Duration(seconds: 1));
        dynamic formData;

        formData = {
          'id': event.id,
          'name': event.firstName,
          // 'lastName': event.lastName,
        };

        await APIWeb().put(UserRepository.update(formData, event.file));

        emit(SuccessSaveUser());
      }catch(ex){
        emit(FailureUser(ex.toString()));
      }
    }
    });
  }
}
