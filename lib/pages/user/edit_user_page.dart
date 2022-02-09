import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/blocs/user/user_bloc.dart';
import 'package:myapp/models/user.dart';

class EditUserPage extends StatelessWidget {
  final User user;
  EditUserPage({Key? key, required this.user}) : super(key: key);

  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.text = user.name;
    _lastNameController.text = user.lastName ?? '';

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
          title: Text("Edit User ${_nameController.text}"),
          actions: [
            user.isDeleting
                ? const CircularProgressIndicator()
                : InkWell(
                    onTap: () {
                      BlocProvider.of<UserBloc>(context)
                          .add(DeleteUserEvent(id: user.id));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.delete),
                    ),
                  )
          ],
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
            controller: _nameController,
            autocorrect: true,
            decoration: const InputDecoration(hintText: "Enter user name..."),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _lastNameController,
            autocorrect: true,
            decoration:
                const InputDecoration(hintText: "Enter user lastname..."),
          ),
          const SizedBox(height: 10.0),
          InkWell(
              onTap: () {
                BlocProvider.of<UserBloc>(context).add(UpdateUserEvent(
                    id: user.id,
                    body: {
                      'name': _nameController.text,
                      'lastName': _lastNameController.text
                    }));
              },
              child: _updateBtn(context))
        ],
      ),
    );
  }

  Widget _updateBtn(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: const Center(
        child: Text(
          "Update User",
          style: TextStyle(fontSize: 15.0, color: Colors.white),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:myapp/blocs/user/user_bloc.dart';
// import 'package:myapp/models/user.dart';

// class EditUserPage extends StatelessWidget {
//   final User user;
//   EditUserPage({Key? key, required this.user}) : super(key: key);

//   final _nameController = TextEditingController();
//   final _lastNameController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     _nameController.text = user.name;
//     _lastNameController.text = user.lastName ?? '';

//     return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
//       if (state is FailureUserState) {
//         return const Center(
//           child: Text('Oops something went wrong!'),
//         );
//       } 
//       if (state is UpdateUserEvent) {
//         return const Center(
//           child: Text('Oops'),
//         );
//       } 
//       if (state is UpdatedUserEvent) {
//         Navigator.pop(context);
//       } 
//       return Scaffold(
//         appBar: AppBar(
//           title: Text("Edit User ${_nameController.text}"),
//           actions: [
//             InkWell(
//               onTap: () {
//                 // BlocProvider.of<UserBloc>(context).deleteUser(user);
//               },
//               child: const Padding(
//                 padding: EdgeInsets.all(10.0),
//                 child: Icon(Icons.delete),
//               ),
//             )
//           ],
//         ),
//         body: _body(context),
//       );
//     });
//   }

//   Widget _body(context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         children: [
//           TextField(
//             controller: _nameController,
//             autocorrect: true,
//             decoration: const InputDecoration(hintText: "Enter user name..."),
//           ),
//           const SizedBox(height: 10.0),
//           TextField(
//             controller: _lastNameController,
//             autocorrect: true,
//             decoration:
//                 const InputDecoration(hintText: "Enter user lastname..."),
//           ),
//           const SizedBox(height: 10.0),
//           InkWell(
//               onTap: () {
//                 BlocProvider.of<UserBloc>(context).add(UpdateUserEvent(
//                     id: user.id,
//                     body: {
//                       'name': _nameController.text,
//                       'lastName': _lastNameController.text
//                     }));
//               },
//               child: _updateBtn(context))
//         ],
//       ),
//     );
//   }

//   Widget _updateBtn(context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: 50.0,
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: const Center(
//         child: Text(
//           "Update User",
//           style: TextStyle(fontSize: 15.0, color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
