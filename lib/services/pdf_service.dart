import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../models/student.dart';

class PdfService {
  Future<Uint8List> generateStudentReport(List<Student> students) async {
    final pdf = pw.Document();

    // Load Arabic font
    final fontData = await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf");
    final font = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.with  (defaultTextStyle: pw.TextStyle(font: font, fontSize: 12)),
        textDirection: pw.TextDirection.rtl,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                'تقرير الطلاب',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, font: font),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: [
                'الرقم',
                'الاسم',
                'رقم الهوية',
                'المحافظة',
                'التخصص',
                'المستوى',
                'الهاتف'
              ],
              data: students.map((student) => [
                student.id.toString(),
                student.name,
                student.idNumber,
                student.governorate ?? '',
                student.specialization ?? '',
                student.level ?? '',
                student.phone ?? '',
              ]).toList(),
              border: pw.TableBorder.all(color: PdfColors.black),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font),
              cellStyle: pw.TextStyle(font: font),
              columnWidths: {
                0: pw.FlexColumnWidth(0.5),
                1: pw.FlexColumnWidth(2),
                2: pw.FlexColumnWidth(1.5),
                3: pw.FlexColumnWidth(1.5),
                4: pw.FlexColumnWidth(1.5),
                5: pw.FlexColumnWidth(1),
                6: pw.FlexColumnWidth(1.5),
              },
              cellAlignments: {
                0: pw.Alignment.centerRight,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.centerRight,
                5: pw.Alignment.centerRight,
                6: pw.Alignment.centerRight,
              },
            ),
          ];
        },
      ),
    );
    return pdf.save();
  }

  Future<String> savePdf(Uint8List pdfBytes, String filename) async {
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/$filename');
    await file.writeAsBytes(pdfBytes);
    return file.path;
  }

  Future<void> sharePdf(String filePath) async {
    await Share.shareXFiles([XFile(filePath)], text: 'تقرير الطلاب');
  }
}
