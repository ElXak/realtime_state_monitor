import 'package:flutter/material.dart';
import 'package:realtime_state_monitor/ui/shared/ui_reducers.dart';
import 'package:realtime_state_monitor/ui/views/feedback_view.dart';
import 'package:realtime_state_monitor/ui/widgets/indicator_button.dart';
import 'package:realtime_state_monitor/ui/widgets/stats_counter.dart';
import 'package:realtime_state_monitor/ui/widgets/watcher_toolbar.dart';

import '../../scoped_models/base_model.dart';
import '../../scoped_models/home_view_model.dart';
import '../shared/app_colors.dart';
import 'base_view.dart';

class HomeView extends StatelessWidget {
  static const BoxDecoration topLineBorderDecoration = BoxDecoration(
      border: Border(
          top: BorderSide(
              color: lightGrey, style: BorderStyle.solid, width: 5)));

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      builder: (context, child, model) => Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: _getBody(model, context)),
    );
  }

  Widget _getBody(HomeViewModel model, BuildContext context) {
    switch (model.state) {
      case ViewState.Busy:
      case ViewState.Idle:
        return Center(
          child: CircularProgressIndicator(),
        );
        break;
      default:
        return _getStatusUi(model, context);
    }
  }

  Widget _getStatusUi(HomeViewModel model, BuildContext context) {
    return Column(
      children: [
        WatcherToolbar(title: 'SKELETON-WATCHER'),
        _getHeightContainer(
          context: context,
          height:
              screenHeight(context, dividedBy: 2, decreasedBy: toolbarHeight),
          child: StatsCounter(
            size: screenHeight(context,
                    dividedBy: 2, decreasedBy: toolbarHeight) -
                60,
            count: model.appStats.errorCount,
            title: 'Errors',
            titleColor: Colors.red,
          ),
        ),
        _getHeightContainer(
          context: context,
          height:
              screenHeight(context, dividedBy: 3, decreasedBy: toolbarHeight),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatsCounter(
                size: screenHeight(context,
                        dividedBy: 3, decreasedBy: toolbarHeight) -
                    60,
                count: model.appStats.userCount,
                title: 'Users',
              ),
              StatsCounter(
                size: screenHeight(context,
                        dividedBy: 3, decreasedBy: toolbarHeight) -
                    60,
                count: model.appStats.appCount,
                title: 'Apps Created',
              ),
            ],
          ),
        ),
        _getHeightContainer(
          context: context,
          height:
              screenHeight(context, dividedBy: 6, decreasedBy: toolbarHeight),
          child: IndicatorButton(
            title: 'FEEDBACK',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => FeedbackView())),
          ),
        ),
      ],
    );
  }

  Widget _getHeightContainer(
      {BuildContext context,
      double height,
      Widget child,
      bool hasTopStroke = false}) {
    return Container(
      height: height,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: hasTopStroke ? topLineBorderDecoration : null,
      child: child,
    );
  }
}
