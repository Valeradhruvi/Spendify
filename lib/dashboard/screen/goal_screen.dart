import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final List<Map<String, dynamic>> _goals = [];
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _dateError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      appBar: AppBar(
        title: const Text("🎯 Your Goals"),
        backgroundColor: const Color(0xFF00ADB5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Set your savings goals",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: _goals.isEmpty
                  ? Center(
                child: Text(
                  "No goals added yet",
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
              )
                  : ListView.builder(
                itemCount: _goals.length,
                itemBuilder: (context, index) {
                  final goal = _goals[index];
                  return _buildGoalCard(goal);
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showAddGoalDialog,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Add New Goal", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00ADB5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(Map<String, dynamic> goal) {
    final target = double.parse(goal['amount']);
    final saved = double.parse(goal['saved']);
    final progress = saved / target;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF162447),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.track_changes, color: Colors.white70),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  goal['title'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                "₹${saved.toStringAsFixed(0)} / ₹${target.toStringAsFixed(0)}",
                style: GoogleFonts.poppins(color: Colors.white70),
              )
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress > 1 ? 1 : progress,
            backgroundColor: Colors.white10,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00ADB5)),
          ),
          const SizedBox(height: 10),
          Text(
            "Start: ${goal['start']} | End: ${goal['end']}",
            style: GoogleFonts.poppins(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            "📊 Suggested Monthly Saving: ₹${(target / 3).toStringAsFixed(0)}",
            style: GoogleFonts.poppins(color: Colors.greenAccent, fontSize: 13),
          )
        ],
      ),
    );
  }

  void _showAddGoalDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1B1B2F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Add Goal", style: GoogleFonts.poppins(color: Colors.white, fontSize: 20)),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Title",
                  labelStyle: TextStyle(color: Colors.white70),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter a goal title' : null,
              ),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Target Amount",
                  labelStyle: TextStyle(color: Colors.white70),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter an amount';
                  final num? parsed = num.tryParse(value);
                  return parsed == null || parsed <= 0 ? 'Enter valid amount' : null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
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
                          setState(() => _startDate = picked);
                        }
                      },
                      child: Text(
                        _startDate == null
                            ? "Start Date"
                            : DateFormat('yyyy-MM-dd').format(_startDate!),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
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
                          setState(() => _endDate = picked);
                        }
                      },
                      child: Text(
                        _endDate == null
                            ? "End Date"
                            : DateFormat('yyyy-MM-dd').format(_endDate!),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              if (_dateError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(_dateError!, style: const TextStyle(color: Colors.redAccent)),
                ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() => _dateError = null);

                  if (_formKey.currentState!.validate()) {
                    if (_startDate == null || _endDate == null) {
                      setState(() => _dateError = 'Please select start and end dates');
                      return;
                    }
                    if (_endDate!.isBefore(_startDate!)) {
                      setState(() => _dateError = 'End date must be after start date');
                      return;
                    }

                    setState(() {
                      _goals.add({
                        'title': _titleController.text,
                        'amount': _amountController.text,
                        'saved': '0',
                        'start': DateFormat('yyyy-MM-dd').format(_startDate!),
                        'end': DateFormat('yyyy-MM-dd').format(_endDate!),
                      });
                      _titleController.clear();
                      _amountController.clear();
                      _startDate = null;
                      _endDate = null;
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00ADB5)),
                child: const Text("Save", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}