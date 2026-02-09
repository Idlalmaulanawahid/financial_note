import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_entity.dart';

class PdfExportService {
  PdfExportService._();

  /// Generate PDF file and return the File object.
  static Future<File> generatePdf({
    required List<TransactionEntity> transactions,
    required List<CategoryEntity> categories,
    required int year,
    required int month,
    required double totalIncome,
    required double totalExpense,
  }) async {
    final pdf = pw.Document();
    final monthName =
        DateFormat('MMMM yyyy', 'id_ID').format(DateTime(year, month));
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final categoryMap = {
      for (final c in categories) c.id: c.name,
    };

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Laporan Keuangan - $monthName',
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 10),
          _buildSummaryTable(
            currencyFormat: currencyFormat,
            totalIncome: totalIncome,
            totalExpense: totalExpense,
          ),
          pw.SizedBox(height: 20),
          pw.Header(level: 1, text: 'Detail Transaksi'),
          pw.SizedBox(height: 8),
          _buildTransactionTable(
            transactions: transactions,
            categoryMap: categoryMap,
            currencyFormat: currencyFormat,
          ),
        ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Financial Privacy - Halaman ${context.pageNumber}/${context.pagesCount}',
            style:
                const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'laporan_${year}_$month.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  /// Open PDF with the device's default PDF viewer.
  static Future<void> openPdf(File file) async {
    await OpenFilex.open(file.path, type: 'application/pdf');
  }

  /// Share PDF via the native share sheet (WhatsApp, Email, etc.)
  /// [origin] is required on iPad to anchor the share popover.
  static Future<void> sharePdf(
    File file, {
    int? year,
    int? month,
    required Rect origin,
  }) async {
    String text = 'Laporan Keuangan';
    if (year != null && month != null) {
      text = 'Laporan Keuangan ${DateFormat('MMMM yyyy', 'id_ID').format(DateTime(year, month))}';
    }

    await Share.shareXFiles(
      [XFile(file.path)],
      text: text,
      sharePositionOrigin: origin,
    );
  }

  static pw.Widget _buildSummaryTable({
    required NumberFormat currencyFormat,
    required double totalIncome,
    required double totalExpense,
  }) {
    final balance = totalIncome - totalExpense;

    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
      cellPadding: const pw.EdgeInsets.all(8),
      data: [
        ['Keterangan', 'Jumlah'],
        ['Total Pemasukan', currencyFormat.format(totalIncome)],
        ['Total Pengeluaran', currencyFormat.format(totalExpense)],
        ['Saldo', currencyFormat.format(balance)],
      ],
    );
  }

  static pw.Widget _buildTransactionTable({
    required List<TransactionEntity> transactions,
    required Map<int?, String> categoryMap,
    required NumberFormat currencyFormat,
  }) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return pw.TableHelper.fromTextArray(
      headerStyle:
          pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      cellStyle: const pw.TextStyle(fontSize: 9),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
      cellPadding: const pw.EdgeInsets.all(6),
      headers: ['Tanggal', 'Judul', 'Kategori', 'Tipe', 'Jumlah'],
      data: transactions.map((t) {
        return [
          dateFormat.format(t.date),
          t.title,
          categoryMap[t.categoryId] ?? '-',
          t.type == 'income' ? 'Masuk' : 'Keluar',
          currencyFormat.format(t.amount),
        ];
      }).toList(),
    );
  }
}
