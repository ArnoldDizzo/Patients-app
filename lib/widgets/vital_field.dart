import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/validators.dart';
import '../utils/input_formatters.dart';

class VitalField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final String? unit;
  final bool showUnitWhileTyping;
  final TextInputFormatter? inputFormatter;

  const VitalField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.validator,
    this.keyboardType = TextInputType.number,
    this.unit,
    this.showUnitWhileTyping = false,
    this.inputFormatter,
  });

  factory VitalField.bloodPressure({
    required TextEditingController controller,
  }) {
    return VitalField(
      label: 'Blood Pressure',
      controller: controller,
      icon: Icons.favorite,
      validator: Validators.validateBloodPressure,
      inputFormatter: InputFormatters.bloodPressureFormatter(),
      unit: 'mmHg',
      showUnitWhileTyping: true,
    );
  }

  factory VitalField.pulse({
    required TextEditingController controller,
  }) {
    return VitalField(
      label: 'Pulse',
      controller: controller,
      icon: Icons.speed,
      validator: Validators.validatePulse,
      inputFormatter: InputFormatters.numberFormatter(
        maxValue: 200,
        minValue: 40,
      ),
      unit: 'bpm',
      showUnitWhileTyping: true,
    );
  }

  factory VitalField.bloodSugar({
    required TextEditingController controller,
  }) {
    return VitalField(
      label: 'Blood Sugar',
      controller: controller,
      icon: Icons.water_drop,
      validator: Validators.validateBloodSugar,
      inputFormatter: InputFormatters.numberFormatter(
        maxValue: 300,
        minValue: 70,
      ),
      unit: 'mg/dL',
      showUnitWhileTyping: true,
    );
  }

  factory VitalField.weight({
    required TextEditingController controller,
  }) {
    return VitalField(
      label: 'Weight',
      controller: controller,
      icon: Icons.monitor_weight,
      validator: Validators.validateWeight,
      inputFormatter: InputFormatters.decimalFormatter(
        maxValue: 300,
        minValue: 20,
        decimalPlaces: 1,
      ),
      unit: 'kg',
      showUnitWhileTyping: true,
    );
  }

  factory VitalField.cholesterol({
    required TextEditingController controller,
  }) {
    return VitalField(
      label: 'Cholesterol',
      controller: controller,
      icon: Icons.analytics,
      validator: Validators.validateCholesterol,
      inputFormatter: InputFormatters.numberFormatter(
        maxValue: 400,
        minValue: 100,
      ),
      unit: 'mg/dL',
      showUnitWhileTyping: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal),
        suffixText: showUnitWhileTyping ? unit : null,
        helperText: !showUnitWhileTyping ? unit : null,
        helperStyle: const TextStyle(color: Colors.grey),
      ),
      keyboardType: keyboardType,
      controller: controller,
      validator: validator ?? (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
      inputFormatters: inputFormatter != null ? [inputFormatter!] : null,
    );
  }
} 