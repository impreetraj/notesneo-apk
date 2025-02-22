import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfOpen extends StatefulWidget {
  final String pdf;
  const PdfOpen({Key? key, required this.pdf}) : super(key: key);

  @override
  State<PdfOpen> createState() => _PdfOpenState();
}

class _PdfOpenState extends State<PdfOpen> {
  @override
  Widget build(BuildContext context) {
    File pdfFile = File(widget.pdf);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("PDF Viewer"),
        centerTitle: true,
      ),
      body: pdfFile.existsSync()
          ? SfPdfViewer.file(pdfFile)
          : Center(
              child: Text(
                "File not found!",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
    );
  }
}
