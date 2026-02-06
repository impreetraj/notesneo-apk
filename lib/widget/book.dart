import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepaknote/Semester/btech/sem_common.dart';
import 'package:flutter/material.dart';

class Book extends StatefulWidget {
  const Book({super.key});

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  String selectedCourse = "B Tech";
  int selectedYear = 1;
  int selectedSemester = 1;
  String searchQuery = "";

  // 🔥 Must be >= 44 to avoid clipping
  static const double filterHeight = 44;

  @override
  Widget build(BuildContext context) {
    String collectionName = "semester$selectedSemester";
    String title = "$selectedCourse - Sem $selectedSemester";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= HEADER =================
            Container(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.teal[400],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hi there, what",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const Text(
                    "you learning today?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      onChanged: (v) => setState(() => searchQuery = v.toLowerCase()),
                      decoration: const InputDecoration(
                        hintText: "Search for notes, keywords...",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ================= FILTERS =================
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...["B Tech", "BCA", "M Tech"].map(
                          (course) => _buildCategoryChip(course, selectedCourse == course),
                        ),

                        const SizedBox(width: 10),

                        // ✅ YEAR DROPDOWN (FIXED)
                        SizedBox(
                          height: filterHeight,
                          width: 120,
                          child: DropdownButtonFormField<int>(
                            value: selectedYear,
                            isDense: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10, // 🔥 IMPORTANT
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              height: 1.2, // 🔥 prevents text cut
                              color: Colors.black87,
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedYear = value!;
                                selectedSemester = (selectedYear * 2) - 1;
                              });
                            },
                            items: _getYearList(selectedCourse)
                                .map(
                                  (value) => DropdownMenuItem<int>(
                                    value: value,
                                    child: Text("Year $value"),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Select Semester",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 10,
                    children: [
                      _buildSemChip(
                        "Sem ${(selectedYear * 2) - 1}",
                        selectedSemester == (selectedYear * 2) - 1,
                        (selectedYear * 2) - 1,
                      ),
                      _buildSemChip(
                        "Sem ${selectedYear * 2}",
                        selectedSemester == selectedYear * 2,
                        selectedYear * 2,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ================= TITLE =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Notes for You ($title)",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 15),

            // ================= GRID =================
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("adminsem")
                  .doc("semester")
                  .collection(collectionName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs.where((doc) {
                  final name = (doc['main_name'] as String).toLowerCase();
                  return name.contains(searchQuery);
                }).toList();

                if (docs.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No matches found"),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;

                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UnitsListScreen(
                            subjectName: data['main_name'],
                            unitsData: data,
                          ),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.book, size: 32, color: Colors.teal),
                            Text(
                              data['main_name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              "View Material",
                              style: TextStyle(fontSize: 10, color: Colors.teal),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ================= HELPERS =================
  List<int> _getYearList(String course) {
    if (course == "B Tech") return [1, 2, 3, 4];
    if (course == "BCA") return [1, 2, 3];
    return [1, 2];
  }

  Widget _buildCategoryChip(String label, bool selected) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedCourse = label;
          selectedYear = 1;
          selectedSemester = 1;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        height: filterHeight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.teal[400] : Colors.grey[200],
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSemChip(String label, bool selected, int sem) {
    return InkWell(
      onTap: () => setState(() => selectedSemester = sem),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.teal[400] : Colors.teal[50],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.teal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
