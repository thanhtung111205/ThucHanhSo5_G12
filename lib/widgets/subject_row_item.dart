import 'package:flutter/material.dart';
import 'package:ThucHanhSo5_G12/models/subject.dart';

class SubjectRowItem extends StatelessWidget {
  final Subject subject;

  const SubjectRowItem({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return DataRow(
      cells: [
        DataCell(Text(subject.name)),
        DataCell(Text(subject.credits.toString())),
        DataCell(Text(subject.score.toString())),
      ],
    );
  }
}
