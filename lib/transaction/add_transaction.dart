import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:spendify/dashboard/screen/home_screen.dart';

class AddTransactionScreen extends StatefulWidget {
  final bool isAccountActive;
  final Function(Transaction) onTransactionSaved;

  const AddTransactionScreen({
    super.key,
    this.isAccountActive = true,
    required this.onTransactionSaved,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String _transactionType = 'Expense';
  String? _selectedCategory;
  String? _selectedPaymentMethod;
  DateTime? _selectedDate;
  String? _dateError;

  final List<String> _categories = ['Food', 'Transport', 'Shopping', 'Bills', 'Others'];
  final List<String> _paymentMethods = ['Cash', 'Card', 'UPI', 'Wallet'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ADB5),
        title: const Text("Add Transaction"),
      ),
      body: widget.isAccountActive ? _buildForm() : _buildDeactivatedNotice(),
    );
  }

  Widget _buildDeactivatedNotice() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.block, color: Colors.redAccent, size: 80),
            const SizedBox(height: 20),
            Text(
              "Your account is deactivated",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              "Please contact admin at: +91 98765 43210",
              style: GoogleFonts.poppins(color: Colors.white70),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTransactionTypeToggle(),
            const SizedBox(height: 20),
            _buildInputField(_titleController, "Title"),
            const SizedBox(height: 15),
            _buildInputField(_amountController, "Amount", isNumber: true),
            const SizedBox(height: 15),
            _buildDropdown("Category", _categories, _selectedCategory, (val) {
              setState(() => _selectedCategory = val);
            }),
            const SizedBox(height: 15),
            _buildDatePicker(),
            const SizedBox(height: 15),
            _buildDropdown("Payment Method", _paymentMethods, _selectedPaymentMethod, (val) {
              setState(() => _selectedPaymentMethod = val);
            }),
            const SizedBox(height: 15),
            TextFormField(
              controller: _noteController,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Note (Optional)",
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_dateError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _dateError!,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00ADB5),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: Text(
                _transactionType == 'Expense' ? "Save Expense" : "Save Income",
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTypeToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text('Expense'),
          selected: _transactionType == 'Expense',
          onSelected: (selected) {
            if (selected) setState(() => _transactionType = 'Expense');
          },
          selectedColor: const Color(0xFF00ADB5),
          labelStyle: const TextStyle(color: Colors.white),
          backgroundColor: const Color(0xFF162447),
        ),
        const SizedBox(width: 10),
        ChoiceChip(
          label: const Text('Income'),
          selected: _transactionType == 'Income',
          onSelected: (selected) {
            if (selected) setState(() => _transactionType = 'Income');
          },
          selectedColor: const Color(0xFF00ADB5),
          labelStyle: const TextStyle(color: Colors.white),
          backgroundColor: const Color(0xFF162447),
        ),
      ],
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      validator: (value) {
        if (label == "Note (Optional)") return null;
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }
        if (isNumber && double.tryParse(value.trim()) == null) {
          return 'Enter a valid number';
        }
        return null;
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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      validator: (value) => value == null ? 'Select a $label' : null,
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
                  _selectedDate = picked;
                  _dateError = null;
                });
              }
            },
            child: Text(
              _selectedDate == null
                  ? "Select Date"
                  : DateFormat('yyyy-MM-dd').format(_selectedDate!),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    setState(() => _dateError = null);
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        setState(() => _dateError = 'Please select a date');
        return;
      }

      final tx = Transaction(
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory!,
        date: _selectedDate!,
        paymentMethod: _selectedPaymentMethod!,
        type: _transactionType,
      );

      widget.onTransactionSaved(tx);
    }
  }
}