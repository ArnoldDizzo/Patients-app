import 'package:flutter/material.dart';
import '../models/vital_record.dart';

class VitalCard extends StatelessWidget {
  final VitalRecord record;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const VitalCard({
    super.key,
    required this.record,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Vitals Record',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    if (onEdit != null)
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.teal),
                        onPressed: onEdit,
                      ),
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: onDelete,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildVitalRow('Blood Pressure', record.bloodPressure, 'mmHg'),
            _buildVitalRow('Pulse', record.pulse, 'bpm'),
            _buildVitalRow('Blood Sugar', record.sugar, 'mg/dL'),
            _buildVitalRow('Weight', record.weight, 'kg'),
            _buildVitalRow('Cholesterol', record.cholesterol, 'mg/dL'),
            const SizedBox(height: 8),
            Text(
              record.timestamp.toString().split('.')[0],
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalRow(String label, String value, String unit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            '$value $unit',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 