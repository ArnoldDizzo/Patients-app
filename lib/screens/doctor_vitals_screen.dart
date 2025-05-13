import 'package:flutter/material.dart';
import '../models/vital_record.dart';
import '../services/auth_service.dart';
import '../services/vital_service.dart';
import '../widgets/vital_field.dart';
import '../widgets/vital_card.dart';

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
  
  final _authService = AuthService();
  final _vitalService = VitalService();

  void _saveVitals() async {
    if (_formKey.currentState!.validate()) {
      final record = VitalRecord(
        bloodPressure: _bpController.text,
        pulse: _pulseController.text,
        sugar: _sugarController.text,
        weight: _weightController.text,
        cholesterol: _cholesterolController.text,
        timestamp: DateTime.now(),
      );

      try {
        await _vitalService.addVitalRecord(record);
        
        // Clear the form
        _bpController.clear();
        _pulseController.clear();
        _sugarController.clear();
        _weightController.clear();
        _cholesterolController.clear();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vitals saved successfully'),
              backgroundColor: Colors.teal,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving vitals: ${e.toString()}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          );
        }
      }
    }
  }

  void _signOut() async {
    await _authService.signOut();
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
        title: const Text('Patient Vitals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enter New Vitals',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 16),
                      VitalField(
                        label: 'Blood Pressure (mmHg)',
                        controller: _bpController,
                        icon: Icons.favorite,
                      ),
                      const SizedBox(height: 12),
                      VitalField(
                        label: 'Pulse (bpm)',
                        controller: _pulseController,
                        icon: Icons.speed,
                      ),
                      const SizedBox(height: 12),
                      VitalField(
                        label: 'Blood Sugar (mg/dL)',
                        controller: _sugarController,
                        icon: Icons.water_drop,
                      ),
                      const SizedBox(height: 12),
                      VitalField(
                        label: 'Weight (kg)',
                        controller: _weightController,
                        icon: Icons.monitor_weight,
                      ),
                      const SizedBox(height: 12),
                      VitalField(
                        label: 'Cholesterol (mg/dL)',
                        controller: _cholesterolController,
                        icon: Icons.analytics,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _saveVitals,
                          icon: const Icon(Icons.save),
                          label: const Text('Save Vitals'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Recent Vitals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 12),
              StreamBuilder<List<VitalRecord>>(
                stream: _vitalService.getVitalRecords(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final records = snapshot.data ?? [];

                  if (records.isEmpty) {
                    return const Center(
                      child: Text('No vitals recorded yet'),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return VitalCard(
                        record: record,
                        onDelete: () => _vitalService.deleteVitalRecord(record.timestamp.toString()),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
} 