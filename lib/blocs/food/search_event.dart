import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {}

// ignore: must_be_immutable
class FoodSearchEvent extends SearchEvent {
  String food;
  FoodSearchEvent({required this.food});

  @override
  List<Object> get props => [];
}
