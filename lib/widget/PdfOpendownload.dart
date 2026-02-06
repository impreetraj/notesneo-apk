import 'dart:io';
import 'package:flutter/material.dart';
import 'package:deepaknote/services/recent_service.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfOpens extends StatefulWidget {
  final String pdf;
  final String? name;
  final String? image;
  const PdfOpens({Key? key, required this.pdf, this.name, this.image}) : super(key: key);

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
    if (widget.name != null && widget.pdf.isNotEmpty) {
      RecentService.addRecent({
        'name': widget.name,
        'image': widget.image ?? "",
        'pdf': widget.pdf,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isNetwork = widget.pdf.startsWith('http');
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
      body: isNetwork
          ? SfPdfViewer.network(
              widget.pdf,
              key: _pdfViewerKey,
              controller: _pdfController,
              onPageChanged: (details) {
                RecentService.addRecent({
                  'name': widget.name,
                  'image': widget.image ?? "",
                  'pdf': widget.pdf,
                  'page': details.newPageNumber.toString(),
                });
              },
            )
          : pdfFile.existsSync()
              ? SfPdfViewer.file(
                  pdfFile,
                  key: _pdfViewerKey,
                  controller: _pdfController,
                  onPageChanged: (details) {
                    RecentService.addRecent({
                      'name': widget.name,
                      'image': widget.image ?? "",
                      'pdf': widget.pdf,
                      'page': details.newPageNumber.toString(),
                    });
                  },
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
