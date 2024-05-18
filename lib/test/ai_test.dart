import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Text Extractor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PdfTextExtractorScreen(),
    );
  }
}

class PdfTextExtractorScreen extends StatefulWidget {
  const PdfTextExtractorScreen({Key? key}) : super(key: key);

  @override
  _PdfTextExtractorScreenState createState() => _PdfTextExtractorScreenState();
}

class _PdfTextExtractorScreenState extends State<PdfTextExtractorScreen> {
  String pdftxt = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Text Extractor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                extractTextFromPdf();
              },
              child: const Text('Extract Text from PDF'),
            ),
            const SizedBox(height: 20),
            Text(
              pdftxt,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void extractTextFromPdf() async {
    String pdfUrl = 'https://firebasestorage.googleapis.com/v0/b/dplm-94d38.appspot.com/o/pdfs%2Fbasel-linux.pdf?alt=media&token=d3ce6c20-a96f-4b19-ba69-482756e511f2'; // Replace with your PDF URL
    final response = await http.get(Uri.parse(pdfUrl));

    if (response.statusCode == 200) {
      final pdfBytes = response.bodyBytes;
      PdfDocument document = PdfDocument(inputBytes: pdfBytes);
      String text = PdfTextExtractor(document).extractText();
      setState(() {
        pdftxt = text;
      });
    } else {
      print('Failed to load PDF: ${response.statusCode}');
    }
  }
}
