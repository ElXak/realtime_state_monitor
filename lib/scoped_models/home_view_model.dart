import '../models/stats.dart';
import '../service_locator.dart';
import '../services/firebase_service.dart';
import 'base_model.dart';

class HomeViewModel extends BaseModel {
  FirebaseService _firebaseService = locator<FirebaseService>();

  Stats appStats;

  HomeViewModel() {
    _firebaseService.appStats.listen(_onStatusUpdated);
  }

  void _onStatusUpdated(Stats stats) {
    appStats = stats; // Set the stats for the UI

    if (stats == null) {
      setState(ViewState.Busy); // If null indicate we're still fetching
    } else {
      setState(ViewState
          .DataFetched); // When not null indicate that the data is fetched
    }
  }
}
