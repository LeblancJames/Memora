import 'package:flutter/material.dart';

class ActivityDetails extends StatefulWidget {
  const ActivityDetails({super.key});

  @override
  State<ActivityDetails> createState() => _ActivityDetailsState();
}

class _ActivityDetailsState extends State<ActivityDetails> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  int selectedCategoryIndex = 0;
  int selectedCategoryIndexRowTwo = 0;

  double rating = 0;
  bool isVisited = false;

  final List<IconData> categories = [
    Icons.restaurant, // Food & Drink
    Icons.hiking, // Outdoor Adventures
    Icons.beach_access, // Beach
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

  void selectRating(double rating) {
    setState(() {
      rating = rating;
    });
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
                      selectedCategoryIndex = index;
                    });
                  },
                  child: Icon(
                    categories[index],
                    size: 32,
                    color:
                        selectedCategoryIndex == index
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
                      selectedCategoryIndexRowTwo = index;
                    });
                  },
                  child: Icon(
                    categoriesSecondRow[index],
                    size: 32,
                    color:
                        selectedCategoryIndexRowTwo == index
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
                        // Save logic here
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
