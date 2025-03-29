import 'package:flutter/material.dart';

enum ActivityFilter { nameAZ, nameZA, locationAZ, locationZA }

//change variables to something more UI friendly by using switch, simply do variable_name.label to get the label extension
extension ActivityFilterExtension on ActivityFilter {
  String get label {
    switch (this) {
      case ActivityFilter.nameAZ:
        return 'Name A-Z';
      case ActivityFilter.nameZA:
        return 'Name Z-A';
      case ActivityFilter.locationAZ:
        return 'Location A-Z';
      case ActivityFilter.locationZA:
        return 'Location Z-A';
    }
  }
}

void showSortModal({
  required BuildContext context,
  required ActivityFilter selectedFilter,
  required ValueChanged<ActivityFilter> onSelected,
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
                  "Sort By",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                //spread operator to inject each Activity filter value as a seperate child
                ...ActivityFilter.values.map((filter) {
                  final isSelected = filter == selectedFilter;
                  return ListTile(
                    leading: Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                    title: Text(
                      filter.label,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.blue : Colors.black,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onSelected(filter);
                    },
                  );
                }).toList(),
              ],
            ),
          );
        },
      );
    },
  );
}
