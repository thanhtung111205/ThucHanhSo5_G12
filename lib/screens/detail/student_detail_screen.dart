import 'package:flutter/material.dart';

class StudentDetailScreen extends StatelessWidget {
  const StudentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
      ),
      body: const Center(
        child: Text('Student Detail Screen'),
      ),
    );
  }
}
