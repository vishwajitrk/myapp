import 'package:equatable/equatable.dart';
import 'package:myapp/models/food.dart';

abstract class SearchState extends Equatable {}

class FoodSearchInitialState extends SearchState {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class FoodSearchLoadedState extends SearchState {
  List<Recipe> recipes;
  FoodSearchLoadedState({required this.recipes});
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class FoodSearchErrorState extends SearchState {
  String message;
  FoodSearchErrorState({required this.message});
  @override
  List<Object> get props => [message];

  @override
  String toString() => 'Error Message {error: $message }';
}