import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/blocs/user/user_bloc.dart';

class AddUserPage extends StatelessWidget {
  AddUserPage({Key? key}) : super(key: key);

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is LoadedUsersState) {
          Navigator.pop(context);
        } else if (state is FailureUserState) {
          AlertDialog(
            title: const Text('Error Message'),
            content: Text(state.message),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add User"),
        ),
        body: _body(context),
      ),
    );
  }

  Widget _body(context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            controller: _emailController,
            autocorrect: true,
            decoration: const InputDecoration(hintText: "Enter user email."),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _nameController,
            autocorrect: true,
            decoration: const InputDecoration(hintText: "Enter user name."),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _lastNameController,
            autocorrect: true,
            decoration: const InputDecoration(hintText: "Enter user lastname."),
          ),
          const SizedBox(height: 10.0),
          InkWell(
              onTap: () async {
                print('add api call');
                var body = {
                  "email": _emailController.text,
                  "first_name": _nameController.text,
                  "last_name": _lastNameController.text,
                  "avatar": "https://reqres.in/img/faces/1-image.jpg"
                };
                BlocProvider.of<UserBloc>(context)
                    .add(AddUserEvent(user: body));
                //  await UserRepository.addUser(body);
              },
              child: _addBtn(context))
        ],
      ),
    );
  }

  Widget _addBtn(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: const Center(
        child: Text(
          "Add User",
          style: TextStyle(fontSize: 15.0, color: Colors.white),
        ),
      ),
    );
  }
}
