import 'package:flutter/material.dart';
import 'package:realtime_state_monitor/ui/shared/ui_reducers.dart';
import 'package:realtime_state_monitor/ui/widgets/feedback_item.dart';
import 'package:realtime_state_monitor/ui/widgets/watcher_toolbar.dart';

import '../../enums/view_state.dart';
import '../../models/user_feedback.dart';
import '../../scoped_models/feedback_view_model.dart';
import '../shared/font_styles.dart';
import 'base_view.dart';

class FeedbackView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<FeedbackViewModel>(
        // onModelReady: (model) => model.fetchListData(),
        builder: (context, child, model) => Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: Column(
              children: [
                WatcherToolbar(title: 'FEEDBACK', showBackButton: true),
                Container(
                    height: screenHeight(context, decreasedBy: toolbarHeight),
                    child: _getBodyUi(context, model)),
              ],
            )));
  }

  Widget _getBodyUi(BuildContext context, FeedbackViewModel model) {
    switch (model.state) {
      case ViewState.Busy:
        return _getLoadingUi(context);
      case ViewState.NoDataAvailable:
        return _noDataUi(context, model);
      case ViewState.Error:
        return _errorUi(context, model);
      case ViewState.DataFetched:
      default:
        return _getListUi(model);
    }
  }

  Widget _getListUi(FeedbackViewModel model) {
    return ListView.builder(
        // itemCount: model.listData.length,
        itemCount: model.userFeedback.length,
        itemBuilder: (context, itemIndex) {
          // var item = model.listData[itemIndex];
          UserFeedback feedbackItem = model.userFeedback[itemIndex];
          // return _getListItemUi(item);
          return FeedbackItem(
            feedbackItem: feedbackItem,
            onOpened: (feedbackId) =>
                model.markFeedbackAsRead(feedbackId: feedbackId),
          );
        });
  }

/*
  Container _getListItemUi(ListItem result) {
    return Container(
      height: 100.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: lightGrey),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(result.title, style: viewTitle),
          Text(result.description)
        ],
      ),
    );
  }
*/

  Widget _getLoadingUi(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
        Text('Fetching data ...')
      ],
    ));
  }

  Widget _noDataUi(BuildContext context, FeedbackViewModel model) {
    return _getCenteredViewMessage(context, "No data available yet", model);
  }

  Widget _errorUi(BuildContext context, FeedbackViewModel model) {
    return _getCenteredViewMessage(
        context, "Error retrieving your data. Tap to try again", model,
        error: true);
  }

  Widget _getCenteredViewMessage(
      BuildContext context, String message, FeedbackViewModel model,
      {bool error = false}) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  message,
                  style: viewErrorTitle,
                  textAlign: TextAlign.center,
                ),
                error
                    ? Icon(
                        // WWrap in gesture detector and call you refresh future here
                        Icons.refresh,
                        color: Colors.white,
                        size: 45.0,
                      )
                    : Container()
              ],
            )));
  }
}
