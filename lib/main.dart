import 'package:flutter/material.dart';

void main() {
  runApp(const PatientVitalsApp());
}

class PatientVitalsApp extends StatelessWidget {
  const PatientVitalsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Vitals',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DoctorVitalsScreen(),
    );
  }
}

// 🩺 Doctor Vitals Screen
class DoctorVitalsScreen extends StatefulWidget {
  const DoctorVitalsScreen({super.key});

  @override
  State<DoctorVitalsScreen> createState() => _DoctorVitalsScreenState();
}

class _DoctorVitalsScreenState extends State<DoctorVitalsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bpController = TextEditingController();
  final _pulseController = TextEditingController();
  final _sugarController = TextEditingController();
  final _weightController = TextEditingController();
  final _cholesterolController = TextEditingController();
  
  // Local storage for vitals
  final List<Map<String, String>> _savedVitals = [];

  void _saveVitals() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _savedVitals.insert(0, {
          'blood_pressure': _bpController.text,
          'pulse': _pulseController.text,
          'sugar': _sugarController.text,
          'weight': _weightController.text,
          'cholesterol': _cholesterolController.text,
          'timestamp': DateTime.now().toString(),
        });
        
        // Clear the form
        _bpController.clear();
        _pulseController.clear();
        _sugarController.clear();
        _weightController.clear();
        _cholesterolController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vitals saved locally')),
      );
    }
  }

  @override
  void dispose() {
    _bpController.dispose();
    _pulseController.dispose();
    _sugarController.dispose();
    _weightController.dispose();
    _cholesterolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Patient Vitals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField('Blood Pressure', _bpController),
              _buildField('Pulse', _pulseController),
              _buildField('Blood Sugar', _sugarController),
              _buildField('Weight (kg)', _weightController),
              _buildField('Cholesterol', _cholesterolController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveVitals,
                child: const Text('Save Vitals'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Saved Vitals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ..._savedVitals.map((data) => Card(
                child: ListTile(
                  title: Text(
                    "BP: ${data['blood_pressure']} | Pulse: ${data['pulse']}",
                  ),
                  subtitle: Text(
                    "Sugar: ${data['sugar']}, Weight: ${data['weight']}, Chol: ${data['cholesterol']}",
                  ),
                ),
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      controller: controller,
      validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }
}
