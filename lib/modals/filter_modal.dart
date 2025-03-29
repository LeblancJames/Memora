import 'package:flutter/material.dart';

void showFilterModal({
  required BuildContext context,
  required List<IconData> categories,
  required List<IconData> categoriesTwo,
  required List<bool> selectedFiltersOne,
  required List<bool> selectedFiltersTwo,
  required Function(int index, bool selected) onFilterToggleOne,
  required Function(int index, bool selected) onFilterToggleTwo,
  required VoidCallback onApply,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Filter by Category",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Row 1
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(categories.length, (index) {
                    return FilterChip(
                      label: Icon(
                        categories[index],
                        color:
                            selectedFiltersOne[index]
                                ? Colors.blue
                                : Colors.black,
                      ),
                      selected: selectedFiltersOne[index],
                      showCheckmark: false,
                      selectedColor: Colors.blue[100],
                      backgroundColor: Colors.grey[200],
                      onSelected: (selected) {
                        onFilterToggleOne(index, selected);
                        setModalState(() {});
                      },
                    );
                  }),
                ),

                const SizedBox(height: 16),

                // Row 2
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(categoriesTwo.length, (index) {
                    return FilterChip(
                      label: Icon(
                        categoriesTwo[index],
                        color:
                            selectedFiltersTwo[index]
                                ? Colors.blue
                                : Colors.black,
                      ),
                      selected: selectedFiltersTwo[index],
                      showCheckmark: false,
                      selectedColor: Colors.blue[100],
                      backgroundColor: Colors.grey[200],
                      onSelected: (selected) {
                        onFilterToggleTwo(index, selected);
                        setModalState(() {});
                      },
                    );
                  }),
                ),

                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onApply();
                    },
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
