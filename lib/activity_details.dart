import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memora/databases/database_service.dart';
import 'package:memora/fullscreen_photo.dart';
import 'package:memora/models/activity_model.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:reorderables/reorderables.dart';

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
  final List<File> photos = [];
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

    if (widget.activity?.photoPaths != null) {
      photos.addAll(widget.activity!.photoPaths.map((path) => File(path)));
    }
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
    final imagePaths = photos.map((file) => file.path).toList();

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
        photoPaths: imagePaths,
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

  Future<void> addPhoto() async {
    final picker = ImagePicker();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take Photo'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Choose from Gallery'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
          ),
    );

    if (source != null) {
      final picked = await picker.pickImage(source: source, imageQuality: 80);
      if (picked != null) {
        final saved = await _saveImageToAppStorage(File(picked.path));
        setState(() => photos.add(saved));
      }
    }
  }

  void removePhoto(File file) async {
    setState(() {
      photos.remove(file);
    });

    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<File> _saveImageToAppStorage(File original) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(original.path);
    final savedImage = await original.copy('${appDir.path}/$fileName');
    return savedImage;
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

            ReorderableWrap(
              spacing: 12,
              runSpacing: 12,
              needsLongPressDraggable: true,
              buildDraggableFeedback: (context, constraints, child) {
                return Material(
                  color: Colors.transparent,
                  elevation: 8,
                  child: child,
                );
              },
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  // Prevent dragging the add button (index 0)
                  if (oldIndex == 0 || newIndex == 0) return;
                  if (newIndex > oldIndex) newIndex -= 1;
                  final moved = photos.removeAt(oldIndex - 1);
                  photos.insert(newIndex - 1, moved);
                });
              },
              children: [
                // Add button
                GestureDetector(
                  onTap: addPhoto,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add, color: Colors.blue),
                  ),
                ),

                // Draggable photos
                for (var file in photos)
                  SizedBox(
                    key: ValueKey(file.path),
                    width: 72,
                    height: 72,
                    child: GestureDetector(
                      onTap: () async {
                        final shouldDelete = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenPhotoView(file: file),
                          ),
                        );
                        if (shouldDelete == true) {
                          setState(() => photos.remove(file));
                          removePhoto(file);
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(file, fit: BoxFit.cover),
                      ),
                    ),
                  ),
              ],
            ),

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
