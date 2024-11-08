import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfOpen extends StatefulWidget {
  final String pdf;
  const PdfOpen({
    Key? key,
    required this.pdf,
  });

  @override
  State<PdfOpen> createState() => _PdfOpenState();
}

class _PdfOpenState extends State<PdfOpen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("Pdf View"),
        centerTitle: true,
      ),
      body: SfPdfViewer.network(widget.pdf),
    );
  }
}
