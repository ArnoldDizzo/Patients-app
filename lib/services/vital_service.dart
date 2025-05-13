import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vital_record.dart';

class VitalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'vitals';

  // Add a new vital record
  Future<void> addVitalRecord(VitalRecord record) async {
    await _firestore.collection(_collection).add(record.toMap());
  }

  // Get vital records stream
  Stream<List<VitalRecord>> getVitalRecords() {
    return _firestore
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => VitalRecord.fromMap(doc.data()))
          .toList();
    });
  }

  // Delete a vital record
  Future<void> deleteVitalRecord(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  // Update a vital record
  Future<void> updateVitalRecord(String id, VitalRecord record) async {
    await _firestore.collection(_collection).doc(id).update(record.toMap());
  }
} 