import 'package:flutter/material.dart';
import 'package:deepaknote/Semester/btech/sem_common.dart';

class SemesterOne extends StatelessWidget {
  const SemesterOne({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericSemester(collectionName: 'semester1', title: 'Semester 1');
  }
}
