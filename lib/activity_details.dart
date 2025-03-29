import 'package:flutter/material.dart';
import 'package:memora/databases/database_service.dart';
import 'package:memora/models/activity_model.dart';

class ActivityDetails extends StatefulWidget {
  final Activity? activity;
  const ActivityDetails({super.key, this.activity});

  @override
  State<ActivityDetails> createState() => _ActivityDetailsState();
}

class _ActivityDetailsState extends State<ActivityDetails> {
  var nameController = TextEditingController();
  var locationController = TextEditingController();
  var notesController = TextEditingController();
  var selectedCategoryIndex = List<bool>.filled(5, false);
  var selectedCategoryIndexTwo = List<bool>.filled(5, false);

  int rating = 0;
  bool isVisited = false;

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

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.activity!.name.toString(),
    );
    locationController = TextEditingController(
      text: widget.activity!.location.toString(),
    );
    notesController = TextEditingController(
      text: widget.activity!.notes.toString(),
    );
    selectedCategoryIndex = widget.activity!.categoriesOne.toList();
    selectedCategoryIndexTwo = widget.activity!.categoriesTwo.toList();
    rating = widget.activity!.rating.toInt();
    isVisited = widget.activity!.visited;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void selectRating(int index) {
    setState(() {
      if (rating == index) {
        rating = 0;
      } else {
        rating = index;
      }
    });
  }

  void addActivity() async {
    Activity newActivity;
    String name = nameController.text;
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: EdgeInsets.all(30),
          content: Text("Can't add activity without a name"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      newActivity = Activity(
        id: widget.activity?.id ?? 0,
        name: nameController.text,
        location: locationController.text,
        categoriesOne: selectedCategoryIndex,
        categoriesTwo: selectedCategoryIndexTwo,
        notes: notesController.text,
        rating: rating,
        visited: isVisited,
      );
      if (newActivity.id == 0) {
        await insertActivity(newActivity);
      } else {
        await updateActivity(newActivity);
      }
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        // title: const Text("Activity"),
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 64, horizontal: 64),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEAEAEA), width: 1.5),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEAEAEA), width: 2.0),
                ),
              ),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEAEAEA), width: 1.5),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEAEAEA), width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Photos",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(children: [photoBox(icon: Icons.add)]),
            const SizedBox(height: 16),
            Text(
              "Category",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(categories.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedCategoryIndex[index] == false) {
                        selectedCategoryIndex[index] = true;
                      } else {
                        selectedCategoryIndex[index] = false;
                      }
                    });
                  },
                  child: Icon(
                    categories[index],
                    size: 32,
                    color:
                        selectedCategoryIndex[index] == true
                            ? Colors.blue
                            : Colors.black,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(categoriesSecondRow.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedCategoryIndexTwo[index] == false) {
                        selectedCategoryIndexTwo[index] = true;
                      } else {
                        selectedCategoryIndexTwo[index] = false;
                      }
                    });
                  },
                  child: Icon(
                    categoriesSecondRow[index],
                    size: 32,
                    color:
                        selectedCategoryIndexTwo[index] == true
                            ? Colors.blue
                            : Colors.black,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Notes',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEAEAEA), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEAEAEA), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () => selectRating(index + 1),
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                  );
                }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Visited',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Switch(
                  value: isVisited,
                  onChanged: (value) {
                    setState(() {
                      isVisited = value;
                    });
                  },
                  activeColor: Color(0xFF4A90E2),
                ),
              ],
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFFF5F5F5),
                        foregroundColor: Color(0xFF4A90E2),
                        textStyle: const TextStyle(fontSize: 16),

                        padding: const EdgeInsets.symmetric(vertical: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size.fromHeight(56),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                ),
                const Divider(thickness: 1, height: 32),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        addActivity();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size.fromHeight(56),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget photoBox({IconData? icon}) {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF4A90E2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          icon != null
              ? Icon(icon, color: Color(0xFF4A90E2))
              : const SizedBox.shrink(),
    );
  }
}
