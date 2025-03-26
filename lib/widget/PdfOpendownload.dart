import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfOpens extends StatefulWidget {
  final String pdf;
  const PdfOpens({Key? key, required this.pdf}) : super(key: key);

  @override
  State<PdfOpens> createState() => _PdfOpensState();
}

class _PdfOpensState extends State<PdfOpens> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late PdfViewerController _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    File pdfFile = File(widget.pdf);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text("PDF Viewer"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _pdfViewerKey.currentState?.openBookmarkView();
        },
        child: const Icon(Icons.bookmark),
      ),
      body: pdfFile.existsSync()
          ? SfPdfViewer.file(
              pdfFile,
              key: _pdfViewerKey,
              controller: _pdfController,
            )
          : const Center(
              child: Text(
                "File not found!",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
    );
  }
}
