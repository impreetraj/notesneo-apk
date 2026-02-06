import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepaknote/widget/pdfopenBook.dart';
import 'package:flutter/material.dart';
import 'package:deepaknote/services/recent_service.dart';
import 'package:deepaknote/services/download_service.dart';

class GenericSemester extends StatefulWidget {
  final String collectionName;
  final String title;

  const GenericSemester({
    Key? key,
    required this.collectionName,
    required this.title,
  }) : super(key: key);

  @override
  State<GenericSemester> createState() => _GenericSemesterState();
}

class _GenericSemesterState extends State<GenericSemester> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.teal[400],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hi there, what", style: TextStyle(color: Colors.white, fontSize: 18)),
                          Text("you learning today?", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.person_outline, color: Colors.white, size: 30),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
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

            // Programs Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryChip("B Tech", true),
                        _buildCategoryChip("BCA", false),
                        _buildCategoryChip("M Tech", false),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Your Programs", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 15),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2.2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 5,
                    children: [
                      _buildYearSection("Year 1", ["Sem 1", "Sem 2"]),
                      _buildYearSection("Year 2", ["Sem 3", "Sem 4"]),
                      _buildYearSection("Year 3", ["Sem 5"]), // Currently shows up to Sem 5
                    ],
                  ),
                ],
              ),
            ),

            // Recommended/Subjects Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text("Recommended for You (${widget.title})", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 15),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("adminsem")
                  .doc("semester")
                  .collection(widget.collectionName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No data"));
                }

                final List<Gradient> gradients = [
                  LinearGradient(colors: [Color(0xFF00B4DB), Color(0xFF0083B0)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  LinearGradient(colors: [Color(0xFF56AB2F), Color(0xFFA8E063)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  LinearGradient(colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  LinearGradient(colors: [Color(0xFFF2994A), Color(0xFFF2C94C)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  LinearGradient(colors: [Color(0xFFFF512F), Color(0xFFDD2476)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ];

                final List<IconData> icons = [
                  Icons.memory,
                  Icons.code,
                  Icons.settings,
                  Icons.calculate,
                  Icons.book,
                  Icons.biotech,
                ];

                var docs = snapshot.data!.docs.where((doc) {
                  final name = (doc.data() as Map<String, dynamic>)['main_name'].toString().toLowerCase();
                  return name.contains(searchQuery);
                }).toList();

                if (docs.isEmpty) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("No matches found"),
                  ));
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> subjectData =
                        docs[index].data() as Map<String, dynamic>;
                    
                    final gradient = gradients[index % gradients.length];
                    final icon = icons[index % icons.length];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UnitsListScreen(
                              subjectName: subjectData['main_name'],
                              unitsData: subjectData,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[100]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: gradient.colors.first.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(icon, size: 32, color: gradient.colors.first),
                              ),
                            ),
                            SizedBox(height: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    subjectData['main_name'].toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.blueGrey[900],
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "View Material",
                                        style: TextStyle(
                                          color: Colors.teal[400],
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios, size: 8, color: Colors.teal[400]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.teal[400] : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildYearSection(String yearLabel, List<String> sems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(yearLabel, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey[700])),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sems.map((semLabel) {
            String colName = "semester${semLabel.split(' ')[1]}";
            return _buildSemChip(semLabel, widget.collectionName == colName);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSemChip(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.teal[400] : Colors.teal[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.teal[400],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class UnitsListScreen extends StatelessWidget {
  final String subjectName;
  final Map<String, dynamic> unitsData;

  const UnitsListScreen({
    Key? key,
    required this.subjectName,
    required this.unitsData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> units = [];
    for (int i = 1; i <= 4; i++) {
      if (unitsData['unit${i}_name'] != null && unitsData['link$i'] != null) {
        units.add({
          'name': unitsData['unit${i}_name'],
          'description': unitsData['unit${i}_description'] ?? "",
          'pdf': unitsData['link$i'],
          'image': unitsData['image$i'] ?? "",
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(subjectName, style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: units.length,
        itemBuilder: (context, index) {
          final unit = units[index];
          return Container(
            margin: EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey[100]!),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.description_outlined, color: Colors.teal),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        unit['name']!,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        unit['description']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.download_outlined, color: Colors.grey),
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Download started...")));
                    await DownloadService.downloadNote(
                      name: unit['name']!,
                      description: unit['description']!,
                      imageUrl: unit['image']!,
                      pdfUrl: unit['pdf']!,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.visibility_outlined, color: Colors.grey),
                  onPressed: () async {
                    await RecentService.addRecent({
                      'name': unit['name'],
                      'image': unit['image'],
                      'pdf': unit['pdf'],
                    });
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PdfOpen(
                            pdf: unit['pdf']!,
                            name: unit['name'],
                            image: unit['image'],
                          ),
                        ),
                      ).then((_) => RecentService.getRecent());
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
