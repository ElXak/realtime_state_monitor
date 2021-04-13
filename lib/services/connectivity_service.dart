import 'dart:async';

import 'package:connectivity/connectivity.dart';

import '../enums/connectivity_status.dart';

class ConnectivityService {
  StreamController<ConnectivityStatus> connnectionStatusController =
      StreamController<ConnectivityStatus>();

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Convert this result to enum
      ConnectivityStatus connectionStatus = _getStatusFromResult(result);

      // Emit this over stream
      connnectionStatusController.add(connectionStatus);
    });
  }

  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
        break;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
        break;
      case ConnectivityResult.none:
      default:
        return ConnectivityStatus.Offline;
    }
  }
}
