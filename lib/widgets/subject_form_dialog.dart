import 'package:flutter/material.dart';

class SubjectFormDialog extends StatelessWidget {
  const SubjectFormDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text('Add/Edit Subject'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: 'Subject Name')),
            TextField(decoration: InputDecoration(labelText: 'Credits')),
            TextField(decoration: InputDecoration(labelText: 'Score')),
          ],
        ),
      ),
    );
  }
}
