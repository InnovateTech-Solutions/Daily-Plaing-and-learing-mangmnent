import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/widget/buttons/buttons.dart';
import 'package:demogp/src/featuers/pdf_extract/view/extract_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Uploader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PdfUpload(),
    );
  }
}

class PdfUpload extends StatefulWidget {
  const PdfUpload({super.key});

  @override
  _PdfUploadState createState() => _PdfUploadState();
}

class _PdfUploadState extends State<PdfUpload> {
  String? path;
  bool isLoading = false;

  Future<void> _pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        isLoading = true;
      });

      try {
        final file = result.files.single;
        final filePath = file.path!;
        final fileName = file.name;

        // Upload to Firebase Storage
        final storageRef =
            FirebaseStorage.instance.ref().child('uploads/$fileName');
        final uploadTask = storageRef.putFile(File(filePath));
        final snapshot = await uploadTask.whenComplete(() => {});
        // Get the download URL
        final downloadUrl = await snapshot.ref.getDownloadURL();

        // Save the file path in Firestore
        await FirebaseFirestore.instance.collection('files').add({
          'fileName': fileName,
          'url': downloadUrl,
        });

        setState(() {
          path = downloadUrl;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload file: $e')),
        );
      }
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Your PDF'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.picture_as_pdf,
                      size: 100,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Upload Your PDF',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: isLoading ? null : _pickAndUploadFile,
                      icon: const Icon(Icons.upload_file),
                      label: Text(isLoading ? 'Uploading...' : 'Select PDF'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (path != null)
                Column(
                  children: [
                    Text(
                      'File uploaded to: $path',
                      style: const TextStyle(fontSize: 16, color: Colors.green),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              Expanded(child: Container()),
              Buttons.selectedButton(
                  'lets go',
                  () => path == null
                      ? Get.snackbar("Filed", "please upload the pdf",
                          snackPosition: SnackPosition.BOTTOM,
                          colorText: AppColor.mainAppColor,
                          backgroundColor: AppColor.error)
                      : Get.to(PdfTextExtractorScreen(
                          pdfPath: path ?? '',
                        )))
            ],
          ),
        ),
      ),
    );
  }
}
