import 'package:flutter/material.dart';
import 'package:myapp/models/food.dart';

class FoodDetailPage extends StatelessWidget {
  final Recipe recipe;
  const FoodDetailPage({Key? key, required this.recipe}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: Column(
        children: [
          Image.network(recipe.imageUrl),
          Text(recipe.title),
          Text(recipe.publisher),
        ],
      ),
    );
  }
}