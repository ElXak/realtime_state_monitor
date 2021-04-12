import 'package:flutter/material.dart';

import '../models/user_feedback.dart';
import '../service_locator.dart';
import '../services/firebase_service.dart';
import 'base_model.dart';

/// Contains logic for a list view with the general expected functionality.
class FeedbackViewModel extends BaseModel {
/*
  List<ListItem> listData;

  Future fetchListData() async {
    setState(ViewState.Busy);

    await Future.delayed(Duration(seconds: 1));
    listData = List<ListItem>.generate(
        10,
        (index) => ListItem(
            title: 'title $index',
            description: 'Description of this list Item. $index'));

    if (listData == null) {
      setState(ViewState.Error);
    } else {
      setState(listData.length == 0
          ? ViewState.NoDataAvailable
          : ViewState.DataFetched);
    }
  }
*/

  FirebaseService _firebaseService = locator<FirebaseService>();
  List<UserFeedback> userFeedback;

  FeedbackViewModel() {
    _firebaseService.feedback.listen(_onFeedbackUpdated);
  }

  void markFeedbackAsRead({@required String feedbackId}) {
    _firebaseService.markFeedbackAsRead(feedbackId: feedbackId);
  }

  void _onFeedbackUpdated(List<UserFeedback> feedback) {
    userFeedback = feedback;

    if (userFeedback == null)
      setState(ViewState.Busy);
    else
      setState(userFeedback.length == 0
          ? ViewState.NoDataAvailable
          : ViewState.DataFetched);
  }
}
