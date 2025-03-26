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

  List<String> items = ['a', 'b'];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
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
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

void doNothing(BuildContext context) {}
