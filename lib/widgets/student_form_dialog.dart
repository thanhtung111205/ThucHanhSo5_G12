import 'package:flutter/material.dart';

class StudentFormDialog extends StatelessWidget {
  const StudentFormDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text('Add/Edit Student'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: 'Name')),
            TextField(decoration: InputDecoration(labelText: 'Student ID')),
            TextField(decoration: InputDecoration(labelText: 'Date of Birth')),
          ],
        ),
      ),
    );
  }
}
