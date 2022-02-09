import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/blocs/user/user_bloc.dart';
import 'package:myapp/config/router.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UsersPageState();
  }
}

class _UsersPageState extends State<UsersPage> {
  late UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(FetchUsersEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, FOODS_ROUTE),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.food_bank),
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, ADD_USER_ROUTE),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is FailureUserState) {
            return const Center(
              child: Text('Oops something went wrong!'),
            );
          }
          if (state is LoadedUsersState) {
            if (state.users.isEmpty) {
              return const Center(
                child: Text('no content'),
              );
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                var user = state.users[index];
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, EDIT_USER_ROUTE,
                        arguments: user);
                  },
                  child: ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.lastName ?? ''),
                    leading:
                        CircleAvatar(child: Image.network(user.avatar ?? '')),
                    trailing: SizedBox(
                      width: 90,
                      child: Row(
                        children: [
                          user.isDeleting
                              ? const CircularProgressIndicator()
                              : IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () =>
                                      BlocProvider.of<UserBloc>(context)
                                          .add(DeleteUserEvent(id: user.id)),
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: state.users.length,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // body: Padding(
      //   padding: const EdgeInsets.only(top: 10.0),
      //   child: Column(children: [
      //     const Center(child: Text('Users Page')),
      //     BlocBuilder<HomeBloc, HomeState>(
      //       builder: (context, state) {
      //         return InkWell(
      //           onTap: () => Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => HomePage()),
      //           ),
      //           child: const Text('Go to homepage'),
      //         );
      //       },
      //     ),
      //     BlocBuilder<UserBloc, UserState>(
      //       builder: (context, state) {
      //         return InkWell(
      //           onTap: () => Navigator.pushNamed(context, USER_DETAIL_ROUTE),
      //           child: const Text('User Detail Page'),
      //         );
      //       },
      //     ),
      //     BlocBuilder<ListBloc, ListState>(
      //       builder: (context, state) {
      //         return InkWell(
      //           onTap: () => Navigator.pushNamed(context, LIST_ROUTE),
      //           child: const Text('List Detail Page'),
      //         );
      //       },
      //     )
      //   ]),
      // ),
    );
  }
}
