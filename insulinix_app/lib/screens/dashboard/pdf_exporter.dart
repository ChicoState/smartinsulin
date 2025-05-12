import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PDFExporter {
  static Future<void> exportData({
    required List<Map<String, dynamic>> glucoseData,
    required List<Map<String, dynamic>> notesData,
    required List<Map<String, dynamic>> insulinData,
    required List<Map<String, dynamic>> mealData,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('Smart Insulin App Report')),

          pw.Header(level: 1, child: pw.Text('Glucose Levels (Last 48 Hours)')),
          pw.Table.fromTextArray(
            headers: ['Time', 'Glucose (mg/dL)'],
            data: glucoseData.map((g) => [g['time'], g['value'].toString()]).toList(),
          ),

          pw.SizedBox(height: 20),

          pw.Header(level: 1, child: pw.Text('Notes')),
          pw.Table.fromTextArray(
            headers: ['Date', 'Note'],
            data: notesData.map((n) => [n['date'], n['note']]).toList(),
          ),

          pw.SizedBox(height: 20),

          pw.Header(level: 1, child: pw.Text('Meal Log')),
          pw.Table.fromTextArray(
            headers: ['Time', 'Meal Description'],
            data: mealData.map((m) => [m['date'], m['text']]).toList(),
          ),

          pw.SizedBox(height: 20),

          pw.Header(level: 1, child: pw.Text('Insulin Deliveries')),
          pw.Table.fromTextArray(
            headers: ['Time', 'Amount (Units)'],
            data: insulinData.map((i) => [i['time'], i['units'].toString()]).toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
