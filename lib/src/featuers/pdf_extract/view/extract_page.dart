import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/core/model/form_model.dart';
import 'package:demogp/src/core/widget/buttons/buttons.dart';
import 'package:demogp/src/core/widget/form/mission_form.dart';
import 'package:demogp/src/core/widget/text/text.dart';
import 'package:demogp/src/featuers/add_mission/controller/mission_controller.dart';
import 'package:demogp/src/featuers/pdf_extract/controller/uploadpdf_controller.dart';
import 'package:demogp/src/featuers/pdf_extract/view/reponse_page.dart';
import 'package:demogp/src/featuers/signup/controller/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfTextExtractorScreen extends StatefulWidget {
  const PdfTextExtractorScreen({required this.pdfPath, super.key});
  final String pdfPath;

  @override
  _PdfTextExtractorScreenState createState() => _PdfTextExtractorScreenState();
}

class _PdfTextExtractorScreenState extends State<PdfTextExtractorScreen> {
  String pdftxt = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddPdf());
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Text Extractor'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Form(
          key: controller.pdfkey,
          child: Column(
            children: [
              TextApp.mainAppText('Choose your date frame'),
              const Gap(35),
              MissoionForm(
                textForm: FormModel(
                  controller: controller.startDateController,
                  enableText: true,
                  hintText: "Start date",
                  icon: const Icon(Icons.date_range_outlined),
                  invisible: false,
                  validator: (username) => controller.validateDescription(username),
                  type: TextInputType.datetime,
                  onChange: null,
                  inputFormat: [],
                  onTap: () => _selectDate(context, controller.startDateController),
                ),
              ),
              const Gap(35),
              MissoionForm(
                textForm: FormModel(
                  controller: controller.endDateController,
                  enableText: true,
                  hintText: "End date",
                  icon: const Icon(Icons.date_range_outlined),
                  invisible: false,
                  validator: (username) => controller.validateDescription(username),
                  type: TextInputType.datetime,
                  onChange: null,
                  inputFormat: [],
                  onTap: () => _selectDate(context, controller.endDateController),
                ),
              ),
              const Gap(35),
              Buttons.selectedButton("Generate your PDF", () async {
                if (controller.startDateController.text.isEmpty && controller.endDateController.text.isEmpty) {
                  Get.snackbar(
                    "ERROR",
                    "Please enter the date",
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: AppColor.mainAppColor,
                    backgroundColor: AppColor.error,
                  );
                } else {
                  await extractTextFromPdf(widget.pdfPath);
                  Get.to(() => SchuldePage(searchtxt: pdftxt, strartDate: controller.startDateController.text, endDate: controller.endDateController.text,));
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> extractTextFromPdf(String path) async {
    setState(() {
      isLoading = true;
    });

    String pdfUrl = path; // Replace with your PDF URL
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

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Restrict to today's date
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      controller.text = formattedDate;
    }
  }
}
