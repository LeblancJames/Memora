import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:memora/activity_details.dart';
import 'package:memora/databases/database_service.dart';
import 'package:memora/models/activity_model.dart';

class VisitedPage extends StatefulWidget {
  const VisitedPage({super.key});

  @override
  State<VisitedPage> createState() => _VisitedPageState();
}

class _VisitedPageState extends State<VisitedPage> {
  // List<Activity> items = [];
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  List<Activity> activities = [];

  @override
  void initState() {
    super.initState();
    loadActivities(); //Load items when widget initializes, basically calls the async function we create here
  }

  Future<void> loadActivities() async {
    List<Activity> fetchedActivities = await getActivities();
    setState(() {
      activities =
          fetchedActivities; //Update UI when data is ready, changes the variable list to fetched items
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredActivities =
        activities
            .where(
              (place) =>
                  place.name.toLowerCase().contains(searchQuery.toLowerCase()),
            )
            .toList();

    return Column(
      children: [
        // Search Bar
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 16,
                  top: 0,
                  bottom: 16,
                ),
                child: TextField(
                  controller: searchController, //can control the text if needed
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 16,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(36),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            //sort button
            Padding(
              padding: const EdgeInsets.only(
                left: 0,
                right: 0,
                top: 0,
                bottom: 12,
              ),
              child: IconButton(
                icon: const Icon(Icons.sort),
                tooltip: 'Sort',
                onPressed: () {
                  // TODO: Implement sort logic
                },
              ),
            ),
            //filter button
            Padding(
              padding: const EdgeInsets.only(
                left: 0,
                right: 16,
                top: 0,
                bottom: 12,
              ),
              child: IconButton(
                icon: const Icon(Icons.filter_list),
                tooltip: 'Filter',
                onPressed: () {
                  // TODO: Open filter modal or sheet
                },
              ),
            ),
          ],
        ),

        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: 12),
            color: Color(0xFFFAFAFA),
            child: ListView.builder(
              itemCount: filteredActivities.length,
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
                                (context) => ActivityDetails(
                                  activity: activities[index],
                                ),
                          ),
                        );
                      },
                      child: Slidable(
                        // Specify a key if the Slidable is dismissible.
                        key: ValueKey(filteredActivities[index]),
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
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFFF1F5FB),
                          ),
                          height: 96,
                          margin: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 24,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  // decoration: BoxDecoration(
                                  //   shape: BoxShape.circle,
                                  //   image: DecorationImage(
                                  //     image: AssetImage(
                                  //       'assets/my_image.jpg',
                                  //     ), // or NetworkImage
                                  //     fit: BoxFit.cover,
                                  //   ),
                                  // ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[200],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 24, right: 24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        filteredActivities[index].name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: const Color.fromARGB(
                                            255,
                                            0,
                                            0,
                                            0,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        filteredActivities[index].location ??
                                            "",
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            0,
                                            0,
                                            0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
        ),
      ],
    );
  }
}

void doNothing(BuildContext context) {}
