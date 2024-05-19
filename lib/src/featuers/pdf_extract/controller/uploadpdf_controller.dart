import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPdf extends GetxController {
  static AddPdf get instance => Get.find();
  TextEditingController pdfPathController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  final pdfkey = GlobalKey<FormState>();

  RxString vendorName = ''.obs;
  RxString uploadStatus = ''.obs;
  Rx<PlatformFile?> selectedFile = Rx<PlatformFile?>(null);
  RxString filePath = ''.obs;
  @override
  void onInit() {
    AddPdf();
    super.onInit();
  }

  void uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      await uploadPDF(file);
    } else {
      updateUploadStatus("No file selected");
    }
  }

  void updateVendorName(String value) {
    vendorName.value = value;
  }

  validateDescription(String? title) {
    if (title!.isNotEmpty) {
      return null;
    }
    return 'Date is not vaild';
  }

  Future<void> uploadPDF(PlatformFile file) async {
    selectedFile.value = file; // Update selected file
    String fileName = "${DateTime.now()}_${vendorName.value}.pdf";
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('vendor_pdfs/$fileName');

    try {
      await ref.putFile(File(file.path!));
      String pdfPath = await ref.getDownloadURL();
      updateUploadStatus("PDF uploaded successfully!");
      filePath.value = pdfPath;
      update();
    } catch (error) {
      updateUploadStatus("Error uploading PDF");
    }
  }

  void updateUploadStatus(String status) {
    uploadStatus.value = status;
  }

  Future<void> deletePDFByVendorName(String vendorName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('vendor_pdfs')
          .where('vendorName', isEqualTo: vendorName)
          .get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        await documentSnapshot.reference.delete();
        selectedFile.value = null;
        update();
      }

      updateUploadStatus("PDFs deleted successfully!");
    } catch (error) {
      updateUploadStatus("Error deleting PDFs");
    }
  }
}
