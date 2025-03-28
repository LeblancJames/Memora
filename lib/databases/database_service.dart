import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:memora/models/activity_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> databaseService() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'activities_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE activities(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, location TEXT, categoriesOne TEXT NOT NULL, categoriesTwo TEXT NOT NULL, notes TEXT, rating INTEGER NOT NULL, visited INTEGER NOT NULL)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 3,
  );
  return database;
}

void buildDummy() async {
  // // //dummy db
  var hike = Activity(
    id: 1,
    name: 'hiking',
    location: 'Canada',
    categoriesOne: [false, true, false, false, false],
    categoriesTwo: [false, false, false, false, false],
    notes: 'abc',
    rating: 3,
    visited: true,
  );
  await insertActivity(hike);

  print(await getActivities());

  // grocery = ToDoItem(id: grocery.id, name: grocery.name, description: 'beef');
  // await updateToDoItem(grocery);

  // print(await getToDoItems());

  // // await deleteToDoItem(grocery.id);

  // print(await getToDoItems());
}

Future<void> insertActivity(Activity activity) async {
  final db = await databaseService();
  await db.insert(
    'activities',
    activity.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Activity>> getActivities() async {
  final db = await databaseService();
  final List<Map<String, Object?>> activitiesMap = await db.query('activities');
  return activitiesMap.map((map) => Activity.fromMap(map)).toList();
}

Future<void> updateActivity(Activity activity) async {
  final db = await databaseService();
  await db.update(
    'activities',
    activity.toMap(),
    where: 'id = ?',
    whereArgs: [activity.id],
  );
}

Future<void> deleteActivity(int id) async {
  final db = await databaseService();
  await db.delete('activities', where: 'id = ?', whereArgs: [id]);
}
