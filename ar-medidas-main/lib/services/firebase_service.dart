import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/measurement.dart';

class MeasurementFirebaseService {
  static final _collection = FirebaseFirestore.instance.collection(
    'measurements',
  );

  static Future<void> addMeasurement(Measurement measurement) async {
    await _collection.add({
      'timestamp': measurement.timestamp.toIso8601String(),
      'totalDistance': measurement.totalDistance,
      'unit': measurement.unit,
    });
  }

  static Future<List<Measurement>> getAll() async {
    final snapshot = await _collection
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Measurement(
        timestamp: DateTime.parse(data['timestamp']),
        totalDistance: data['totalDistance'],
        unit: data['unit'],
      );
    }).toList();
  }

  static Future<void> removeMeasurement(Measurement measurement) async {
    final snapshot = await _collection
        .where('timestamp', isEqualTo: measurement.timestamp.toIso8601String())
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      await snapshot.docs.first.reference.delete();
    }
  }

  static Future<void> clearAllMeasurements() async {
    final snapshot = await _collection.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
