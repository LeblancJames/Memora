import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:memora/activity_details.dart';

class VisitedPage extends StatefulWidget {
  const VisitedPage({super.key});

  @override
  State<VisitedPage> createState() => _VisitedPageState();
}

class _VisitedPageState extends State<VisitedPage> {
  // List<Activity> items = [];
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  List<String> items = ['a', 'b'];

  @override
  Widget build(BuildContext context) {
    final filteredItems =
        items
            .where(
              (place) =>
                  place.toLowerCase().contains(searchQuery.toLowerCase()),
            )
            .toList();

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 112,
            top: 0,
            bottom: 16,
          ),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search places...',
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(36),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  //individual items
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              // (context) => Activitydetails(toDoItem: items[index]),
                              (context) => Activitydetails(),
                        ),
                      );
                    },
                    child: Slidable(
                      // Specify a key if the Slidable is dismissible.
                      key: ValueKey(items[index]),
                      // The end action pane is the one at the right or the bottom side.
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            // onPressed: (context) => deleteItems(items[index]),
                            onPressed: doNothing,
                            backgroundColor: const Color(0xFFFE4A49),
                            foregroundColor: const Color.fromARGB(
                              255,
                              255,
                              255,
                              255,
                            ),
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),

                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color.fromARGB(255, 201, 199, 199),
                        ),
                        height: 50,
                        margin: EdgeInsets.all(4),
                        child: Center(
                          child: Text(
                            items[index],
                            style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

void doNothing(BuildContext context) {}
