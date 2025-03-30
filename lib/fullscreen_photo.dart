import 'dart:io';

import 'package:flutter/material.dart';

class FullScreenPhotoView extends StatelessWidget {
  final File file;

  const FullScreenPhotoView({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text("Delete Photo?"),
                      content: const Text(
                        "Are you sure you want to delete this photo?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
              );

              if (confirm == true) {
                Navigator.pop(context, true); // return value to delete
              }
            },
          ),
        ],
      ),
      body: Center(child: Image.file(file)),
    );
  }
}
