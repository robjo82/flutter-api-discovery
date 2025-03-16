import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  final Color? backgroundColor;
  final double borderRadius;
  final DateTime? initialMinDate;
  final DateTime? initialMaxDate;

  const DatePicker(
      {super.key,
      required this.backgroundColor,
      required this.borderRadius,
      this.initialMinDate,
      this.initialMaxDate});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? _selectedMinDate;
  DateTime? _selectedMaxDate;

  @override
  void initState() {
    super.initState();
    _selectedMinDate = widget.initialMinDate;
    _selectedMaxDate = widget.initialMaxDate;
  }

  Future<void> _selectMinDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedMinDate) {
      setState(() {
        _selectedMinDate = picked;
      });
    }
  }

  Future<void> _selectMaxDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedMaxDate) {
      setState(() {
        _selectedMaxDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      child: Row(
        children: [
          const Icon(Icons.calendar_month,
              color: Colors.grey),
          const SizedBox(width: 8.0),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => _selectMinDate(context),
                child: Text(_selectedMinDate == null
                    ? 'Minimum date'
                    : '${_selectedMinDate?.day}/${_selectedMinDate?.month}/${_selectedMinDate?.year}'),
              ),
              const Text("-"),
              TextButton(
                onPressed: () => _selectMaxDate(context),
                child: Text(_selectedMaxDate == null
                    ? 'Maximum date'
                    : '${_selectedMaxDate?.day}/${_selectedMaxDate?.month}/${_selectedMaxDate?.year}'),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
