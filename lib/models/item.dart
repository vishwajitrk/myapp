import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String id;
  final String value;
  final bool isEditing;
  final bool isDeleting;
  const Item({
    required this.id,
    required this.value,
    this.isEditing = false,
    this.isDeleting = false,
  });

  Item copyWith({
    String? id,
    String? value,
    bool? isEditing,
    bool? isDeleting,
  }) {
    return Item(
      id: id ?? this.id,
      value: value ?? this.value,
      isEditing: isEditing ?? this.isEditing,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
  
  @override
  List<Object> get props => [id, value, isEditing, isDeleting];
  @override
  String toString() =>
      'Item { id: $id, value: $value, isEditing : $isEditing, isDeleting: $isDeleting }';
}