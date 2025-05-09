import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PDFExporter {
  static Future<void> exportData({
    required List<Map<String, dynamic>> glucoseData,
    required List<Map<String, dynamic>> notesData,
    required List<Map<String, dynamic>> insulinData,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('Smart Insulin App Report')),

          pw.Header(level: 1, child: pw.Text('Glucose Levels (last 48h)')),
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
