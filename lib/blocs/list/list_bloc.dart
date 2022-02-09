import 'package:bloc/bloc.dart';
import 'package:myapp/blocs/list/list_event.dart';
import 'package:myapp/blocs/list/list_state.dart';
import 'package:myapp/models/item.dart';
import 'package:myapp/repositories/list_repository.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListRepository repository;

  ListBloc({required this.repository}) : super(Loading()) {
    on<ListEvent>((event, emit) async {
      if (event is Fetch) {
        try {
          final items = await repository.fetchItems();
          emit(Loaded(items: items));
        } catch (_) {
          emit(Failure());
        }
      }

      if (event is Update) {
        final listState = state;
        if (listState is Loaded) {
          final List<Item> updatedItems =
              List<Item>.from(listState.items).map((Item item) {
            return item.id == event.id
                ? item.copyWith(isEditing: true, value: item.value+' test')
                : item;
          }).toList();
          emit(Loaded(items: updatedItems));
          repository.updateItem(event.id).listen((id) {
            add(Updated(id: id));
          });
        }
      }
      if (event is Updated) {
        final listState = state;
        if (listState is Loaded) {
          final List<Item> updatedItems =
              List<Item>.from(listState.items).map((Item item) {
            return item.id == event.id
                ? item.copyWith(isEditing: false)
                : item;
          }).toList();
          emit(Loaded(items: updatedItems));
        }
      }

      if (event is Delete) {
        final listState = state;
        if (listState is Loaded) {
          final List<Item> updatedItems =
              List<Item>.from(listState.items).map((Item item) {
            return item.id == event.id ? item.copyWith(isDeleting: true) : item;
          }).toList();
          emit(Loaded(items: updatedItems));
          repository.deleteItem(event.id).listen((id) {
            add(Deleted(id: id));
          });
        }
      }
      if (event is Deleted) {
        final listState = state;
        if (listState is Loaded) {
          final List<Item> updatedItems = List<Item>.from(listState.items)
            ..removeWhere((item) => item.id == event.id);
          emit(Loaded(items: updatedItems));
        }
      }
    });
  }
}
