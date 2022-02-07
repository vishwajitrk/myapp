part of 'food_bloc.dart';

abstract class FoodState extends Equatable {}

class FoodInitialState extends FoodState {
  @override
  List<Object?> get props => [];
}

class FoodLoadingState extends FoodState {
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class FoodLoadedState extends FoodState {
  List<Recipe> recipes;
  FoodLoadedState({required this.recipes});
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class FoodErrorState extends FoodState {
  String message;
  FoodErrorState({required this.message});
  @override
  List<Object> get props => [message];

  @override
  String toString() => 'Error Message {error: $message }';
}
