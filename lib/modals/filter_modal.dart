import 'package:flutter/material.dart';

void showFilterModal({
  required BuildContext context,
  required List<IconData> categories,
  required List<IconData> categoriesTwo,
  required List<bool> selectedFiltersOne,
  required List<bool> selectedFiltersTwo,
  required Function(List<bool> newOne, List<bool> newTwo) onApply,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      // Create temp copies of filters to avoid mutating real state before apply
      final List<bool> tempFiltersOne = List.from(selectedFiltersOne);
      final List<bool> tempFiltersTwo = List.from(selectedFiltersTwo);

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
                            tempFiltersOne[index] ? Colors.blue : Colors.black,
                      ),
                      selected: tempFiltersOne[index],
                      showCheckmark: false,
                      selectedColor: Colors.blue[100],
                      backgroundColor: Colors.grey[200],
                      onSelected: (selected) {
                        setModalState(() {
                          tempFiltersOne[index] = selected;
                        });
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
                            tempFiltersTwo[index] ? Colors.blue : Colors.black,
                      ),
                      selected: tempFiltersTwo[index],
                      showCheckmark: false,
                      selectedColor: Colors.blue[100],
                      backgroundColor: Colors.grey[200],
                      onSelected: (selected) {
                        setModalState(() {
                          tempFiltersTwo[index] = selected;
                        });
                      },
                    );
                  }),
                ),

                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onApply(tempFiltersOne, tempFiltersTwo);
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
