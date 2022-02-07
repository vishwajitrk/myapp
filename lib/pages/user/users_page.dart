import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/config/router.dart';
import 'package:myapp/pages/home_page.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

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
      body: Column(children: [
        const Center(child: Text('Users Page')),
        BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              ),
              child: const Text('Go to homepage'),
            );
          },
        )
      ]),
    );
  }
}
