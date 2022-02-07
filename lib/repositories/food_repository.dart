import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myapp/models/food.dart';

abstract class AFoodRepository {
  Future<List<Recipe>> getFoods();
  Future<List<Recipe>> searchFoods(String food);
}

class FoodRepository extends AFoodRepository {
  @override
  Future<List<Recipe>> getFoods() async {
    print('api call once');
    final response = await http.get(
        Uri.parse("https://forkify-api.herokuapp.com/api/search?q=pizza#"));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<Recipe> recipes = Food.fromJson(data).recipes;
      return recipes;
    } else {
      throw Exception(json.decode(response.body)['error']);
    }
  }

  @override
  Future<List<Recipe>> searchFoods(String food) async {
    print('api call $food');
    final response = await http.get(
        Uri.parse("https://forkify-api.herokuapp.com/api/search?q=$food"));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<Recipe> recipes = Food.fromJson(data).recipes;
      return recipes;
    } else {
      throw Exception(json.decode(response.body)['error']);
    }
  }
}
