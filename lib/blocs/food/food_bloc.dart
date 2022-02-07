import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myapp/models/food.dart';
import 'package:myapp/repositories/food_repository.dart';

part 'food_event.dart';
part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  FoodRepository repository;
  FoodBloc({required this.repository}) : super(FoodInitialState()) {
    on<FoodEvent>((event, emit) async {
      if(event is FetchFoodEvent){
        emit(FoodLoadingState());

        try {
          List<Recipe> recipes = await repository.getFoods();
          emit(FoodLoadedState(recipes: recipes));
        } catch(e) {
          emit(FoodErrorState(message: e.toString()));
        }
      }
    });
  }

  FoodState get initialState => FoodInitialState();
}
