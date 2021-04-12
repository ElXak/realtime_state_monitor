import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/stats.dart';
import '../models/user_feedback.dart';

class FirebaseService {
  final StreamController<Stats> _statsController = StreamController<Stats>();
  final StreamController<List<UserFeedback>> _feedbackController =
      StreamController<List<UserFeedback>>();
  final StreamController<int> _unreadController = StreamController<int>();

  FirebaseService() {
    FirebaseFirestore.instance
        .collection('informations')
        .doc('project_stats')
        .snapshots()
        .listen(_statsUpdated);

    FirebaseFirestore.instance
        .collection('feedback')
        .where('open', isEqualTo: true)
        .snapshots()
        .listen(_feedbackAdded);
  }

  Stream<Stats> get appStats => _statsController.stream;

  Stream<List<UserFeedback>> get feedback => _feedbackController.stream;

  Stream<int> get unreadCount => _unreadController.stream;

  void markFeedbackAsRead({String feedbackId}) {
    FirebaseFirestore.instance
        .collection('feedback')
        .doc(feedbackId)
        .update({'read': true});
  }

  void _statsUpdated(DocumentSnapshot snapshot) {
    _statsController.add(Stats.fromSnapshots(snapshot));
  }

  void _feedbackAdded(QuerySnapshot snapshot) {
    List<UserFeedback> feedback = _getFeedbackFromSnapshot(snapshot);
    _feedbackController.add(feedback);
    _emitUnreadCount(feedback);
  }

  List<UserFeedback> _getFeedbackFromSnapshot(QuerySnapshot snapshot) {
    List<UserFeedback> feedbackItems = [];
    List<QueryDocumentSnapshot> documents = snapshot.docs;

    bool hasDocuments = documents.length > 0;

    if (hasDocuments) {
      for (QueryDocumentSnapshot document in documents) {
        Map<String, dynamic> documentData = document.data();
        documentData['id'] = document.id;
        feedbackItems.add(UserFeedback.fromData(documentData));
      }
    }

    return feedbackItems;
  }

  void _emitUnreadCount(List<UserFeedback> userFeedback) {
    int unreadCount = userFeedback.where((item) => !item.read).length;
    _unreadController.add(unreadCount);
  }
}
