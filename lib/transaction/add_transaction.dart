import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:spendify/functions/database_fucntions.dart';

import '../model/transaction_model.dart';


class AddTransactionScreen extends StatefulWidget {
  final Transactions? transaction;
  const AddTransactionScreen({super.key, this.transaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  final userId='101';
  String _type = "Expense";
  String? _category;
  String? _payment;
  DateTime? _date;
  String? _dateError;

  final List<String> _categories = [
    'Food', 'Travel', 'Shopping', 'Bills','Salary',
    'Entertainment', 'Medical', 'Study', 'Others'
  ];

  final List<String> _methods = [
    'Cash', 'Credit Card', 'Debit Card',
    'Bank Transfer', 'Net Banking', 'UPI', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _title.text = widget.transaction!.title;
      _amount.text = widget.transaction!.amount.toString();
      _note.text = widget.transaction!.note ?? '';
      _type = widget.transaction!.type;
      _category = widget.transaction!.category;
      _payment = widget.transaction!.paymentMethod;
      _date = widget.transaction!.date;
    }
  }

  void _saveTransaction() async {
    setState(() => _dateError = null);

    if (_formKey.currentState!.validate()) {
      if (_date == null) {
        setState(() => _dateError = 'Please select a date');
        return;
      }

      if (double.tryParse(_amount.text) == null || double.parse(_amount.text) <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a valid amount")),
        );
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await createTransactionData(
          userId: userId,
          title: _title.text.trim(),
          amount: _amount.text.trim(),
          category: _category!,
          date: _date!,
          type: _type,
          note: _note.text.trim(),
          paymentMethod: _payment!,
        );

        print('Transaction saved successfully');
        Navigator.pushNamed(context, '/bottomnavbar');
      }
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
              _buildDropdown("Category", _categories, _category, (val) => setState(() => _category = val)),
              const SizedBox(height: 15),
              _buildDatePicker(),
              if (_dateError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(_dateError!, style: const TextStyle(color: Colors.redAccent)),
                ),
              const SizedBox(height: 15),
              _buildDropdown("Payment Method", _methods, _payment, (val) => setState(() => _payment = val)),
              const SizedBox(height: 15),
              _buildField(_note, "Note (Optional)"),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00ADB5),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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

  Widget _buildField(TextEditingController controller, String label, {bool isNumber = false}) {
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
      validator: (value) {
        if (label == "Note (Optional)") return null;
        return (value == null || value.trim().isEmpty) ? 'Required' : null;
      },
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color(0xFF162447),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(color: Colors.white))))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
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
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() {
                  _date = picked;
                  _dateError = null;
                });
              }
            },
            child: Text(
              _date == null ? "Select Date" : DateFormat('yyyy-MM-dd').format(_date!),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}