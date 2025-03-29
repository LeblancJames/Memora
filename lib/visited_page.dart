import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:memora/activity_details.dart';
import 'package:memora/databases/database_service.dart';
import 'package:memora/filter_modal.dart';
import 'package:memora/models/activity_model.dart';

class VisitedPage extends StatefulWidget {
  const VisitedPage({super.key});

  @override
  State<VisitedPage> createState() => _VisitedPageState();
}

class _VisitedPageState extends State<VisitedPage> {
  final List<IconData> categories = [
    Icons.restaurant, // Food & Drink
    Icons.hiking, // Outdoor Adventures
    Icons.beach_access, // Shopping
    Icons.theater_comedy, // Entertainment
    Icons.shopping_bag, // Shopping
  ];
  final List<IconData> categoriesSecondRow = [
    Icons.local_cafe, // Cafe
    Icons.local_bar, // Bar
    Icons.account_balance, // Museums/Historical Sites
    Icons.airplanemode_active, //Travel destinations
    Icons.photo, // Other
  ];

  List<Activity> activities = [];
  List<Activity> filteredActivities = [];
  late List<bool> selectedCategoryFiltersOne;
  late List<bool> selectedCategoryFiltersTwo;
  // List<Activity> items = [];
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    loadActivities(); //Load items when widget initializes, basically calls the async function we create here

    selectedCategoryFiltersOne = List.filled(categories.length, false);
    selectedCategoryFiltersTwo = List.filled(categoriesSecondRow.length, false);
  }

  Future<void> loadActivities() async {
    List<Activity> fetchedActivities = await getVisistedActivities();
    setState(() {
      activities =
          fetchedActivities; //Update UI when data is ready, changes the variable list to fetched items
    });
  }

  void deleteItems(int id) {
    deleteActivity(id);

    setState(() {
      activities.removeWhere((item) => item.id == id);
    });
  }

  void applyFilters() {
    setState(() {
      filteredActivities =
          activities.where((activity) {
            for (int i = 0; i < selectedCategoryFiltersOne.length; i++) {
              if (selectedCategoryFiltersOne[i] && activity.categoriesOne[i]) {
                return true;
              }
            }
            for (int i = 0; i < selectedCategoryFiltersTwo.length; i++) {
              if (selectedCategoryFiltersTwo[i] && activity.categoriesTwo[i]) {
                return true;
              }
            }
            return false;
          }).toList();
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
                  doNothing(context);
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
                  showFilterModal(
                    context: context,
                    categories: categories,
                    categoriesTwo: categoriesSecondRow,
                    selectedFiltersOne: selectedCategoryFiltersOne,
                    selectedFiltersTwo: selectedCategoryFiltersTwo,
                    onFilterToggleOne: (index, selected) {
                      setState(() {
                        selectedCategoryFiltersOne[index] = selected;
                      });
                    },
                    onFilterToggleTwo: (index, selected) {
                      setState(() {
                        selectedCategoryFiltersTwo[index] = selected;
                      });
                    },
                    onApply: applyFilters,
                  );
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
                              onPressed:
                                  (context) =>
                                      deleteItems(activities[index].id!),

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
