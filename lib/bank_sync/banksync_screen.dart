import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart' show CsvToListConverter;
import 'package:spendify/model/transaction_model.dart' as model;
import 'csv_preview_screen.dart';

class BankSyncScreen extends StatefulWidget {
  const BankSyncScreen({super.key});

  @override
  State<BankSyncScreen> createState() => _BankSyncScreenState();
}

class _BankSyncScreenState extends State<BankSyncScreen> {
  File? _selectedFile;
  String? _fileName;

  List<model.Transaction> globalTransactionList = [];

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

    try {
      final csvContent = await _selectedFile!.readAsString();

      final rows = const CsvToListConverter(
        shouldParseNumbers: false,
      ).convert(csvContent);

      List<model.Transaction> parsedTransactions = [];

      for (var row in rows.skip(1)) {
        if (row.length >= 6) {
          try {
            final tx = model.Transaction(
              title: row[0]?.toString() ?? '',
              amount: double.tryParse(row[1].toString()) ?? 0,
              category: row[2]?.toString() ?? '',
              date: DateTime.tryParse(row[3].toString()) ?? DateTime.now(),
              paymentMethod: row[4]?.toString() ?? '',
              type: row[5]?.toString() ?? 'Expense',
              note: row.length > 6 ? row[6]?.toString() : '',
            );

            parsedTransactions.add(tx);
          } catch (e) {
            debugPrint("Skipping invalid row: $e");
          }
        }
      }

      if (!mounted) return; // <- ✅ Prevents UI update if screen is disposed

      if (parsedTransactions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No valid transactions found in CSV.")),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CSVPreviewScreen(
            parsedTransactions: parsedTransactions,
            onConfirmImport: (List<model.Transaction> importedTransactions) {
              // Example using a global or singleton list (temporary static solution)
              for (var tx in importedTransactions) {
                globalTransactionList.add(tx);
              }

              // Optionally show a confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Transactions imported successfully")),
              );

              // Navigate to summary screen or pop
              Navigator.pop(context); // Or navigate to ImportSummaryScreen
            },
          ),
        ),
      );

    } catch (e) {
      if (!mounted) return; // <- ✅ Prevents render error after async

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to parse CSV: $e")),
      );
    }
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
