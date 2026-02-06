import 'package:flutter/material.dart';
import 'package:deepaknote/Semester/btech/sem_common.dart';

class SemesterTwo extends StatelessWidget {
  const SemesterTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericSemester(collectionName: 'semester2', title: 'Semester 2');
  }
}
