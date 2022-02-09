import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/blocs/food/food_bloc.dart';
import 'package:myapp/blocs/food/search_bloc.dart';
import 'package:myapp/blocs/list/list_bloc.dart';
import 'package:myapp/blocs/user/user_bloc.dart';
import 'package:myapp/config/router.dart';
import 'package:myapp/config/theme.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:myapp/repositories/food_repository.dart';
import 'package:myapp/repositories/list_repository.dart';
import 'package:myapp/repositories/user_repository.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(App(router: AppRouter())),
    blocObserver: AppBlocObserver(),
  );
}

/// Custom [BlocObserver] that observes all bloc and cubit state changes.
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) print(change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

class App extends StatelessWidget {
  final AppRouter router;
  const App({Key? key, required this.router}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FoodBloc(
            repository: FoodRepository(),
          ),
        ),
        BlocProvider(
          create: (context) => FoodSearchBloc(
            repository: FoodRepository(),
          ),
        ),
        BlocProvider(
          create: (context) => HomeBloc(repository: HomeRepository()),
        ),
        BlocProvider(
          create: (context) => UserBloc(repository: UserRepository()),
        ),
        BlocProvider(
          create: (context) => ListBloc(repository:ListRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: router.generateRoute,
        theme: AppTheme.of(context),
        // home: TestWidget(title: 'T', message: 'M'),
      ),
    );
  }
}

class TestWidget extends StatelessWidget {
  const TestWidget({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
