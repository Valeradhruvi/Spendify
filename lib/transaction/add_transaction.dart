import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _amount = TextEditingController();
  String _type = "Expense";
  String? _category;
  String? _payment;
  DateTime? _date;

  final List<String> _categories = ['Food', 'Transport', 'Bills', 'Others'];
  final List<String> _methods = ['Cash', 'Card', 'UPI'];

  void _saveTransaction() {
    if (_formKey.currentState!.validate() && _date != null) {
      final tx = Transaction(
        title: _title.text,
        amount: double.parse(_amount.text),
        category: _category!,
        date: _date!,
        paymentMethod: _payment!,
        type: _type,
      );
      Navigator.pop(context, tx); // Send data back
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ADB5),
        title: const Text('Add Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildToggle(),
              const SizedBox(height: 20),
              _buildField(_title, "Title"),
              const SizedBox(height: 15),
              _buildField(_amount, "Amount", isNumber: true),
              const SizedBox(height: 15),
              _buildDropdown("Category", _categories, _category,
                      (val) => setState(() => _category = val)),
              const SizedBox(height: 15),
              _buildDatePicker(),
              const SizedBox(height: 15),
              _buildDropdown("Payment Method", _methods, _payment,
                      (val) => setState(() => _payment = val)),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00ADB5),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
                child: Text(
                  _type == 'Expense' ? "Save Expense" : "Save Income",
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text('Expense'),
          selected: _type == 'Expense',
          onSelected: (selected) {
            if (selected) setState(() => _type = 'Expense');
          },
        ),
        const SizedBox(width: 10),
        ChoiceChip(
          label: const Text('Income'),
          selected: _type == 'Income',
          onSelected: (selected) {
            if (selected) setState(() => _type = 'Income');
          },
        ),
      ],
    );
  }

  Widget _buildField(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white24),
        ),
      ),
      validator: (value) =>
      (value == null || value.trim().isEmpty) ? 'Required' : null,
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value,
      Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color(0xFF162447),
      items: items
          .map((item) =>
          DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(color: Colors.white))))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      validator: (value) => value == null ? 'Required' : null,
    );
  }

  Widget _buildDatePicker() {
    return Row(
      children: [
        const Icon(Icons.calendar_today, color: Colors.white70),
        const SizedBox(width: 10),
        Expanded(
          child: TextButton(
            onPressed: () async {
              final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100));
              if (picked != null) {
                setState(() {
                  _date = picked;
                });
              }
            },
            child: Text(
              _date == null
                  ? "Select Date"
                  : DateFormat('yyyy-MM-dd').format(_date!),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
