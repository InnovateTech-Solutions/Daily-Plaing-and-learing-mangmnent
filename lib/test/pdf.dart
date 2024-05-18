import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class MyPdfViewer extends StatefulWidget {
  final String pdfUrl;

  const MyPdfViewer({required this.pdfUrl});

  @override
  _MyPdfViewerState createState() => _MyPdfViewerState();
}

class _MyPdfViewerState extends State<MyPdfViewer> {
  int totalPages = 0;
  bool isReady = false;
  String errorMessage = '';
  String? filePath;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new_outlined)),
        title: const Text('PDF Viewer'),
      ),
      body: Stack(
        children: [
          if (filePath != null)
            PDFView(
              filePath: filePath!,
              fitEachPage: true,
              fitPolicy: FitPolicy.BOTH,
              onRender: (pages) {
                setState(() {
                  totalPages = pages ?? 0;
                });
              },
              onError: (error) {
                setState(() {
                  errorMessage = error.toString();
                });
              },
              onPageError: (page, error) {
                setState(() {
                  errorMessage = '$error';
                });
              },
            ),
          if (errorMessage.isNotEmpty)
            Center(
              child: Text(errorMessage),
            ),
          if (!isReady)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  _loadPdf() async {
    try {
      final response = await http.get(Uri.parse(widget.pdfUrl));
      final data = response.bodyBytes;
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_file.pdf');
      await file.writeAsBytes(data);
      setState(() {
        filePath = file.path;
        isReady = true; // Set isReady to true when PDF is loaded
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }
}
