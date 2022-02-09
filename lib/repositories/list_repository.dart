import 'dart:async';
import 'dart:math';
import 'package:myapp/models/item.dart';

class ListRepository {
  final _random = Random();
  int _next(int min, int max) => min + _random.nextInt(max - min);
  Future<List<Item>> fetchItems() async {
    await Future.delayed(Duration(seconds: _next(1, 5)));
    return List.of(_generateItemsList());
  }

  List<Item> _generateItemsList() {
    final List<Item> items = [];
    items.add(const Item(id: '1', value: 'C'));
    items.add(const Item(id: '2', value: 'C++'));
    items.add(const Item(id: '3', value: 'DATA STRUCTURE'));
    items.add(const Item(id: '4', value: 'PHP'));
    items.add(const Item(id: '5', value: 'ANDROID'));
    return items;
  }

  Stream<String> updateItem(String id) async* {
    await Future.delayed(Duration(seconds: _next(1, 5)));
    yield id;
  }

  Stream<String> deleteItem(String id) async* {
    await Future.delayed(Duration(seconds: _next(1, 5)));
    yield id;
  }
}
