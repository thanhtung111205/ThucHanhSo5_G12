import 'package:flutter/material.dart';

class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: TextField(
            decoration: InputDecoration(hintText: 'Search...'),
          ),
        ),
        DropdownButton<String>(
          items: const [], // Add filter options
          onChanged: (value) {},
        ),
      ],
    );
  }
}
