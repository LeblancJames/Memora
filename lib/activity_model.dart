import 'dart:ffi';

import 'package:flutter/material.dart';

class Activity {
  final Long id;
  final String name;
  final String? location;
  //add photos?
  final List<bool> categoriesOne;
  final List<bool> categoriesTwo;
  final String? notes;
  final Int? rating;
  final bool visited;

  Activity({
    required this.id,
    required this.name,
    this.location,
    required this.categoriesOne,
    required this.categoriesTwo,
    this.notes,
    this.rating,
    required this.visited,
  });
}

//need to override default tostring to actually return object instead of just 'instance of classname'
// @override
// String toString() {
//   return 'ToDoItem{id: $id, name: $name, description: $description}';
// }
