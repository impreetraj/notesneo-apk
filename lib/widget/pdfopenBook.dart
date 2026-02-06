import 'dart:io';
import 'package:flutter/material.dart';
import 'package:deepaknote/services/recent_service.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfOpen extends StatefulWidget {
  final String pdf;
  final String? name;
  final String? image;
  final int? initialPage;
  const PdfOpen({Key? key, required this.pdf, this.name, this.image, this.initialPage}) : super(key: key);

  @override
  State<PdfOpen> createState() => _PdfOpenState();
}

class _PdfOpenState extends State<PdfOpen> {
  late PdfViewerController _pdfController;
  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
    if (widget.name != null && widget.pdf.isNotEmpty) {
      final note = {
        'name': widget.name,
        'image': widget.image ?? "",
        'pdf': widget.pdf,
      };
      if (widget.initialPage != null) note['page'] = widget.initialPage.toString();
      RecentService.addRecent(note);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isNetwork = widget.pdf.startsWith('http');
    File pdfFile = File(widget.pdf);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("PDF Viewer"),
        centerTitle: true,
      ),
      body: isNetwork
          ? SfPdfViewer.network(
              widget.pdf,
              controller: _pdfController,
              onDocumentLoaded: (details) {
                if (widget.initialPage != null) {
                  _pdfController.jumpToPage(widget.initialPage!);
                }
              },
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
                  controller: _pdfController,
                  onDocumentLoaded: (details) {
                    if (widget.initialPage != null) {
                      _pdfController.jumpToPage(widget.initialPage!);
                    }
                  },
                  onPageChanged: (details) {
                    RecentService.addRecent({
                      'name': widget.name,
                      'image': widget.image ?? "",
                      'pdf': widget.pdf,
                      'page': details.newPageNumber.toString(),
                    });
                  },
                )
              : Center(
                  child: Text(
                    "File not found!",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ),
    );
  }
}