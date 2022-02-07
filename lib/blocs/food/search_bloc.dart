import 'package:bloc/bloc.dart';
import 'package:myapp/blocs/food/search_event.dart';
import 'package:myapp/blocs/food/search_state.dart';
import 'package:myapp/models/food.dart';
import 'package:myapp/repositories/food_repository.dart';

class FoodSearchBloc extends Bloc<SearchEvent, SearchState> {
  FoodRepository repository;

  SearchState get initialState => FoodSearchInitialState();

  FoodSearchBloc({required this.repository}) : super(FoodSearchInitialState()) {
    on<SearchEvent>((event, emit) async {
      if (event is FoodSearchEvent) {
        emit(FoodSearchInitialState());

        try {
          List<Recipe> recipes = await repository.searchFoods(event.food);
          emit(FoodSearchLoadedState(recipes: recipes));
        } catch (e) {
          emit(FoodSearchErrorState(message: e.toString()));
        }
      }
    });
  }
}
