import 'dart:io';

import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/widget/text/text.dart';
import 'package:demogp/src/featuers/pdf_extract/controller/uploadpdf_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PdfUpload(),
    );
  }
}

class PdfUpload extends StatefulWidget {
  const PdfUpload({super.key}) ;

  @override
  State<PdfUpload> createState() => _PdfUploadState();
}

class _PdfUploadState extends State<PdfUpload> {

@override
void initState() {
  super.initState();
}
  @override
  Widget build(BuildContext context) {
      final pdfController = Get.put(AddPdf());

    return Scaffold(
      body: Column(
        children: [
          Text("data"),
          TextApp.subAppText("Enter your pdf to get your schedule"),
          GestureDetector(
            onTap: () {
              pdfController.uploadFile();
            },
            child: Container(
              height: 120.h,
              width: 200.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.r),
                color: AppColor.subappcolor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    if (pdfController.selectedFile.value == null) {
                      return Center(
                        child: Column(
                          children: [
                            Gap(20),
                            Icon(
                              Icons.add,
                              color: AppColor.subappcolor,
                              size: 50,
                            ),
                          ],
                        ),
                      ); // Empty container when no file is selected
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5.h),
                            width: 90.w,
                            height: 65.h,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'https://cdn-icons-png.flaticon.com/512/3997/3997608.png'))),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () =>
                                      {pdfController.uploadFile()},
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () => {
                                        pdfController.deletePDFByVendorName(
                                            pdfController.vendorName.value)
                                      },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ))
                            ],
                          )
                        ],
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
