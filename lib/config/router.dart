import 'package:flutter/material.dart';
import 'package:myapp/models/food.dart';
import 'package:myapp/pages/food/food_detail_page.dart';
import 'package:myapp/pages/food/foods_page.dart';
import 'package:myapp/pages/user/add_user_page.dart';
import 'package:myapp/pages/user/edit_user_page.dart';
import 'package:myapp/pages/user/user_detail_page.dart';
import 'package:myapp/pages/user/users_page.dart';

// ignore: constant_identifier_names
const String USERS_ROUTE = '/users';
// ignore: constant_identifier_names
const String ADD_USER_ROUTE = '/add-user';
// ignore: constant_identifier_names
const String EDIT_USER_ROUTE = '/edit-user';
// ignore: constant_identifier_names
const String USER_DETAIL_ROUTE = '/user-detail';
// ignore: constant_identifier_names
const String FOODS_ROUTE = '/foods';
// ignore: constant_identifier_names
const String FOOD_DETAIL_ROUTE = '/food-detail';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const UsersPage());
      case USERS_ROUTE:
        return MaterialPageRoute(builder: (_) => const UsersPage());
      case ADD_USER_ROUTE:
        return MaterialPageRoute(builder: (_) => const AddUserPage());
      case EDIT_USER_ROUTE:
        return MaterialPageRoute(builder: (_) => const EditUserPage());
        case USER_DETAIL_ROUTE:
        return MaterialPageRoute(builder: (_) => const UserDetailPage());
      case FOODS_ROUTE:
        return MaterialPageRoute(builder: (_) => const FoodsPage());
        case FOOD_DETAIL_ROUTE:
        final recipe = settings.arguments as Recipe;
        return MaterialPageRoute(builder: (_) => FoodDetailPage(recipe: recipe));
      default:
        return null;
    }
  }
}
