// import 'dart:ffi';
// import 'package:flutter/material.dart';

import 'dart:convert';

class Activity {
  final int? id;
  final String name;
  final String? location;
  //add photos?
  final List<bool> categoriesOne;
  final List<bool> categoriesTwo;
  final String? notes;
  final int rating;
  final bool visited;

  Activity({
    required this.id,
    required this.name,
    this.location,
    //photo
    required this.categoriesOne,
    required this.categoriesTwo,
    this.notes,
    required this.rating,
    required this.visited,
  });

  Map<String, Object?> toMap() {
    return {
      // 'id': id,
      'name': name,
      'location': location,
      'categoriesOne': jsonEncode(categoriesOne),
      'categoriesTwo': jsonEncode(categoriesTwo),
      'notes': notes,
      'rating': rating,
      'visited': visited ? 1 : 0,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      categoriesOne: (jsonDecode(map['categoriesOne']) as List).cast<bool>(),
      categoriesTwo: (jsonDecode(map['categoriesTwo']) as List).cast<bool>(),
      notes: map['notes'],
      rating: map['rating'],
      visited:
          map['visited'] ==
          1, //if visisted equals 1, return true else return false essentially converting back to bool
    );
  }

  // need to override default tostring to actually return object instead of just 'instance of classname'
  @override
  String toString() {
    return 'ToDoItem{id: $id, name: $name, location: $location, categoriesOne: $categoriesOne, categoriesTwo: $categoriesTwo, notes: $notes, rating: $rating, visited: $visited}';
  }
}
