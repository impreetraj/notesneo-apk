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
    final uri = Uri.tryParse(widget.pdf);
    final isNetwork = uri != null && (uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https'));

    Widget body;
    if (isNetwork) {
      body = SfPdfViewer.network(widget.pdf);
    } else {
      final File pdfFile = File(widget.pdf);
      body = pdfFile.existsSync()
          ? SfPdfViewer.file(pdfFile)
          : Center(
              child: Text(
                "File not found!",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("PDF Viewer"),
        centerTitle: true,
      ),
      body: body,
    );
  }
}