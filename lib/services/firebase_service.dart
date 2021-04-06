import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/stats.dart';

class FirebaseService {
  final StreamController<Stats> _statsController = StreamController<Stats>();

  FirebaseService() {
    FirebaseFirestore.instance
        .collection('informations')
        .doc('project_stats')
        .snapshots()
        .listen(_statsUpdated);
  }

  Stream<Stats> get appStats => _statsController.stream;

  void _statsUpdated(DocumentSnapshot snapshot) {
    _statsController.add(Stats.fromSnapshots(snapshot));
  }
}
