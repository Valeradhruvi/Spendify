// bank_sync_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'csv_preview_screen.dart';

class BankSyncScreen extends StatefulWidget {
  const BankSyncScreen({super.key});

  @override
  State<BankSyncScreen> createState() => _BankSyncScreenState();
}

class _BankSyncScreenState extends State<BankSyncScreen> {
  File? _selectedFile;
  String? _fileName;

  Future<void> _pickCSVFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
      });
    }
  }

  void _goToPreviewScreen() async {
    if (_selectedFile == null) return;

    final csvContent = await _selectedFile!.readAsString();
    final List<List<dynamic>> rows = const CsvToListConverter().convert(csvContent);

    List<Transaction> parsedTransactions = [];
    for (var row in rows.skip(1)) {
      try {
        parsedTransactions.add(Transaction(
          title: row[0],
          amount: double.tryParse(row[1].toString()) ?? 0,
          category: row[2],
          date: DateTime.parse(row[3]),
          paymentMethod: row[4],
          type: row[5],
          note: row[6],
        ));
      } catch (_) {}
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CSVPreviewScreen(transactions: parsedTransactions),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ADB5),
        title: const Text("Bank Sync (CSV Upload)"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Import Transactions",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("CSV Format: Title, Amount, Category, Date, Payment Method, Type, Note",
                style: GoogleFonts.poppins(color: Colors.white70)),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00ADB5)),
                icon: const Icon(Icons.upload_file),
                label: const Text("Select CSV File"),
                onPressed: _pickCSVFile,
              ),
            ),
            const SizedBox(height: 20),
            if (_fileName != null)
              Center(
                child: Text("Selected File: $_fileName", style: GoogleFonts.poppins(color: Colors.greenAccent)),
              ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: _goToPreviewScreen,
                child: const Text("Preview Transactions"),
              ),
            )
          ],
        ),
      ),
    );
  }
}